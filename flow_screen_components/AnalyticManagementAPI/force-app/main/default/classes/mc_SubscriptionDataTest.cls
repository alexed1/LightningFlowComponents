@isTest
public with sharing class mc_SubscriptionDataTest {
    @isTest
    public static void mc_SubscriptionDataTest() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new SubscriptionData_MockHTTP());
        system.debug([select id from report].size());
        // Create Request
        mc_SubscriptionData.Request request = new mc_SubscriptionData.Request();
        List<mc_SubscriptionData.Request> requests = new List<mc_SubscriptionData.Request>();

        // Set request parameters
        request.source = 'lightningReportSubscribe';
        request.ownerId = '';
        request.recordId = '';

        // Add request to list
        requests.add(request);

        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        Test.startTest();
        List<mc_SubscriptionData.Results> res = mc_SubscriptionData.mc_GetSubscriptionDataList(requests);
        Test.stopTest();
        
        // Verify response received contains fake values
       
    }
}