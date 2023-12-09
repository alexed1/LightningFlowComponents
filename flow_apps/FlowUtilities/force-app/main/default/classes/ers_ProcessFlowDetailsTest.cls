@isTest
public with sharing class ers_ProcessFlowDetailsTest {

    static testMethod void processFlowDetailsTest() {

        Flow_OneView__c dummyRecord = new Flow_OneView__c();
        insert dummyRecord;

        String flowMetadata = '<?xml version="1.0" encoding="UTF-8"?><Flow xmlns="http://soap.sforce.com/2006/04/metadata"><actionCalls><name>Check_Id</name><label>Check Id</label><locationX>1106</locationX><locationY>518</locationY><actionName>ers_CheckId</actionName><actionType>apex</actionType><connector><targetReference>Do_Stuff</targetReference></connector></actionCalls><apiVersion>56.0</apiVersion><choices><name>Retrieve_Deploy</name><choiceText>Retrieve - Deploy</choiceText><dataType>String</dataType><value><stringValue>Retrieve - Deploy</stringValue></value></choices><description>Return the flow metadata based on the method it was selected.</description><environments>Default</environments><formulas><name>fCaseSafeId</name><dataType>String</dataType><expression>CASESAFEID( LEFT({!vTestId},15) )</expression></formulas><interviewLabel>Flow OneView - Test Sample {!$Flow.CurrentDateTime}</interviewLabel><label>Flow OneView - Test Sample</label><processMetadataValues><name>BuilderType</name><value><stringValue>LightningFlowBuilder</stringValue></value></processMetadataValues><processMetadataValues><name>CanvasMode</name><value><stringValue>AUTO_LAYOUT_CANVAS</stringValue></value></processMetadataValues><processMetadataValues><name>OriginBuilderType</name><value><stringValue>LightningFlowBuilder</stringValue></value></processMetadataValues><processType>Flow</processType><runInMode>SystemModeWithoutSharing</runInMode><status>Draft</status><textTemplates><name>ttHighlightFormat_05</name><isViewedAsPlainText>false</isViewedAsPlainText><text>&lt;p&gt;-------&lt;strong&gt; {API} &lt;/strong&gt; -------&lt;/p&gt;</text></textTemplates><variables><name>colDocIds</name><dataType>String</dataType><isCollection>true</isCollection><isInput>false</isInput><isOutput>false</isOutput></variables></Flow>';

        ers_ProcessFlowDetails.Requests testRequest = new ers_ProcessFlowDetails.Requests();
        List<ers_ProcessFlowDetails.Requests> testRequestList = new List<ers_ProcessFlowDetails.Requests>();

        testRequest.sourceMetadata = flowMetadata;
        testRequestList.add(testRequest);
        List<ers_ProcessFlowDetails.Results> testResultList = ers_ProcessFlowDetails.processDetails(testRequestList);
        Assert.areEqual('11', String.valueOf(testResultList[0].detailRecordCollection.size()));
        testRequestList.clear();

    }
}