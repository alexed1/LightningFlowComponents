@isTest
public with sharing class ers_CheckForIdsTest {
    
    static testMethod void processFlowResourcesTest() {

        Flow_OneView__c dummyRecord = new Flow_OneView__c();
        dummyRecord.Resource_Metadata__c = '<variables><name>vDummy1</name><dataType>String</dataType><isCollection>false</isCollection><isInput>false</isInput><isOutput>false</isOutput><value><stringValue>0698c00000Ec4CDAAZ</stringValue></value></variables>';
        dummyRecord.Resource_Type__c = 'variables';
        dummyRecord.Resource_name__c = 'vDummy';
        dummyRecord.dataType__c = 'String';
        dummyRecord.value__c = '0698c00000Ec4CDAAZ';
        insert dummyRecord;

        List<Flow_OneView__c> fovRecords = new List<Flow_OneView__c>();
        fovRecords.add(dummyRecord);

        ers_CheckForIds.Requests testRequest = new ers_CheckForIds.Requests();
        List<ers_CheckForIds.Requests> testRequestList = new List<ers_CheckForIds.Requests>();

        // Test single variable
        testRequest.sourceRecords = fovRecords;
        testRequestList.add(testRequest);
        List<ers_CheckForIds.Results> testResultList = ers_CheckForIds.checkForIds(testRequestList);
        Assert.areEqual('1', String.valueOf(testResultList[0].hardcodeRecords.size()));
        testRequestList.clear();

    }

}