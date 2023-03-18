/**
     * Get Flow details from the FlowDefinitionView, FlowVersionView and FlowVariableView objects
     * 
     * This component also adds additional fields used in a Custom Object datatable in my Flow List View Flows 
     * 
     * 03/15/23 -   Eric Smith -    Version 2.0.3   Restrict types of Flows being queried to just those with a valid DurableId
     * 08/15/22 -   Eric Smith -    Version 2.0
     * 09/11/20 -   Eric Smith -    Version 1.2     Changed QUERY_LIMIT in Test mode to reduce change of SOQL 101 errors on installation
     * 05/29/20 -   Eric Smith -    Version 1.1     Created an Apex-Defined Descriptor Class for the Flow Information
     * 05/09/20 -   Eric Smith -    Version 1.0
     * 
     * Apex-Defined Variable Descriptor Class:      ers_FlowDatatableDesscriptor.cls
     * 
     */

    public with sharing class ers_GetFlowInfoAdvanced {

        Static Final Integer QUERY_LIMIT = 20;                 // Batch size for reading FlowDefinitionView records
        Static Final String ACTIVE_THEME = 'slds-theme_info';  // Display theme for Active Flows when displaying both Active & Inactive

        // Attributes passed in from the Flow
        public class Requests {
    
            @InvocableVariable(label='Type: "Flow", "ProcessBuilder" or "Both"')
            public String typeSelection;
    
            @InvocableVariable(label='Status: "Active", "Inactive" or "Both"')
            public String statusSelection;

            @InvocableVariable(label='Select API Names greater than or equal to this value')
            public String lowerBoundary; 
            
            @InvocableVariable(label='Select API Names less than or equal to this value')
            public String upperBoundary;
    
            @InvocableVariable(label='Specify slds-theme for the Active Flow rows (default: shade)')
            public String activeRowTheme;
        }

        // Attributes passed back to the Flow
        public class Results {
    
            @InvocableVariable
            public String flowVersionRecords;
    
            @InvocableVariable
            public List<ers_FlowDatatableDescriptor> recordCollection;
        }

        // Fields in FlowDefinitionView Object
        public class FlowDefInfo {
            String DurableId;
            String Label;
            String Description;
            String ApiName;
            String ProcessType;
            String LastModifiedBy;
            Datetime LastModifiedDate;
            String TriggerType;
        }

        // Fields in FlowVariableView Object
        public class FlowVarInfo {
            String ApiName;
            String DataType;
            String Description;
            String DurableId;
            String FlowVersionId;
            Boolean IsCollection;
            Boolean IsInput;
            Boolean IsOutput;
            String ObjectType;
        }
    
        @InvocableMethod
        public static List<Results> getFlowDetails(List<Requests> requestList) {

            // Instantiate the record variable & collection
            ers_FlowDatatableDescriptor fvi = new ers_FlowDatatableDescriptor();
            List<ers_FlowDatatableDescriptor> fvRecords = new List<ers_FlowDatatableDescriptor>();

            // Prepare the response to send back to the Flow
            Results response = new Results();
            List<Results> responseWrapper = new List<Results>();

            // Bulkify proccessing of multiple requests
            for (Requests req : requestList) {

                // Get Input Value(s)
                String typeSelection = req.typeSelection;
                String statusSelection = req.statusSelection;
                String lowerBoundary = req.lowerBoundary;
                String upperBoundary = req.upperBoundary;
                String activeRowTheme = req.activeRowTheme;
                
                // BEGIN APEX ACTION PROCESSING LOGIC
                if (activeRowTheme == null || activeRowTheme.length() < 1) {
                    activeRowTheme = ACTIVE_THEME;
                }
                if (!activeRowTheme.startsWith('slds-theme_')) {
                    activeRowTheme = 'slds-theme_' + activeRowTheme;
                }
    
                FlowDefInfo fdi = new FlowDefInfo();
                FlowVarInfo fvv = new FlowVarInfo();
                String lastDefinitionView;
                List<FlowDefInfo> fdRecords = new List<FlowDefInfo>();
                List<String> pbTypes = new List<String>();
                pbTypes.add('CustomEvent');
                pbTypes.add('InvocableProcess');
                pbTypes.add('Workflow');
                String pbTypeList = 'CustomEvent, InvocableProcess, Workflow';
                String ActiveString = 'Active';
                Boolean isMatch = true;
                String saveObjectType = '';
                String saveIconType = '';
                String saveIconStatus = '';
                String saveRowShadeValue;
    
                if(String.isEmpty(lowerBoundary)) {
                    lowerBoundary = 'A';
                }
                if(String.isEmpty(upperBoundary)) {
                    upperBoundary = 'Z'.repeat(255);
                }

                Integer q_limit = QUERY_LIMIT;
                if(Test.isRunningTest()) {
                    q_limit = 2;
                }

                // Set batch size for FlowDefinitionView Query
                Integer recordCount = [SELECT count() FROM FlowDefinitionView];
                Integer sizeBlock = recordCount/q_limit + (math.mod(recordCount,q_limit)!=0?1:0);
                Set<Id> fdvids = new Set<Id>();     // Store all FlowDefinitionView Ids
                Set<Id> fdvBatch = new Set<Id>();   // Store only current iteration of FlowDefinitionView Ids

                if(Test.isRunningTest()) {
                    sizeBlock = 1;
                }                
    
                for(Integer i=0;i<sizeBlock;i++){
                    for(FlowDefinitionView fd : [
                        SELECT  DurableId,
                                ActiveVersionId,
                                ApiName,
                                Builder,
                                Description,
                                InstalledPackageName,
                                IsActive,
                                IsOutOfDate,
                                IsTemplate,
                                Label,
                                LastModifiedBy,
                                LastModifiedDate,
                                LatestVersionId,
                                ManageableState,
                                NamespacePrefix,
                                ProcessType,
                                TriggerType
                        FROM    FlowDefinitionView 
                        WHERE   DurableId NOT IN:fdvids AND DurableId LIKE '300%'
                        ORDER BY Label ASC 
                        LIMIT   :q_limit]) {
                        try{
                            fdvids.add(fd.DurableId);            
                            if (lowerBoundary <= fd.ApiName && fd.ApiName <= upperBoundary) {
                                fdvBatch.add(fd.DurableId); 
                                fdi.DurableId = fd.DurableId;
                                fdi.ApiName = fd.ApiName;                    
                                fdi.LastModifiedBy = fd.LastModifiedBy;
                                fdi.TriggerType = fd.TriggerType;
                                fdRecords.add(fdi);
                                fdi = new FlowDefInfo();
                            }
                        } catch(Exception e) {
                            System.Debug('Exception('+fd.DurableId+') '+e); 
                        }
                    }
                    lastDefinitionView = '';
    
                    for(FlowVersionView fv : [
                        SELECT  DurableId, 
                                Description, 
                                FlowDefinitionViewId, 
                                IsTemplate, 
                                Label, 
                                LastModifiedDate, 
                                ProcessType, 
                                RunInMode, 
                                Status, 
                                VersionNumber
                        FROM    FlowVersionView
                        WHERE   FlowDefinitionViewId IN:fdvBatch 
                        ORDER BY FlowDefinitionViewId ASC
                        ]) {
    
                        // Check Type and Status parameters
                        isMatch = true;
                        if(typeSelection == 'Flow' && pbTypes.indexOf(fv.ProcessType) != -1) isMatch = false;
                        if(typeSelection == 'ProcessBuilder' && pbTypes.indexOf(fv.ProcessType) == -1) isMatch = false;
                        if(statusSelection == 'Active' && fv.Status != 'Active') isMatch = false;
                        if(statusSelection == 'Inactive' && fv.Status == 'Active') isMatch = false;
                                        
                        if(isMatch) {
                            // FlowVersionView Fields
                            fvi.DurableId = fv.DurableId;
                            fvi.Description = fv.Description;
                            fvi.FlowDefinitionViewId = fv.FlowDefinitionViewId;
                            fvi.IsTemplate = fv.IsTemplate;
                            fvi.Label = fv.Label;
                            fvi.Label_name = fv.Label;
                            fvi.Label_lookup = (pbTypeList.contains(fv.ProcessType)) 
                                ? '.lightning.force.com/processui/processui.app' 
                                : '.lightning.force.com/builder_platform_interaction/flowBuilder.app?flowId='+fv.DurableId;
                            fvi.LastModifiedDate = fv.LastModifiedDate;
                            fvi.ProcessType = fv.ProcessType;
                            fvi.Status = fv.Status;
                            fvi.VersionNumber = fv.VersionNumber;
                            fvi.FlowStatusIcon = (fv.status == 'Active') ? 'utility:undeprecate' : 'utility:deprecate';
    
                            // FlowDefinitionView Fields
                            for(FlowDefInfo fdr : fdRecords) {
                                if(fdr.DurableId == fv.FlowDefinitionViewId) {
                                    fvi.ApiName = fdr.ApiName;
                                    fvi.LastModifiedBy = fdr.LastModifiedBy;
                                    fvi.TriggerType = fdr.TriggerType;
                                    break;
                                }
                            }
    
                            // FlowVariableView Fields
                            saveRowShadeValue = 'slds-theme_default';
                            if(lastDefinitionView != fv.FlowDefinitionViewId) {   
                                saveRowShadeValue = (statusSelection == 'Both' && fv.Status == 'Active') ? activeRowTheme : 'slds-theme_default' ;
                                switch on fv.ProcessType {
                                    when 'CustomEvent', 'InvocableProcess', 'Workflow' {    //Process Builder
                                        saveIconType = 'utility:process';
                                        for(FlowVariableView fr : [
                                            SELECT  ObjectType 
                                            FROM    FlowVariableView 
                                            WHERE   (FlowVersionViewId = :fv.DurableId) AND 
                                                    (ApiName = 'myVariable_current')
                                            LIMIT   1]) {
                                            saveObjectType = fr.ObjectType;
                                        } 
                                    }
                                    when else {                                             //Flow
                                        saveObjectType = '';
                                        saveIconType = 'utility:flow';
                                    }
                                    
                                }                
                            }
                            fvi.WorkflowObject = saveObjectType;
                            fvi.FlowTypeIcon = saveIconType;
                            fvi.RowShadeValue = saveRowShadeValue;
                            fvRecords.add(fvi);
                            fvi = new ers_FlowDatatableDescriptor();
                            lastDefinitionView = fv.FlowDefinitionViewId;
                        }
                    }
                    fdvBatch = new Set<Id>();
                    fdRecords = new List<FlowDefInfo>();
                }
                // END APEX ACTION PROCESSING LOGIC

                // Set Output Values
                response.flowVersionRecords = JSON.serialize(fvRecords);
                response.recordCollection = fvRecords;
                responseWrapper.add(response);
            }
            // Return values back to the Flow
            return responseWrapper;
        }
    
    }
