@IsTest
class FlowListControllerTest {
static testMethod void testFlowListController() {

    Test.startTest();
        String filters = '{"ProcessType":["Flow","AutolaunchedFlow"]}';
        FlowListController.getFlowNamesApex(filters);
    Test.stopTest();
    
}
}