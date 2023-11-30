@isTest
public with sharing class ers_CheckIdTest {
    
    static testMethod void checkIdTest() {

        Flow_OneView__c dummyRecord = new Flow_OneView__c();

        String testGoodId = '001000000000000';
        String testUnknownId = '999000000000000';
        String testBadId = 'abcdefghijklmno';
        String testLongId = '001000000000000000000000';
        String testShortId = '001';
        String testEmptyId = '';

        ers_CheckId.Requests testRequest = new ers_CheckId.Requests();
        List<ers_CheckId.Requests> testRequestList = new List<ers_CheckId.Requests>();

        // Test valid record id
        testRequest.dummyRecord = dummyRecord;
        testRequest.recordId = testGoodId;
        testRequestList.add(testRequest);
        List<ers_CheckId.Results> testResultList = ers_CheckId.checkId(testRequestList);
        Assert.areEqual('Account', testResultList[0].sobjectType);
        Assert.isTrue(testResultList[0].isRecordId);
        testRequestList.clear();

        // Test unknown record id
        testRequest.dummyRecord = dummyRecord;
        testRequest.recordId = testUnknownId;
        testRequestList.add(testRequest);
        testResultList = ers_CheckId.checkId(testRequestList);
        Assert.areEqual('(unknown)', testResultList[0].sobjectType);
        Assert.isTrue(testResultList[0].isRecordId);
        testRequestList.clear();

        // Test invalid record id
        testRequest.dummyRecord = dummyRecord;
        testRequest.recordId = testBadId;
        testRequestList.add(testRequest);
        testResultList = ers_CheckId.checkId(testRequestList);
        Assert.isFalse(testResultList[0].isRecordId);
        testRequestList.clear();

        // Test valid long record id
        testRequest.dummyRecord = dummyRecord;
        testRequest.recordId = testLongId;
        testRequestList.add(testRequest);
        testResultList = ers_CheckId.checkId(testRequestList);
        Assert.areEqual('Account', testResultList[0].sobjectType);
        Assert.isTrue(testResultList[0].isRecordId);
        testRequestList.clear();

        // Test valid short record id
        testRequest.dummyRecord = dummyRecord;
        testRequest.recordId = testShortId;
        testRequestList.add(testRequest);
        testResultList = ers_CheckId.checkId(testRequestList);
        Assert.areEqual('Account', testResultList[0].sobjectType);
        Assert.isTrue(testResultList[0].isRecordId);
        testRequestList.clear();

        // Test null record id
        testRequest.dummyRecord = dummyRecord;
        testRequest.recordId = testEmptyId;
        testRequestList.add(testRequest);
        testResultList = ers_CheckId.checkId(testRequestList);
        Assert.isFalse(testResultList[0].isRecordId);
        testRequestList.clear();

    }

}