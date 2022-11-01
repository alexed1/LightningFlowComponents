@isTest
public with sharing class InvocableApprovalHelperTest {
	@TestSetup
	static void makeData() {
		TestHelper.createTestData();
	}

	@isTest
	public static void doApproveAction() {
		Account acc = new Account(Name='testAcc');
		insert acc;
		
		// Create Request Object
		List<InvocableApprovalHelper.Request> requests = new List<InvocableApprovalHelper.Request>();

		InvocableApprovalHelper.Request req = new InvocableApprovalHelper.Request();
		req.action = 'Approve';
		req.comments = 'Test Comments';
		req.recordId = acc.Id;
		req.nextApproverIds = new List<String>{ UserInfo.getUserId() };

		// Add req to requests
		requests.add(req);

		// Run Test
		Test.startTest();
		List<InvocableApprovalHelper.Result> results = InvocableApprovalHelper.execute(requests);
		Test.stopTest();

		System.assertEquals(1, results.size(), 'there should be 1 result for 1 request');
	}
}
