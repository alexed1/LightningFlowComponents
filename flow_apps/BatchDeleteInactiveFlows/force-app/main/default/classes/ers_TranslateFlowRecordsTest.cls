@isTest
public with sharing class ers_TranslateFlowRecordsTest {

    static testMethod void test() {

        List<ers_FlowDatatableDescriptor> inputList = new List<ers_FlowDatatableDescriptor>();

        ers_TranslateFlowRecords.Requests testRequest = new ers_TranslateFlowRecords.Requests();

        testRequest.inputString = '[{"WorkflowObject":"","VersionNumber":1,"TriggerType":null,"Status":"Active","RowShadeValue":"slds-theme_warning","ProcessType":"AutoLaunchedFlow","LastModifiedDate":"2018-03-18T21:56:34.000Z","LastModifiedBy":"Eric Smith","Label_name":"Test Flow Name #1","Label_lookup":".lightning.force.com/builder_platform_interaction/flowBuilder.app?flowId=3010e0000000VLMAA2","Label":"Test Flow Name #1","IsTemplate":false,"FlowTypeIcon":"utility:flow","FlowStatusIcon":"utility:undeprecate","FlowDefinitionViewId":"3000e00000007PyAAI","DurableId":"3010e0000000VLMAA2","Description":null,"ApiName":"Test_Flow_Name_1"},{"WorkflowObject":"","VersionNumber":2,"TriggerType":null,"Status":"Active","RowShadeValue":"slds-theme_warning","ProcessType":"AutoLaunchedFlow","LastModifiedDate":"2018-03-19T01:26:53.000Z","LastModifiedBy":"Eric Smith","Label_name":"Test Flow Name #2","Label_lookup":".lightning.force.com/builder_platform_interaction/flowBuilder.app?flowId=3010e0000000VLQAA2","Label":"Test Flow Name #2","IsTemplate":false,"FlowTypeIcon":"utility:flow","FlowStatusIcon":"utility:undeprecate","FlowDefinitionViewId":"3000e00000007Q2AAI","DurableId":"3010e0000000VLQAA2","Description":"This is the Flow description","ApiName":"Test_Flow_Name_2"}]';
        testRequest.inputCollection = inputList;

        List<ers_TranslateFlowRecords.Requests> testRequestList = new List<ers_TranslateFlowRecords.Requests>();
        testRequestList.add(testRequest);

        List<ers_TranslateFlowRecords.Results> testResponseList = ers_TranslateFlowRecords.translateADR(testRequestList);
        system.debug('RESPONSE - '+testResponseList);
        system.assertEquals(testResponseList[0].outputCollection.size(), 2, 'Record count should be 2');
    }

}
