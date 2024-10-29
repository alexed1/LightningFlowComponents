
@isTest
public class GetPicklistValuesBulkifiedTests {
	// fields and SObject cannot start with or contain __ so this should never be a valid api name
	private static final String NONEXISTINGAPINAME = '__NON__SENSE__';

	@isTest
	public static void mainTest() {
		List<GetPicklistValuesBulkified.Request> requestList;

		requestList = new List<GetPicklistValuesBulkified.Request>();

		requestList.add(getRequest(Account.Industry));

		Test.startTest();
		List<GetPicklistValuesBulkified.Result> response = GetPicklistValuesBulkified.getPicklistValues(requestList);
		Test.stopTest();

		System.assertNotEquals(null, response[0]);
	}

	@isTest
	public static void bulkTest() {
		List<GetPicklistValuesBulkified.Request> requestList;

		requestList = new List<GetPicklistValuesBulkified.Request>();
		requestList.add(getRequest(Account.Industry));
		requestList.add(getRequest(Account.Rating));
		requestList.add(getRequest(Account.Type));

		Test.startTest();
		List<GetPicklistValuesBulkified.Result> response = GetPicklistValuesBulkified.getPicklistValues(requestList);
		Test.stopTest();

		System.assertNotEquals(null, response[0]);
		System.assertEquals(3, response.size());
	}

	@isTest
	public static void incorrectSObjectTest() {
		List<GetPicklistValuesBulkified.Request> requestList;

		requestList = new List<GetPicklistValuesBulkified.Request>();
		requestList.add(getRequest(NONEXISTINGAPINAME, NONEXISTINGAPINAME));

		GetPicklistValuesBulkified.PicklistInvocableException thrownException;

		Test.startTest();
		try {
			List<GetPicklistValuesBulkified.Result> response = GetPicklistValuesBulkified.getPicklistValues(requestList);
		} catch (GetPicklistValuesBulkified.PicklistInvocableException exc) {
			thrownException = exc;
		}
		Test.stopTest();

		System.assertNotEquals(null, thrownException);
	}

	@isTest
	public static void incorrectSObjectFieldTest() {
		List<GetPicklistValuesBulkified.Request> requestList;

		requestList = new List<GetPicklistValuesBulkified.Request>();
		requestList.add(getRequest(SObjectType.Account.getLocalName(), NONEXISTINGAPINAME));

		GetPicklistValuesBulkified.PicklistInvocableException thrownException;

		Test.startTest();
		try {
			List<GetPicklistValuesBulkified.Result> response = GetPicklistValuesBulkified.getPicklistValues(requestList);
		} catch (GetPicklistValuesBulkified.PicklistInvocableException exc) {
			thrownException = exc;
		}
		Test.stopTest();

		System.assertNotEquals(null, thrownException);
	}

	private static GetPicklistValuesBulkified.Request getRequest(Schema.SObjectField sObjField) {
		Schema.DescribeFieldResult dfr = sObjField.getDescribe();
		return getRequest(dfr.getSObjectType().getDescribe().getLocalName(), dfr.getLocalName());
	}
	private static GetPicklistValuesBulkified.Request getRequest(String objectName, String fieldName) {
		GetPicklistValuesBulkified.Request req = new GetPicklistValuesBulkified.Request();
		req.fieldName = fieldName;
		req.objectName = objectName;
		return req;
	}

}