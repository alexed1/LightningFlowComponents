@isTest
public with sharing class GetRecordsInTest {

    @isTest
    public static void TestGetRecordsIn() {

    Account a1 = new Account(Name='Test1', AccountNumber='1');
    insert a1;
    Account a2 = new Account(Name='Test2', AccountNumber='2');
    insert a2;
    
    Contact c1 = new Contact(LastName='Contact1', AccountId=a1.Id);
    insert c1;
    Contact c2 = new Contact(LastName='Contact2', AccountId=a1.Id);
    insert c2;
    Contact c3 = new Contact(LastName='Contact3', AccountId=a2.Id);
    insert c3;
    Contact[] contacts = [SELECT Id, AccountId FROM Contact];
    List<String> accountIds = new List<String>();
    accountIds.add(c1.AccountId);
    accountIds.add(c2.AccountId);
    accountIds.add(c3.AccountId);
    String accountIdString = String.join(accountIds, ',');

        /* Object */
        GetRecordsIn.Requests testRequestObject = new GetRecordsIn.Requests();
        List<GetRecordsIn.Requests> testObjectRequestList = new List<GetRecordsIn.Requests>();
        testRequestObject.outputObject = 'Account';
        testRequestObject.sourceMethod = 'Object';
        testRequestObject.sourceObject = 'Contact';
        testRequestObject.sourceField = 'AccountId';
        testRequestObject.sourceRecordCollection = contacts;
        testObjectRequestList.add(testRequestObject);
        List<GetRecordsIn.Results> testObjectResponseList = GetRecordsIn.GetRecordsIn(testObjectRequestList);
        System.assertEquals(2, testObjectResponseList[0].outputCollection.size());

        /* Collection */
        GetRecordsIn.Requests testRequestCollection = new GetRecordsIn.Requests();
        List<GetRecordsIn.Requests> testCollectionRequestList = new List<GetRecordsIn.Requests>();
        testRequestCollection.outputObject = 'Account';
        testRequestObject.sourceMethod = 'Collection';
        testRequestCollection.sourceValueCollection = accountIds;
        // testRequestCollection.storeAllFields = false;
        testRequestCollection.storeFieldsMethod = 'Choose';
        testCollectionRequestList.add(testRequestCollection);
        List<GetRecordsIn.Results> testCollectionResponseList = GetRecordsIn.GetRecordsIn(testCollectionRequestList);
        System.assertEquals(2, testCollectionResponseList[0].outputCollection.size());

        /* String */
        GetRecordsIn.Requests testRequestString = new GetRecordsIn.Requests();
        List<GetRecordsIn.Requests> testStringRequestList = new List<GetRecordsIn.Requests>();
        testRequestString.outputObject = 'Account';
        testRequestString.sourceValueString = accountIdString;
        // testRequestString.storeAllFields = false;
        testRequestCollection.storeFieldsMethod = 'Choose';
        testRequestString.outputFieldNames = 'Id,Name,AccountNumber';
        testStringRequestList.add(testRequestString);
        List<GetRecordsIn.Results> testStringResponseList = GetRecordsIn.GetRecordsIn(testStringRequestList);
        System.assertEquals(2, testStringResponseList[0].outputCollection.size());

        /* Error */
        GetRecordsIn.Requests testRequestError = new GetRecordsIn.Requests();
        List<GetRecordsIn.Requests> testErrorRequestList = new List<GetRecordsIn.Requests>();
        testRequestError.outputObject = 'Account';
        testRequestError.sourceValueString = accountIdString.substring(1);
        testErrorRequestList.add(testRequestError);
        List<GetRecordsIn.Results> testErrorResponseList = GetRecordsIn.GetRecordsIn(testErrorRequestList);
        // System.assertEquals(null, testErrorResponseList[0]);

    }

}
