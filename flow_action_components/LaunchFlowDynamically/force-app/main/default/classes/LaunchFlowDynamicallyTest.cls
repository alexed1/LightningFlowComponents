@IsTest
public class LaunchFlowDynamicallyTest {
    
    @isTest
    static void test_LaunchFlow(){
        List<LaunchFlowDynamically.Requests> lstRequests = new List<LaunchFlowDynamically.Requests>();
        
        LaunchFlowDynamically.Requests requestTest = new LaunchFlowDynamically.Requests();
        requestTest.flowName = 'Unleashed_Taxes_Get_and_Upsert_All';
        requestTest.namespace = '';
        requestTest.param1Name = '';
        requestTest.param1Value = '';
        requestTest.param2Name = '';
        requestTest.param2Value = '';
        requestTest.param3Name = '';
        requestTest.param3Value = '';
        requestTest.useFutureLaunch = false;
        lstRequests.add(requestTest);
        
        Test.startTest();
          Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
          LaunchFlowDynamically.launch(lstRequests);
        Test.stopTest();
    }
    
    @isTest
    static void test_LaunchFlow_Future(){
        List<LaunchFlowDynamically.Requests> lstRequests = new List<LaunchFlowDynamically.Requests>();
        
        LaunchFlowDynamically.Requests requestTest = new LaunchFlowDynamically.Requests();
        requestTest.flowName = 'Unleashed_Taxes_Get_and_Upsert_All';
        requestTest.namespace = '';
        requestTest.param1Name = '';
        requestTest.param1Value = '';
        requestTest.param2Name = '';
        requestTest.param2Value = '';
        requestTest.param3Name = '';
        requestTest.param3Value = '';
        requestTest.useFutureLaunch = true;
        lstRequests.add(requestTest);
        
        Test.startTest();
          Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
          LaunchFlowDynamically.launch(lstRequests);
        Test.stopTest();
    }
}
