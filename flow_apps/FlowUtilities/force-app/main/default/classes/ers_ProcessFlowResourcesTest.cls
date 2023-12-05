@isTest
public with sharing class ers_ProcessFlowResourcesTest {
    
    static testMethod void processFlowResourcesTest() {

        Flow_OneView__c dummyRecord = new Flow_OneView__c();
        insert dummyRecord;

        String variable1Metadata = '<variables><name>vDummy1</name><dataType>String</dataType><isCollection>false</isCollection><isInput>false</isInput><isOutput>false</isOutput><value><stringValue>0698c00000Ec4CDAAZ</stringValue></value></variables>';
        String variable2Metadata = '<variables><name>vDummy2</name><dataType>String</dataType><isCollection>false</isCollection><isInput>false</isInput><isOutput>false</isOutput><value><stringValue>0698c00000Ec4CDAAZ</stringValue></value></variables>';
        String formulaMetadata = '<formulas><name>fUserId</name><dataType>String</dataType><expression>{!$User.Id}</expression></formulas>';
        String textTemplateMetadata = '<textTemplates><name>ttHighlightFormat_05</name><isViewedAsPlainText>false</isViewedAsPlainText><text>&lt;p&gt;-------&lt;strong&gt; {API} &lt;/strong&gt; -------&lt;/p&gt;</text></textTemplates>';

        ers_ProcessFlowResources.Requests testRequest = new ers_ProcessFlowResources.Requests();
        List<ers_ProcessFlowResources.Requests> testRequestList = new List<ers_ProcessFlowResources.Requests>();

        // Test single variable
        testRequest.sourceMetadata = variable1Metadata;
        testRequestList.add(testRequest);
        List<ers_ProcessFlowResources.Results> testResultList = ers_ProcessFlowResources.processResources(testRequestList);
        Assert.areEqual('1', String.valueOf(testResultList[0].resourceRecordCollection.size()));
        testRequestList.clear();

        // Test two variables
        testRequest.sourceMetadata = variable1Metadata + variable2Metadata;
        testRequestList.add(testRequest);
        testResultList = ers_ProcessFlowResources.processResources(testRequestList);
        Assert.areEqual('2', String.valueOf(testResultList[0].resourceRecordCollection.size()));
        testRequestList.clear();

        // Test formula and text template
        testRequest.sourceMetadata = formulaMetadata + textTemplateMetadata;
        testRequestList.add(testRequest);
        testResultList = ers_ProcessFlowResources.processResources(testRequestList);
        Assert.areEqual('2', String.valueOf(testResultList[0].resourceRecordCollection.size()));
        testRequestList.clear();

    }

}