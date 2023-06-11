@isTest
public with sharing class mc_lookupControllerTest {
    // Test search method
    @isTest
    private static void searchTest() {
        // Create test data
        String whereClause = 'Name = \'Test\'';
        fsc_lookupController.search('test','Account','Name,Phone','Id',5,whereClause,'Name DESC');
    }

    @isTest
    private static void getRecordsFromIds() {
        // Create test data
        Account a = new Account(Name = 'Test');
        insert a;
        List<String> ids = new List<String>();
        ids.add(a.Id);

        fsc_lookupController.getRecordsFromIds('Account','Name',ids);
    }

    @isTest
    private static void getRecentlyViewedTest() {
        fsc_lookupController.getRecentlyViewed('Account','Name',5,'Name = \'Test\'');
    }

    @isTest
    private static void getFieldMapTest() {
        fsc_lookupController.getFieldMap('Account');
    }

    @isTest
    private static void getNameFieldTest() {
        fsc_lookupController.getNameField('Account');
    }

    @isTest
    private static void splitAndTrimTestNoDelimiter() {
        String testString = 'test1, test2, test3';
        fsc_lookupController.splitAndTrim(testString);
    }

    @isTest
    private static void splitAndTrimTestDelimiter() {
        String testString = 'test1, test2, test3';
        fsc_lookupController.splitAndTrim(testString,',');
    }

    @isTest
    private static void getObjectIconTest() {
        fsc_lookupController.getObjectIcon('Account');
    }

    @isTest
    private static void getRecordsWhereClause() {
        fsc_lookupController.getRecords('Account','Name',5,'Name LIKE \'%Test%\'');
    }

    @isTest
    private static void getRecordDetailTest() {
        String accts = '';
        // Create two test data
        Account a = new Account(Name = 'Test');
        insert a;
        accts = a.Id;
        a = new Account(Name = 'Test2');
        insert a;
        accts += ',' + a.Id;


        fsc_lookupController.getRecordDetail('Account',accts);
    }

    @isTest
    private static void searchTest2() {
        // Create test data
        String whereClause = 'Name = \'Test\'';
        fsc_lookupController.search('test','Account','Name,Phone,Type,Account.Owner.FirstName','Id,Name,Type',5,whereClause,'Name DESC');
    }
}