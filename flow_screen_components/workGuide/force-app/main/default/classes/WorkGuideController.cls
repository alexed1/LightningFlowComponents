public with sharing class WorkGuideController {

    @AuraEnabled(cacheable=true)
    public static WorkItemValueSet getActiveWorkItemsByRecordId(Id userId, Id recordId) {
        
        System.debug('entering getActiveWorkItemsByRecordId');
        
       
        //so instead let's get all the instances
        //note that this gets all the orchestration instances that have at least one active work item that is associated with this record
        List<ConnectApi.OrchestrationInstance> orchInstances = getAllOrchestrationInstancesFromContextRecord( recordId);

        //extract the active work items from this filtered set of orchInstances

        List<ConnectApi.OrchestrationWorkAssignment> recordWorkItems = extractWorkItemsFromOrchInstanceCollection(orchInstances);


        //get all the work items corresponding to this record
        //since there are no assignments in 230, the component doesn't filter on assignee
        //List<ConnectApi.OrchestrationWorkAssignment> recordWorkItems = getAllWorkItemsFromContextRecord(recordId);
        System.debug('the work items corresponding to recordId: ' + recordId + ' are: ' + recordWorkItems);

        //convert the resulting ConnectApi.OrchestrationStageInstance into the AppProcessInstance__c that the work guide currently expects
        //workguideInstanceData = ConvertOrchestrationStageInstanceToWorkGuideDataStructure(orchStageInstance); 
        //return the workguideInstanceData

        WorkItemValueSet curWorkItemValues = buildWorkItemValueSet(recordWorkItems);

        return curWorkItemValues;
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


    @AuraEnabled(cacheable=true)
    public static AppProcessInstance__c getWorkItemDetail(Id userId, Id recordId) {
        AppProcessInstance__c workguideInstanceData = new AppProcessInstance__c();
         /* [
                SELECT
                        Id,
                        currentStage__c,
                        currentStep__c,
                        App_Process_Definition__c,
                        App_Process_Definition__r.Name,
                        App_Process_Definition__r.StepFlowMappings__c,
                        App_Process_Definition__r.StageStepMappings__c
                FROM AppProcessInstance__c
                WHERE UserId__c = :userId AND RecordId__c = :recordId
        ]; */
       // System.debug('instanceIds:::' + APinstanceCollection);


        //call the definitive method from Bruno
        //however, this method arbitrarily takes only the first instance
        //ConnectApi.OrchestrationStageInstance orchStageInstance = getActiveStageInstanceFromContextRecord(recordId) ;
        //get step instances for the stage instance
       // List<ConnectApi.OrchestrationStepInstance> curStepInstances = GetStepInstancesFromStageInstance(orchStageInstance);


        return workguideInstanceData;
    }

    @AuraEnabled(cacheable=true)
    public static ConnectApi.OrchestrationStageInstance getActiveStageInstanceFromContextRecord(String contextRecordId) {
        ConnectApi.OrchestrationInstanceCollection instanceCollection = ConnectApi.Orchestrator.getOrchestrationInstanceCollection(contextRecordId);
        System.debug('return from getOrchestrationInstanceCollection is: ' + instanceCollection);
        if (instanceCollection == null || instanceCollection.instances.size() == 0) {
            return null;
        }
        // there might be more than one: pick the first one (for example)
        ConnectApi.OrchestrationInstance instance = instanceCollection.instances.get(0);
        // instance not found, or no stages
        if (instance.stageInstances == null || instance.stageInstances.size() == 0) {
            return null;
        }
        // search for InProgress stage
        for (ConnectApi.OrchestrationStageInstance stageInstance : instance.stageInstances) {
            if (stageInstance.status == ConnectApi.OrchestrationInstanceStatus.InProgress) {
                return stageInstance;
            }
        }
        // no InProgress stage
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

     //for a given recordId, get all orchestration instances
    public static List<ConnectApi.OrchestrationInstance> getAllOrchestrationInstancesFromContextRecord(String contextRecordId) {
        ConnectApi.OrchestrationInstanceCollection instanceCollection = ConnectApi.Orchestrator.getOrchestrationInstanceCollection(contextRecordId);
        if (instanceCollection == null || instanceCollection.instances.size() == 0) {
            return null;
        } else return instanceCollection.instances;
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

     public class AppProcessEventResult {
        @AuraEnabled
        public Boolean isSuccess;
        @AuraEnabled
        public SObject resultObject;
        @AuraEnabled
        public String message;
    } 
}