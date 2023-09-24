@isTest
public with sharing class ReturnFirstNRecordsTest {
    
    static testMethod void test() {

        Account a1 = new Account(Name='Account1');
        insert a1;
        Account a2 = new Account(Name='Account2');
        insert a2;
        Account a3 = new Account(Name='Account3');
        insert a3;
        Account[] accts = [Select Id, Name from Account];
        Account[] empty = [Select Id, Name from Account WHERE Name='Account99'];
        
        ReturnFirstNRecords.Requests testRequest = new ReturnFirstNRecords.Requests();
        List<ReturnFirstNRecords.Requests> testRequestList = new List<ReturnFirstNRecords.Requests>();

        // Test empty collection
        testRequest.inputCollection = empty;
        testRequest.recordCount = 2;
        testRequestList.add(testRequest);
        List<ReturnFirstNRecords.Results> testResultList = ReturnFirstNRecords.returnNRecords(testRequestList);
        System.assertEquals(0, testResultList[0].returnCount);

        // Test fewer than total collection
        testRequest.inputCollection = accts;
        testRequest.recordCount = 2;
        testRequestList.add(testRequest);
        testResultList = ReturnFirstNRecords.returnNRecords(testRequestList);
        System.assertEquals(2, testResultList[0].returnCount);
        System.assertEquals(2, testResultList[0].outputCollection.size());

        // Test more than total collection
        testRequest.inputCollection = accts;
        testRequest.recordCount = 4;
        testRequestList.add(testRequest);
        testResultList = ReturnFirstNRecords.returnNRecords(testRequestList);
        System.assertEquals(3, testResultList[0].returnCount);
        System.assertEquals(3, testResultList[0].outputCollection.size());

    }

}