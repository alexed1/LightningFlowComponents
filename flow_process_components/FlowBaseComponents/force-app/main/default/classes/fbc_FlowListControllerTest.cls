@IsTest
class fbc_FlowListControllerTest {
static testMethod void testFlowListController() {

    Test.startTest();
        String filters = '{"ProcessType":["Flow","AutolaunchedFlow"]}';
        fbc_FlowListController.getFlowNamesApex(filters);
    Test.stopTest();
    
}
}