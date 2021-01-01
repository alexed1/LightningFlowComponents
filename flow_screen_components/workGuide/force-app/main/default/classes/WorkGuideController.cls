public with sharing class WorkGuideController {

    @AuraEnabled(cacheable=true)
    public static WorkItemValueSet getActiveWorkItemsByRecordId(Id userId, Id recordId) {
        
        System.debug('entering getActiveWorkItemsByRecordId');
        WorkItemValueSet curWorkItemValues = new WorkItemValueSet();
       
        //so instead let's get all the instances
        //note that this gets all the orchestration instances that have at least one active work item that is associated with this record
        List<ConnectApi.OrchestrationInstance> orchInstances = getAllOrchestrationInstancesFromContextRecord( recordId);
        System.debug('orchInstances returned are: ' + orchInstances);
        //extract the active work items from this filtered set of orchInstances
        
        if (orchInstances != null) {
            List<ConnectApi.OrchestrationWorkAssignment> recordWorkItems = extractWorkItemsFromOrchInstanceCollection(orchInstances);
            if (recordWorkItems != null) {
                //get all the work items corresponding to this record
                //since there are no assignments in 230, the component doesn't filter on assignee
                //List<ConnectApi.OrchestrationWorkAssignment> recordWorkItems = getAllWorkItemsFromContextRecord(recordId);
                System.debug('the work items corresponding to recordId: ' + recordId + ' are: ' + recordWorkItems);
        
                //convert the resulting ConnectApi.OrchestrationStageInstance into the AppProcessInstance__c that the work guide currently expects
                //workguideInstanceData = ConvertOrchestrationStageInstanceToWorkGuideDataStructure(orchStageInstance); 
                //return the workguideInstanceData
        
                return buildWorkItemValueSet(recordWorkItems);
            } else return null;

          
        } else return null;
    

    } 

     //for a given recordId, get all orchestration instances
     public static List<ConnectApi.OrchestrationInstance> getAllOrchestrationInstancesFromContextRecord(String contextRecordId) {
        ConnectApi.OrchestrationInstanceCollection instanceCollection = ConnectApi.Orchestrator.getOrchestrationInstanceCollection(contextRecordId);
        if (instanceCollection == null || instanceCollection.instances.size() == 0) {
            return null;
        } else return instanceCollection.instances;
    }

    //picklists expect a list of values and a list of labels. This data structure returns things that way
    private static WorkItemValueSet buildWorkItemValueSet(List<ConnectApi.OrchestrationWorkAssignment> recordWorkItems) {
        WorkItemValueSet curWorkItemValueSet = new WorkItemValueSet();
        for (ConnectApi.OrchestrationWorkAssignment curWorkItem : recordWorkItems) {
            curWorkItemValueSet.workItemLabels.add(curWorkItem.label);
            curWorkItemValueSet.workItemRecordIds.add(curWorkItem.id);
        }

        return curWorkItemValueSet;

    }

    //return details about a work item in the form expected by the WorkGuide component
    @AuraEnabled(cacheable=true)
    public static AppProcessInstance__c getWorkItemDetail(Id userId, Id contextRecordId, Id workItemRecordId) {
        System.debug('getting WorkItemDetail');
        AppProcessInstance__c workItemDetails = new AppProcessInstance__c();
        
        //get all of the instances linked to this recordId
        List<ConnectApi.OrchestrationInstance> allRecordOrchInstances = getAllOrchestrationInstancesFromContextRecord( contextRecordId) ;
        System.debug ('allRecordOrchInstances is: ' + allRecordOrchInstances);

        //find the instance that has the provide workItemRecordId
        WorkItemLineage curWorkItemLineage = extractWorkItemLineage(allRecordOrchInstances, workItemRecordId);
        System.debug('workItemLineage is: ' + curWorkItemLineage);

        //use that instance to build the two mappings
        String stageStepMapping = buildStageStepMapping(curWorkItemLineage.parentOrchInstance);
        System.debug('current stageStepMapping is: ' + stageStepMapping);

         //use that instance to build the two mappings
         String stepFlowMapping = buildStepFlowMapping(curWorkItemLineage);
         System.debug('current stepFlowMapping is: ' + stepFlowMapping);

        //assemble the AppProcessInstance data structure

        //the step name corresponding to this work item. 
        workItemDetails.currentStep__c = curWorkItemLineage.parentOrchStep.Label;
        workItemDetails.currentStage__c = curWorkItemLineage.parentOrchStage.Label;
        workItemDetails.RecordId__c = curWorkItemLineage.curWorkAssignment.contextRecordId;
        workItemDetails.UserId__c = userId;
        workItemDetails.OrchestrationInstanceId__c = curWorkItemLineage.parentOrchInstance.id;
        System.debug('OrchestrationInstanceId__c is: ' + workItemDetails.OrchestrationInstanceId__c);
        workItemDetails.OrchestrationStepInstanceId__c = curWorkItemLineage.parentOrchStep.id;
        workItemDetails.OrchestrationWorkItemId__c = curWorkItemLineage.curWorkAssignment.id;
        //workItemDetails.Id = curWorkItemLineage.parentOrchInstance.Id; illegal
        workItemDetails.StageStepMapping__c = stageStepMapping;
        workItemDetails.StepFlowMapping__c = stepFlowMapping;

        System.debug('final data structure from apex: ' + workItemDetails);
        return workItemDetails;
    }

  

    //when you know a workItemId but don't know its lineage
    public static WorkItemLineage extractWorkItemLineage(List<ConnectApi.OrchestrationInstance> allRecordOrchInstances, Id workItemRecordId) {
        
        WorkItemLineage curWorkItemLineage = new WorkItemLineage();
        for (ConnectApi.OrchestrationInstance curInstance : allRecordOrchInstances){
            //for each stage
            //for each step
            //for each workItem
            //if it's a match return the current instance 
            for (ConnectApi.OrchestrationStageInstance curStage : curInstance.stageInstances) {
                for (ConnectApi.OrchestrationStepInstance curStep : curStage.stageStepInstances) {
                    for (ConnectApi.OrchestrationWorkAssignment curWorkItem : curStep.workAssignments) {
                        if (curWorkItem.Id == workItemRecordId) {
                            curWorkItemLineage.curWorkAssignment = curWorkItem;
                            curWorkItemLineage.parentOrchInstance = curInstance;
                            System.debug('curInstance is: ' + curInstance);
                            curWorkItemLineage.parentOrchStage = curStage;
                            System.debug('curStep is: ' + curStep);
                            curWorkItemLineage.parentOrchStep = curStep;
                            return curWorkItemLineage;
                        }
                    }
                }
            }
        }
        return null;

    }


    public static AppProcessInstance__c ConvertOrchestrationStageInstanceToWorkGuideDataStructure(ConnectApi.OrchestrationStageInstance  orchStageInstance) {
        AppProcessInstance__c workguideInstanceData = new AppProcessInstance__c();
        return workguideInstanceData;
    }

    //these are json data structures used by the current work guide javascript
    public static String stageStepMapping = '';
    public static String stepFlowMapping = '';


    //from the filtered set of orchInstances, extract the relevant work items
    public static List<ConnectApi.OrchestrationWorkAssignment>  extractWorkItemsFromOrchInstanceCollection( List<ConnectApi.OrchestrationInstance> orchInstances) {
        List<ConnectApi.OrchestrationWorkAssignment> allWorkItems = new List<ConnectApi.OrchestrationWorkAssignment> ();
        //for each orchInstance
        for (ConnectApi.OrchestrationInstance orchInstance : orchInstances) {
            List<ConnectApi.OrchestrationWorkAssignment> curWorkItems = extractWorkItemsFromOrchInstance(orchInstance);
            allWorkItems.addAll(curWorkItems);
        }
            

            //get the active stages
            //List<ConnectApi.OrchestrationStageInstance> activeStages = getAllActiveStagesFromCurrentRecordOrchestrationInstances(instanceCollection.instances);
            //get its step instances
            //get the associated work items
       
        return allWorkItems;

    }

    public static List<ConnectApi.OrchestrationWorkAssignment>  extractWorkItemsFromOrchInstance( ConnectApi.OrchestrationInstance orchInstance) {
            
            List<ConnectApi.OrchestrationWorkAssignment> curWorkItems = new  List<ConnectApi.OrchestrationWorkAssignment>();
            
            //get the active stage instance
            // instance not found, or no stages
            if (orchInstance.stageInstances == null || orchInstance.stageInstances.size() == 0) {
                return null;
            }
            ConnectApi.OrchestrationStageInstance activeStageInstance = getActiveStageFromOrchestrationInstance(orchInstance);

            if (activeStageInstance == null) {
                //this orchestration instance does not have an active stage, which should mean that it's complete. other situations are probably errors
                return null;
            }

            //from the active stage instance, get the in-progress steps
            List<ConnectApi.OrchestrationStepInstance> inProgressStepInstances = GetInProgressStepInstancesFromStageInstance(activeStageInstance);

            //for each in-progress step
                //get the active work items and append them

            for (ConnectApi.OrchestrationStepInstance curStepInstance : inProgressStepInstances) {
                curWorkItems.addAll(curStepInstance.workAssignments);
            }
            return curWorkItems;
    }



    /*     {
        "Prepare to Publish": [
            "Approval",
            "Review"
        ],
        "Published": [
            "Finalization"
        ]
    } */
    public static String buildStageStepMapping(ConnectApi.OrchestrationInstance  orchInstance) {
        String stageStepMapping = '{\n';
        for(ConnectApi.OrchestrationStageInstance curStage : orchInstance.stageInstances) {
            stageStepMapping = stageStepMapping + '\"' + curStage.label + '\": [\n';
            for (ConnectApi.OrchestrationStepInstance curStep : curStage.stageStepInstances) {
                stageStepMapping = stageStepMapping + '\t\"' + curStep.label + '\",';
            }
            stageStepMapping = stageStepMapping.removeEnd(',') + '\n],\n';
        }
        stageStepMapping = stageStepMapping.removeEnd(',\n') + '}';
        System.debug ('stageStepMapping is: ' + stageStepMapping);
        return stageStepMapping;

    }

    /* {
        "Approval" : "ApprovalStep", 
        "Finalization" :"finalFlow",
        "Review" : "HelloWorld"
    } */
    public static String buildStepFlowMapping(WorkItemLineage curWorkItemLineage) {
        System.debug('entering buildStepFlowMapping....workItemLineage is: ' + curWorkItemLineage);
        //retrieve flowdef info that includes id and name
        List<FlowDefinitionView> curFlows = [SELECT Id,ApiName,DurableId, Label FROM FlowDefinitionView];
        String stepFlowMap = '{\n ';
        //get parent stage
        //for each step in the stage 

        for (ConnectApi.OrchestrationStepInstance curStep : curWorkItemLineage.parentOrchStage.stageStepInstances) {
            //get the first work item of that step
            if(curStep.workAssignments.size() > 0 ) {
                String flowId = curStep.workAssignments[0].screenFlowId; //unstarted steps don't have any work assignments. 
                String flowName = findFlowNameByFlowId(flowId, curFlows);
                System.debug('for step : ' + curStep.Label + ', flowName is: ' + flowName);
                stepFlowMap = stepFlowMap + '\"' + curStep.Label + '\" : \"' + flowName + '\",\n';
            }
          
        }

        stepFlowMap = stepFlowMap.removeEnd(',\n') + '}';
           
           // get the flowId and match to the flowdef Info and 
           //append to the string
           
        System.debug('curFlows is: ' + curFlows);

        return stepFlowMap;
    }

    public static String findFlowNameByFlowId( string flowId, List<FlowDefinitionView> curFlows) {
        for (FlowDefinitionView curFlow : curFlows) {
            if (curFlow.DurableId == flowId) {
                return curFlow.ApiName;
            }
        }
        return ('flowId not found: ' + flowId);
    }


    //flow data can only be retrieved via a tooling api call
    public static List<FlowDefinition>  getFlowData() {
        List<String> curFlowDefs = new  List<String>();
        String sessionId =  getSessionIdFromVFPage();
        String auth = 'Bearer ' + sessionId;
        String query = 'SELECT DeveloperName,  Description, Id,FullName FROM FlowDefinition';
        String endpoint = URL.getSalesforceBaseUrl().toExternalForm() +
            '/services/data/v50.0/tooling/query/?q=' +
            EncodingUtil.urlEncode(query, 'UTF-8');

        HttpRequest request = new HttpRequest();
        request.setHeader('Authorization', auth);
        request.setEndpoint(endpoint);
        request.setMethod('GET');

        HttpResponse response = new Http().send(request);
        
        String responseBody = response.getBody();
        system.debug('result of toolingapi flow call is' + responseBody);
        ToolingAPIResponse curToolingAPIResponse = (ToolingAPIResponse)JSON.deserialize(responseBody, ToolingAPIResponse.class);
        System.debug('tooling api response is  re: ' + curToolingAPIResponse);


        //test
        /* FlowDefinition curFlowDef = new FlowDefinition();
        curFlowDef.FullName = 'foo';
        curFlowDef.attributes.type = 'mytype';
        ToolingAPIResponse testToolingResponse = new ToolingAPIResponse();
        testToolingResponse.size = '15';
        testToolingResponse.records =  */



        //List<FlowDefinition> flowDefs  = (List<FlowDefinition>)JSON.deserialize(curToolingAPIResponse.records, List<FlowDefinition>.class);
        System.debug('flowDefs are: ' + curToolingAPIResponse.records);
        return curToolingAPIResponse.records;
    }

    //for a set of orchestration instances, get all active stages
    public static ConnectApi.OrchestrationStageInstance getActiveStageFromOrchestrationInstance(ConnectApi.OrchestrationInstance  orchInstance) {
        
    
        // instance not found, or no stages
        if (orchInstance.stageInstances == null || orchInstance.stageInstances.size() == 0) {
            return null;
        }
        // search for InProgress stage
        for (ConnectApi.OrchestrationStageInstance stageInstance : orchInstance.stageInstances) {
            if (stageInstance.status == ConnectApi.OrchestrationInstanceStatus.InProgress) {
                return stageInstance;
            }
        }
        
        return null;
    }

    
 
    /* for each stage instance
    get the Orchestration step instances */

    public static List<ConnectApi.OrchestrationStepInstance> GetInProgressStepInstancesFromStageInstance(ConnectApi.OrchestrationStageInstance curStageInstance) {
        System.debug ('entering GetInProgressStepInstancesFromStageInstance');
        System.debug ('curStageInstance is: ' + curStageInstance);
        List<ConnectApi.OrchestrationStepInstance> inProgressStepInstances = new  List<ConnectApi.OrchestrationStepInstance>();
       List<ConnectApi.OrchestrationStepInstance> curStepInstances = curStageInstance.stageStepInstances;
       for (ConnectApi.OrchestrationStepInstance curStepInstance : curStepInstances){
           if(curStepInstance.status == ConnectApi.OrchestrationInstanceStatus.InProgress) {
               inProgressStepInstances.add(curStepInstance);
           }
       }
        
       return inProgressStepInstances;
    }



    /* for each Step Instance:
    add to the stagestep mapping object
    add to the step/flownames object
    get the OrchestrationWorkAssignments, passing in the stage and step names and instanceId
    for each one add to a list
    return the list */
/*     public static List<ConnectApi.OrchestrationWorkAssignment> GetWorkAssignmentsFromStepInstance(ConnectApi.OrchestrationStepInstance curStepInstance) {
        List<ConnectApi.OrchestrationWorkAssignment> curWorkAssignments = curStepInstance.workAssignments;
        System.debug('provided stepInstance: ' + curStepInstance);
        //build a portion of the stageStepMapping structure;
        //stageStepMapping = stageStepMapping + '\"' + curStepInstance.name + '\",\n';
        //build a portion of the step/flowname structure;
        //stepFlowMapping = stepFlowMapping + '\"' + curStepInstance.name  + '\" : \"' + curWorkAssignments[0].screenFlowId + '\"';   //get the flow name from one of the work items
       

        return curWorkAssignments; */

    





     @AuraEnabled
    public static AppProcessEventResult dispatchAppProcessEvent(Id definitionId, Id instanceId, String step, String status, String parameters) {
        AppProcessEvent__e appProcessEvent = new AppProcessEvent__e(
                appProcessDefinitionId__c = definitionId,
                appProcessInstanceId__c = instanceId,
                appProcessStepId__c = step,
                parameters__c = parameters,
                status__c = status
        );

        AppProcessEventResult eventResult = new AppProcessEventResult();
        /*
        List<Database.SaveResult> results = EventBus.publish(new List<AppProcessEvent__e>{
                appProcessEvent
        });
        for (Database.SaveResult result : results) {
            if (!result.isSuccess()) {
                eventResult.isSuccess = false;
                for (Database.Error error : result.getErrors()) {
                    eventResult.message += error.getStatusCode() + ' : ' + error.getMessage();
                }
            } else {
                eventResult.isSuccess = true;
            }
        }*/
        eventResult.resultObject = appProcessEvent;
        return eventResult;
    } 

    public static String getSessionIdFromVFPage() {
        if(Test.isRunningTest()) {
            return 'SESSION_ID';
        } else {
            String SESSION_ID_START = 'SESSION_ID_START';
            String SESSION_ID_END = 'SESSION_ID_END';
            String pageContent = Page.SessionId.getContent().toString();
            Integer startIndex = pageContent.indexOf(SESSION_ID_START) + SESSION_ID_START.length();
            Integer endIndex = pageContent.indexOf(SESSION_ID_END);
            return pageContent.substring(startIndex, endIndex);
        }
     }

     public class AppProcessEventResult {
        @AuraEnabled
        public Boolean isSuccess;
        @AuraEnabled
        public SObject resultObject;
        @AuraEnabled
        public String message;
    } 
}