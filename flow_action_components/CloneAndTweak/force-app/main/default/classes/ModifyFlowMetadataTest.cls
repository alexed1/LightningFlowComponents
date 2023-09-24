@isTest
public with sharing class ModifyFlowMetadataTest {
    @isTest
    static void testExecute() {
        ModifyFlowMetadata.Request request = new ModifyFlowMetadata.Request();

        request.flowName = 'testflow';
        request.entityPath1 = 'Flow.FlowAssignment[test_assignment].FlowAssignmentItem[Test_reference].value';
        request.value1 = 'test2';
        request.entityPath2 = 'Flow.FlowActionCall[test_action_call].FlowActionCallInputParameter[Test_Input].value';
        request.value2 = 'test3';
        request.entityPath3 = 'Flow.FlowChoice[Test_Choice]';
        request.value3 = 'true';
        request.entityPath4 = 'Flow.FlowApexPluginCall[test_action_call].FlowApexPluginCallInputParameter[Test_Input].value';
        request.value4 = 'test5';
        request.entityPath5 = 'Flow.FlowRecordCreate[test_Record_Create].FlowInputFieldAssignment[Test_Field].value';
        request.value5 = '123';
        request.action = '';
        request.newFlowName = '';

        ModifyFlowMetadata.Result result = ModifyFlowMetadata.execute(new List<ModifyFlowMetadata.Request>{request})[0];

        System.assert(result.modifiedFlowMetadata.assignments[0].assignmentItems[0].value.stringValue == request.value1);
        System.assert(result.modifiedFlowMetadata.actionCalls[0].inputParameters[0].value.stringValue == request.value2);
        System.assert(result.modifiedFlowMetadata.choices[0].value.elementReference == request.value3);
        System.assert(result.modifiedFlowMetadata.apexPluginCalls[0].inputParameters[0].value.booleanValue == Boolean.valueOf(request.value4));
        System.assert(result.modifiedFlowMetadata.recordCreates[0].inputAssignments[0].value.numberValue == Double.valueof(request.value5));
        System.debug(result);

        request.flowName = 'testflow';
        request.entityPath1 = 'Flow.FlowRecordUpdate[test_Record_Update].FlowInputFieldAssignment[Test_Field].value';
        request.value1 = '123';
        request.entityPath2 = 'Flow.FlowRecordUpdate[test_Record_Update].FlowRecordFilter[Test_Field].value';
        request.value2 = '111';
        request.entityPath3 = 'Flow.FlowDecision[test_decision].FlowRule[Test_Rule].FlowCondition[Test_Reference].rightValue';
        request.value3 = 'true';
        request.entityPath4 = 'Flow.FlowVariable[Test_Variable]';
        request.value4 = 'test5';
        request.entityPath5 = 'Flow.FlowConstant[Test_Constant]';
        request.value5 = '123';
        request.action = '';
        request.newFlowName = '';

        result = ModifyFlowMetadata.execute(new List<ModifyFlowMetadata.Request>{request})[0];
        
        System.assert(result.modifiedFlowMetadata.recordUpdates[0].inputAssignments[0].value.numberValue ==Double.valueof(request.value1));
        System.assert(result.modifiedFlowMetadata.recordUpdates[0].filters[0].value.numberValue == Double.valueof(request.value2));
        System.assert(result.modifiedFlowMetadata.decisions[0].rules[0].conditions[0].rightValue.stringValue == request.value3);
        System.assert(result.modifiedFlowMetadata.variables[0].value.elementReference == request.value4);
        System.assert(result.modifiedFlowMetadata.constants[0].value.elementReference == request.value5);
        System.debug(result);

        request.flowName = 'testflow';
        request.entityPath1 = 'Flow.FlowStart.FlowSchedule';
        request.value1 = '10/27/2022, 5:23 AM';
        request.action = '';
        request.newFlowName = '';

        result = ModifyFlowMetadata.execute(new List<ModifyFlowMetadata.Request>{request})[0];
        Datetime dt = DateTime.parse(request.value1);
        System.assert(result.modifiedFlowMetadata.start.schedule.startDate == dt.date());
        System.assert(result.modifiedFlowMetadata.start.schedule.startTime == dt.format('HH:mm:ss'));

        System.debug(result);

        //fire exception
        request.flowName = 'testflow';
        request.entityPath1 = 'Flow.FlowStart.FlowSchedule';
        request.value1 = 'invalid datetime format';
        request.action = '';
        request.newFlowName = '';

        result = ModifyFlowMetadata.execute(new List<ModifyFlowMetadata.Request>{request})[0];
        System.assert(String.isNotEmpty(result.errors));
    }


    public static usf3.MetadataService.Flow genereateFlowForTest(){
        usf3.MetadataService.Flow flow = new usf3.MetadataService.Flow();
        flow.fullName = 'Test_Flow';
        flow.actionCalls = new  List<usf3.MetadataService.FlowActionCall>();
        usf3.MetadataService.FlowActionCall flowActionCall = new usf3.MetadataService.FlowActionCall();
        flowActionCall.Name = 'test_action_call';
        flowActionCall.inputParameters = new List<usf3.MetadataService.FlowActionCallInputParameter>();
        usf3.MetadataService.FlowActionCallInputParameter callInputParamenter = new usf3.MetadataService.FlowActionCallInputParameter();
        callInputParamenter.name = 'Test_Input';
        callInputParamenter.value = new usf3.MetadataService.FlowElementReferenceOrValue();
        callInputParamenter.value.stringValue = 'testvalue';
        flowActionCall.inputParameters.add(callInputParamenter);
        flow.actionCalls.add(flowActionCall);

        flow.assignments = new  List<usf3.MetadataService.FlowAssignment>();
        usf3.MetadataService.FlowAssignment flowAssignment = new usf3.MetadataService.FlowAssignment();
        flowAssignment.Name = 'test_assignment';
        flowAssignment.assignmentItems = new List<usf3.MetadataService.FlowAssignmentItem>();
        usf3.MetadataService.FlowAssignmentItem flowAssignmentItem = new usf3.MetadataService.FlowAssignmentItem();
        flowAssignmentItem.assignToReference = 'Test_reference';
        flowAssignmentItem.value = new usf3.MetadataService.FlowElementReferenceOrValue();
        flowAssignmentItem.value.stringValue = 'testvalue';
        flowAssignment.assignmentItems.add(flowAssignmentItem);
        flow.assignments.add(flowAssignment);

        flow.choices = new  List<usf3.MetadataService.FlowChoice>();
        usf3.MetadataService.FlowChoice flowChoice = new usf3.MetadataService.FlowChoice();
        flowChoice.name = 'Test_Choice';
        flowChoice.value = new usf3.MetadataService.FlowElementReferenceOrValue();
        flowChoice.value.elementReference = 'testvalue';
        flow.choices.add(flowChoice);

        flow.apexPluginCalls = new  List<usf3.MetadataService.FlowApexPluginCall>();
        usf3.MetadataService.FlowApexPluginCall flowApexPluginCall = new usf3.MetadataService.FlowApexPluginCall();
        flowApexPluginCall.Name = 'test_action_call';
        flowApexPluginCall.inputParameters = new List<usf3.MetadataService.FlowApexPluginCallInputParameter>();
        usf3.MetadataService.FlowApexPluginCallInputParameter pluginCallInputParamenter = new usf3.MetadataService.FlowApexPluginCallInputParameter();
        pluginCallInputParamenter.name = 'Test_Input';
        pluginCallInputParamenter.value = new usf3.MetadataService.FlowElementReferenceOrValue();
        pluginCallInputParamenter.value.booleanValue = false;
        flowApexPluginCall.inputParameters.add(pluginCallInputParamenter);
        flow.apexPluginCalls.add(flowApexPluginCall);

        //Flow.FlowDecision[test_decision].FlowRule[Test_Rule].FlowCondition[Test_Reference].rightValue
        flow.decisions = new  List<usf3.MetadataService.FlowDecision>();
        usf3.MetadataService.FlowDecision flowDecision = new usf3.MetadataService.FlowDecision();
        flowDecision.Name = 'test_decision';
        flowDecision.rules = new List<usf3.MetadataService.FlowRule>();
        usf3.MetadataService.FlowRule flowRule = new usf3.MetadataService.FlowRule();
        flowRule.name = 'Test_Rule';
        flowRule.conditions = new List<usf3.MetadataService.FlowCondition>();
        usf3.MetadataService.FlowCondition flowCondition = new usf3.MetadataService.FlowCondition();
        flowCondition.leftValueReference = 'Test_Reference';
        flowCondition.rightValue = new usf3.MetadataService.FlowElementReferenceOrValue();
        flowCondition.rightValue.stringValue = 'testvalue';
        flowRule.conditions.add(flowCondition);
        flowDecision.rules.add(flowRule);
        flow.decisions.add(flowDecision);

        flow.recordCreates = new  List<usf3.MetadataService.FlowRecordCreate>();//Flow.FlowRecordCreate[test_Record_Create].FlowInputFieldAssignment[Test_Field].value
        usf3.MetadataService.FlowRecordCreate flowRecordCreate = new usf3.MetadataService.FlowRecordCreate();
        flowRecordCreate.Name = 'test_Record_Create';
        flowRecordCreate.inputAssignments = new List<usf3.MetadataService.FlowInputFieldAssignment>();
        usf3.MetadataService.FlowInputFieldAssignment flowInputFieldAssignment = new usf3.MetadataService.FlowInputFieldAssignment();
        flowInputFieldAssignment.field = 'Test_Field';
        flowInputFieldAssignment.value = new usf3.MetadataService.FlowElementReferenceOrValue();
        flowInputFieldAssignment.value.numberValue = 321;
        flowRecordCreate.inputAssignments.add(flowInputFieldAssignment);
        flow.recordCreates.add(flowRecordCreate);

        flow.recordUpdates = new  List<usf3.MetadataService.FlowRecordUpdate>();//Flow.FlowRecordUpdate[test_Record_Update].FlowInputFieldAssignment[Test_Field].value
        usf3.MetadataService.FlowRecordUpdate flowRecordUpdate = new usf3.MetadataService.FlowRecordUpdate();
        flowRecordUpdate.Name = 'test_Record_Update';
        flowRecordUpdate.inputAssignments = new List<usf3.MetadataService.FlowInputFieldAssignment>();
        flowInputFieldAssignment = new usf3.MetadataService.FlowInputFieldAssignment();
        flowInputFieldAssignment.field = 'Test_Field';
        flowInputFieldAssignment.value = new usf3.MetadataService.FlowElementReferenceOrValue();
        flowInputFieldAssignment.value.numberValue = 321;
        flowRecordUpdate.inputAssignments.add(flowInputFieldAssignment);
        //flow.recordUpdates.add(flowRecordUpdate);

        //Flow.FlowRecordUpdate[test_Record_Update].FlowRecordFilter[Test_Field].value
        flowRecordUpdate.filters = new List<usf3.MetadataService.FlowRecordFilter>();
        usf3.MetadataService.FlowRecordFilter flowRecordFilter = new usf3.MetadataService.FlowRecordFilter();
        flowRecordFilter.field = 'Test_Field';
        flowRecordFilter.value = new usf3.MetadataService.FlowElementReferenceOrValue();
        flowRecordFilter.value.numberValue = 321;
        flowRecordUpdate.filters.add(flowRecordFilter);
        flow.recordUpdates.add(flowRecordUpdate);

        //Flow.FlowStart.FlowSchedule
        flow.start = new  usf3.Flow.FlowStart();
        flow.start.schedule = new usf3.Flow.FlowSchedule();


        //Flow.FlowVariable[Test_Variable]
        flow.variables = new  List<usf3.MetadataService.FlowVariable>();
        usf3.MetadataService.FlowVariable flowVariable = new usf3.MetadataService.FlowVariable();
        flowVariable.name = 'Test_Variable';
        flowVariable.value = new usf3.MetadataService.FlowElementReferenceOrValue();
        flowVariable.value.elementReference = 'testvalue';
        flow.variables.add(flowVariable);

        //Flow.FlowConstant[Test_Constant]
        flow.constants = new  List<usf3.MetadataService.FlowConstant>();

        usf3.MetadataService.FlowConstant flowConstant = new usf3.MetadataService.FlowConstant();
        flowConstant.name = 'Test_Constant';
        flowConstant.value = new usf3.MetadataService.FlowElementReferenceOrValue();
        flowConstant.value.elementReference = 'testvalue';
        flow.constants.add(flowConstant);

        return flow;
    }

}
