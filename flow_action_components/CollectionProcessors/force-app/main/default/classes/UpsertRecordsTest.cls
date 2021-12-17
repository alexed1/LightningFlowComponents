@isTest
public with sharing class UpsertRecordsTest {
    
    @isTest
    public static void canUpsertNewRecords() {
        List<Account> newAccounts = ListActionsTest.createAccounts(4, false);
        UpsertRecords.Request curRequest = new UpsertRecords.Request();
        curRequest.inputCollection = newAccounts;
        List<UpsertRecords.Request> curRequests = new  List<UpsertRecords.Request>();
        curRequests.add(curRequest);
        UpsertRecords.execute(curRequests);
        List<Account> retrievedAccounts = [SELECT Id FROM Account WHERE Name != 'foo'];
        System.assertEquals(4, retrievedAccounts.size());

    }

    @isTest
    public static void canUpsertExistingRecords() {
        List<Account> newAccounts = ListActionsTest.createAccounts(4, true);
        newAccounts[0].Name = 'foo';

        UpsertRecords.Request curRequest = new UpsertRecords.Request();
        curRequest.inputCollection = newAccounts;
        List<UpsertRecords.Request> curRequests = new  List<UpsertRecords.Request>();
        curRequests.add(curRequest);
        UpsertRecords.execute(curRequests);
        List<Account> retrievedAccounts = [SELECT Id FROM Account WHERE Name != 'baz'];
        System.assertEquals(4, retrievedAccounts.size());
        retrievedAccounts = [SELECT Id FROM Account WHERE Name = 'foo'];
        System.assertEquals(1, retrievedAccounts.size());

    }

    @isTest
    public static void canUpsertRecords() {
        List<UpsertRecords.Request> testUpsert = new List<UpsertRecords.Request>();
        UpsertRecords.Request recordToTest = new UpsertRecords.Request();
        recordToTest.objectName = 'Case';
        recordToTest.serializedRecordData = '[{"attributes":{"type":"Case","url":"/services/data/v53.0/sobjects/Case/5000U00000CNmCRQA1"},"CaseNumber":"00001026","Status":"Working","Id":"5000U00000CNmCRQA1"}]';
        testUpsert.add(recordToTest);
        System.debug(UpsertRecords.execute(testUpsert));
        System.assertEquals(1, new List<Case>([SELECT Id FROM Case LIMIT 1]).size());
    }

}