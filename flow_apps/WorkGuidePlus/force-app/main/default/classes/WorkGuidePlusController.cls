public with sharing class WorkGuidePlusController {
    @AuraEnabled
    public static void publishFlowOrchestrationEvent(String stepInstanceId, String orchestrationInstanceId, String eventPayload, String stepStatus){
        EventBus.publish(new FlowOrchestrationEvent(
            StepInstanceId = stepInstanceId, 
            OrchestrationInstanceId = orchestrationInstanceId, 
            EventPayload = eventPayload, 
            StepStatus = stepStatus
        ));
    }
}
