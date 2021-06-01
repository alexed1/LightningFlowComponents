@isTest
public with sharing class ers_QueryNRecordsTest {

    static testMethod void test() {
        Account a1 = new Account(Name='Test1',
            AccountNumber='1',
            Website='https://trailblazer.me/id/ericsmith',
            Type='Type1',
            Description='D1');
        insert a1;
        Account a2 = new Account(Name='Test2',
            AccountNumber='2',
            Website='https://ericsplayground.wordpress.com/blog/',
            Type='Type2',
            Description='D2');
        insert a2;

        ers_QueryNRecords.QueryParameters testRequest = new ers_QueryNRecords.QueryParameters();
        testRequest.objectApiName = 'Account';
        testRequest.fieldsToQuery = 'Name, AccountNumber, Website, Type, Description';
        testRequest.numberOfRecords = 3;

        List<ers_QueryNRecords.QueryParameters> testRequestList = new List<ers_QueryNRecords.QueryParameters>();
        testRequestList.add(testRequest);

        List<ers_QueryNRecords.QueryResults> testResponseList = ers_QueryNRecords.getNRecords(testRequestList);
        System.assert(testResponseList[0].recordString.contains('"Type":"Type2"'));

    }

}