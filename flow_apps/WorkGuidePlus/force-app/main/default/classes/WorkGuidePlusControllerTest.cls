@isTest
public with sharing class WorkGuidePlusControllerTest {
    @isTest
    static void testPublishFlowOrchestrationEvent() {
        Test.startTest();
        WorkGuidePlusController.publishFlowOrchestrationEvent('TeststepInstanceId', 'TestorchestrationInstanceId', 'testeventPayload', 'Completed');
        Test.stopTest();
    }
}
