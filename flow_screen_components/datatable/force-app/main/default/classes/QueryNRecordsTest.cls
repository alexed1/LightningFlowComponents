@isTest
public with sharing class QueryNRecordsTest {

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

        QueryNRecords.QueryParameters testRequest = new QueryNRecords.QueryParameters();
        testRequest.objectApiName = 'Account';
        testRequest.fieldsToQuery = 'Name, AccountNumber, Website, Type, Description';
        testRequest.numberOfRecords = 3;

        List<QueryNRecords.QueryParameters> testRequestList = new List<QueryNRecords.QueryParameters>();
        testRequestList.add(testRequest);

        List<QueryNRecords.QueryResults> testResponseList = QueryNRecords.getNRecords(testRequestList);
        System.assert(testResponseList[0].recordString.contains('"Type":"Type2"'));

    }

}