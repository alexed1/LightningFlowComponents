public with sharing class WorkGuideController {
    @AuraEnabled(cacheable=true)
    public static AppProcessInstance__c getCurrentStepInstance(Id userId, Id recordId) {
        List<AppProcessInstance__c> instanceIds = [
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
        ];
        System.debug('instanceIds:::' + instanceIds);
        if (instanceIds.isEmpty()) {
            return new AppProcessInstance__c();
        } else {
            return instanceIds[0];
        }
    }
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
        }
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