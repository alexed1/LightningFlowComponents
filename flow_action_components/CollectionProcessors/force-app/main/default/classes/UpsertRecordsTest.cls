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
}