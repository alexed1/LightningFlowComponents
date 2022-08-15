/**
 * Apex-Defined Object Variable Descriptor Class for my Flow List View and Delete
 * 
 * 08/15/22 -   Eric Smith -    Version 2.0
 * 05/29/20 -   Eric Smith -    Version 1.0
 * 
 * Used By:     ers_GetFlowInfoAdvanced.cls
 *              ers_DeployDeleteInactiveFlows.cls
 *              ers_TranslateFlowRecords.cls
 * 
 */ 

public with sharing class ers_FlowDatatableDescriptor {
    
    //From FlowVersionView
    @AuraEnabled
    public String DurableId;
    @AuraEnabled
    public String Description;
    @AuraEnabled
    public String FlowDefinitionViewId;
    @AuraEnabled
    public Boolean IsTemplate;
    @AuraEnabled
    public String Label;
    @AuraEnabled
    public Datetime LastModifiedDate;
    @AuraEnabled
    public String ProcessType;
    @AuraEnabled
    public String Status;
    @AuraEnabled
    public Integer VersionNumber;

    //From FlowDefinitionView
    @AuraEnabled
    public String ApiName;
    @AuraEnabled
    public String LastModifiedBy;
    @AuraEnabled
    public String TriggerType;

    //From FlowVariableView
    @AuraEnabled
    public  String WorkflowObject;      // Process Builder Only

    //Additional Datatable Specific Fields
    @AuraEnabled
    public String FlowTypeIcon;
    @AuraEnabled
    public String FlowStatusIcon;
    @AuraEnabled
    public String RowShadeValue;
    @AuraEnabled
    public  String Label_name;
    @AuraEnabled
    public String Label_lookup;

    public ers_FlowDatatableDescriptor(
            String DurableId,
            String Description,
            String FlowDefinitionViewId,
            Boolean IsTemplate,
            String Label,
            Datetime LastModifiedDate,
            String ProcessType,
            String Status,
            Integer VersionNumber,
            String ApiName,
            String LastModifiedBy,
            String TriggerType,
            String WorkflowObject,
            String FlowTypeIcon,
            String FlowStatusIcon,
            String RowShadeValue,
            String Label_name,
            String Label_lookup
        ) {
        this.DurableId = DurableId;
        this.Description = Description;
        this.FlowDefinitionViewId = FlowDefinitionViewId;
        this.IsTemplate = IsTemplate;
        this.Label = Label;
        this.LastModifiedDate = LastModifiedDate;
        this.ProcessType = ProcessType;
        this.Status = Status;
        this.VersionNumber = VersionNumber;
        this.ApiName = ApiName;
        this.LastModifiedBy = LastModifiedBy;
        this.TriggerType = TriggerType;
        this.WorkflowObject = WorkflowObject;
        this.FlowTypeIcon = FlowTypeIcon;
        this.FlowStatusIcon = FlowStatusIcon;
        this.RowShadeValue = RowShadeValue;
        this.Label_name = Label_name;
        this.Label_lookup = Label_lookup;
    }

    // Required no-argument constructor
    public ers_FlowDatatableDescriptor() {}

}
