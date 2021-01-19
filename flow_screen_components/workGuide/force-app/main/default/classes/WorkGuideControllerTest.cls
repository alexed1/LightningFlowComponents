@isTest(SeeAllData=true)
public with sharing class WorkGuideControllerTest {



    @isTest
    public static void CanExtractWorkItemLineage() {
        String workItemId = '0jf9A0000000006QAA';
        List<ConnectApi.OrchestrationInstance> allRecordOrchInstances = WorkGuideFixtures.getFixture_OrchestrationInstances();
        WorkItemLineage curWorkItemLineage = WorkGuideController.extractWorkItemLineage(allRecordOrchInstances, workItemId);
        System.assertEquals('0jf9A0000000006QAA', curWorkItemLineage.curWorkAssignment.Id);

    }


    @isTest
    public static void CanExtractWorkItemsFromInProgressSteps( ) {
    ConnectApi.OrchestrationInstance orchInstance = WorkGuideFixtures.getFixture_OrchestrationInstance1();
    List<ConnectApi.OrchestrationWorkAssignment> curWorkAssignments = WorkGuideController.extractWorkItemsFromInProgressSteps(orchInstance);
    System.assertEquals(2,curWorkAssignments.size() );

    }

    @isTest
    public static void CanBuildStepFlowMapping() {
        String workItemId = '0jf9A0000000006QAA';
        List<ConnectApi.OrchestrationInstance> allRecordOrchInstances = WorkGuideFixtures.getFixture_OrchestrationInstances();
        WorkItemLineage curWorkItemLineage = WorkGuideController.extractWorkItemLineage(allRecordOrchInstances, workItemId);
        String stepFlowMapping = WorkGuideController.buildStepFlowMapping(curWorkItemLineage);
        system.assertEquals('foo', stepFlowMapping);
    }

    @isTest
    public static void CanBuildStageStepMapping() {
        ConnectApi.OrchestrationInstance orchInstance = WorkGuideFixtures.getFixture_OrchestrationInstance1();
        String stageStepMapping = WorkGuideController.buildStageStepMapping(orchInstance);
        String expectedStageStepMapping =   '{\n\"Stage1\": [\n' +
            '\t\"Submit Content for Approval\",' +
            '\t\"Step2 Label\",' +
            '\t\"Step 3 Label\"\n' +
        '],\n'+
        '\"Stage2\": [\n' +
            '\t\"Submit Content for Approval\",' +
            '\t\"Step2 Label\",' +
            '\t\"Step 3 Label\"' +
        '\n]' +
        '}';
        System.assertEquals(expectedStageStepMapping, stageStepMapping);
    }


    @isTest
    public static void CanGetActiveStageFromOrchestrationInstance() {
        ConnectApi.OrchestrationInstance orchInstance = WorkGuideFixtures.getFixture_OrchestrationInstance1();
        ConnectApi.OrchestrationStageInstance activeStage = WorkGuideController.getActiveStageFromOrchestrationInstance(orchInstance);
        System.assertEquals('0jL9A000000000KUAQ', activeStage.id);
    }
        
    

    @isTest
    public static void CanGetInProgressStepInstancesFromStageInstance() {
        ConnectApi.OrchestrationStageInstance orchStageInstance = WorkGuideFixtures.getFixture_OrchestrationStageInstance1();
        List<ConnectApi.OrchestrationStepInstance> inProgressStepInstances =  WorkGuideController.GetInProgressStepInstancesFromStageInstance( orchStageInstance);
        System.assertEquals(1, inProgressStepInstances.size());
    }



}