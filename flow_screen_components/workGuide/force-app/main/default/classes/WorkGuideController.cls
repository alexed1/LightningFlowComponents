public with sharing class WorkGuideController {



    //this runs when workguide initializes.
    //if no work items are available, show the no work available message
    //if 1 work item available, run it immediately
    //if more than 1 work item, show the selector
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
                System.debug('the work items corresponding to recordId: ' + recordId + ' are: ' + recordWorkItems);
        
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
        System.debug('workItemId is: ' + curWorkItemLineage.curWorkAssignment.id);
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



    //from the filtered set of orchInstances, extract the relevant work items
    public static List<ConnectApi.OrchestrationWorkAssignment>  extractWorkItemsFromOrchInstanceCollection( List<ConnectApi.OrchestrationInstance> orchInstances) {
        List<ConnectApi.OrchestrationWorkAssignment> allWorkItems = new List<ConnectApi.OrchestrationWorkAssignment> ();
        //for each orchInstance
        for (ConnectApi.OrchestrationInstance orchInstance : orchInstances) {
            List<ConnectApi.OrchestrationWorkAssignment> curWorkItems = extractWorkItemsFromInProgressSteps(orchInstance);
            allWorkItems.addAll(curWorkItems);
        }
       
        return allWorkItems;
    }

    public static List<ConnectApi.OrchestrationWorkAssignment>  extractWorkItemsFromInProgressSteps( ConnectApi.OrchestrationInstance orchInstance) {
            
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



    /*  The 'StageStepMapping' is a data structure used by the WorkGuide component to populate a path visual   {
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

    /* The StepFlow Mapping is a data structure used by the work guide component to determine which flow should be launched when a particular step is active
    {
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

    //for an orchestration instance, get the active stage
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

     
}