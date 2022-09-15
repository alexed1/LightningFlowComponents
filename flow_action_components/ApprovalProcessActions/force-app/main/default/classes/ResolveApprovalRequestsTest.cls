@isTest
public with sharing class ResolveApprovalRequestsTest {
    // Create New Request and Test Error Response
    @isTest(SeeAllData=true)
    public static void executeTest() {
        // Get Current User Id
        String userId = UserInfo.getUserId();

        // Find Acme (Sample) Account
        Account a = [SELECT Id FROM Account WHERE Name = 'Acme (Sample)'];

        // Find Process Definition
        ProcessDefinition pd = [SELECT Id FROM ProcessDefinition WHERE DeveloperName = 'Test_Process_Definition'];

        // Find New Process Instance
        ProcessInstance pi = [SELECT Id FROM ProcessInstance WHERE ProcessDefinitionId = :pd.Id LIMIT 1];

        // Create Request Object
        List<ResolveApprovalRequest.Requests> requests = new List<ResolveApprovalRequest.Requests>();
        ResolveApprovalRequest.Requests req = new ResolveApprovalRequest.Requests();
        req.action = 'Approve';
        req.comments = 'Test Comments';
        req.recordId = a.Id;
        req.objName = 'Account';
        req.nextApproverIds = new List<String>{userId};

        // Add req to requests
        requests.add(req);

        // Run Test
        Test.startTest();
        //ResolveApprovalRequest r = new ResolveApprovalRequest();
        ResolveApprovalRequest.execute(requests);
        Test.stopTest();
    }
}