@isTest(SeeAllData=true)
public with sharing class WorkGuideControllerTest {

    @isTest
    public static void CanConvertOrchestrationStageInstanceToWorkGuideDataStructure() {

        //AppProcessInstance__c curAPInstance = new AppProcessInstance__c();
        ConnectApi.OrchestrationStageInstance  orchStageInstance = new ConnectApi.OrchestrationStageInstance();
        AppProcessInstance__c curAPIInstance = WorkGuideController.ConvertOrchestrationStageInstanceToWorkGuideDataStructure(orchStageInstance);
        
        System.assertNotEquals(null, curAPIInstance);
        
    }

    @isTest
    public static void CanExtractWorkItemsFromOrchInstanceCollection() {
        List<ConnectApi.OrchestrationInstance> orchInstances = WorkGuideFixtures.getFixture_OrchestrationInstances();
        List<ConnectApi.OrchestrationWorkAssignment> workItems =  WorkGuideController.extractWorkItemsFromOrchInstanceCollection( orchInstances);
        System.assertEquals(WorkGuideFixtures.getFixture_WorkAssignments(), workItems);
    }

  /*   @isTest 
    public static void CanGetActiveStageInstanceFromContextRecord() {
        OrchContent__c testOrchContent = new OrchContent__c();
        testOrchContent.Name = 'foobar';
        insert testOrchContent;

        ConnectApi.OrchestrationStageInstance  curStageInstance = WorkGuideController.getActiveStageInstanceFromContextRecord( testOrchContent.Id);
    }
 */
   /*  @isTest
    public static void CanGetAllStageInstancesFromContextRecord() {
        //todo need a way to create a new instance in the eyes of the org associated with a record. basically this implies programmatically invoking an orchestration flow
        String contextRecordId = 'foo';
        ConnectApi.OrchestrationInstanceCollection instanceCollection = ConnectApi.Orchestrator.getOrchestrationInstanceCollection(contextRecordId);
 
    } */

/* 
    @isTest
    public static void CanGetWorkAssignmentsFromStepInstance() {

        //build test data
        List<ConnectApi.OrchestrationWorkAssignment> testWorkAssignments =  WorkGuideFixtures.getFixture_WorkAssignments();
        ConnectApi.OrchestrationStepInstance  testStepInstance = WorkGuideFixtures.getFixture_OrchestrationStepInstance1();

        List<ConnectApi.OrchestrationWorkAssignment> returnedWorkAssignments = WorkGuideController.extractWorkItemsFromOrchInstance(testStepInstance);
        System.assertEquals(testWorkAssignments, returnedWorkAssignments);
    } */


}