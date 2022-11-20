@isTest
public with sharing class AnalyzeFlowsTest {
    @isTest
    static void testExecute() {
        AnalyzeFlows.Request request = new AnalyzeFlows.Request();

        request.initFlow = JSON.serialize( genereateFlowForTest1());
        request.secondFlow = JSON.serialize(genereateFlowForTest2());
        request.analyticalModulenames = 'DetectElementModifications,DetectRemovedElements,DetectNewElements';
        

        AnalyzeFlows.Result result = AnalyzeFlows.execute(new List<AnalyzeFlows.Request>{request})[0];
        System.assert(String.isEmpty(result.errors));
        System.debug(result);
    }


    public static usf3.MetadataService.Flow genereateFlowForTest1(){
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

        // flow.assignments = new  List<usf3.MetadataService.FlowAssignment>();
        // usf3.MetadataService.FlowAssignment flowAssignment = new usf3.MetadataService.FlowAssignment();
        // flowAssignment.Name = 'test_assignment';
        // flowAssignment.assignmentItems = new List<usf3.MetadataService.FlowAssignmentItem>();
        // usf3.MetadataService.FlowAssignmentItem flowAssignmentItem = new usf3.MetadataService.FlowAssignmentItem();
        // flowAssignmentItem.assignToReference = 'Test_reference';
        // flowAssignmentItem.value = new usf3.MetadataService.FlowElementReferenceOrValue();
        // flowAssignmentItem.value.stringValue = 'testvalue';
        // flowAssignment.assignmentItems.add(flowAssignmentItem);
        // flow.assignments.add(flowAssignment);

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

        flow.recordCreates = new  List<usf3.MetadataService.FlowRecordCreate>();
        usf3.MetadataService.FlowRecordCreate flowRecordCreate = new usf3.MetadataService.FlowRecordCreate();
        flowRecordCreate.Name = 'test_Record_Create';
        flowRecordCreate.connector = new usf3.MetadataService.FlowConnector();
        flowRecordCreate.connector.targetReference = 'test_target_reference_1';
        flowRecordCreate.object_x = 'Account';
        flowRecordCreate.inputAssignments = new List<usf3.MetadataService.FlowInputFieldAssignment>();
        usf3.MetadataService.FlowInputFieldAssignment flowInputFieldAssignment = new usf3.MetadataService.FlowInputFieldAssignment();
        flowInputFieldAssignment.field = 'Test_Field';
        flowInputFieldAssignment.value = new usf3.MetadataService.FlowElementReferenceOrValue();
        flowInputFieldAssignment.value.numberValue = 321;
        flowRecordCreate.inputAssignments.add(flowInputFieldAssignment);
        flow.recordCreates.add(flowRecordCreate);


        flow.recordDeletes = new  List<usf3.MetadataService.FlowRecordDelete>();
        usf3.MetadataService.FlowRecordDelete flowRecordDelete = new usf3.MetadataService.FlowRecordDelete();
        flowRecordDelete.Name = 'test_Record_Delete';
        flowRecordDelete.connector = new usf3.MetadataService.FlowConnector();
        flowRecordDelete.connector.targetReference = 'test_target_reference_1';
        flowRecordDelete.faultConnector = new usf3.MetadataService.FlowConnector();
        flowRecordDelete.faultConnector.targetReference = 'test_target_reference_1';
        flowRecordDelete.object_x = 'Account';

        flow.recordDeletes.add(flowRecordDelete);


        flow.subflows = new  List<usf3.MetadataService.FlowSubflow>();
        usf3.MetadataService.FlowSubflow flowSubflow = new usf3.MetadataService.FlowSubflow();
        flowSubflow.Name = 'test_Subflow';
        flowSubflow.connector = new usf3.MetadataService.FlowConnector();
        flowSubflow.connector.targetReference = 'test_target_reference_1';
        flowSubflow.flowName = 'Account';
        flowSubflow.storeOutputAutomatically = true;

        flow.subflows.add(flowSubflow);

        flow.screens = new  List<usf3.MetadataService.FlowScreen>();
        usf3.MetadataService.FlowScreen flowScreen = new usf3.MetadataService.FlowScreen();
        flowScreen.Name = 'test_screen';
        flowScreen.connector = new usf3.MetadataService.FlowConnector();
        flowScreen.connector.targetReference = 'test_target_reference_1';
        flowScreen.allowBack = false;
        flowScreen.allowFinish = false;
        flowScreen.allowPause = false;
        flowScreen.backButtonLabel = 'backButtonLabel1';
        flowScreen.helpText = 'helpText1';
        flowScreen.nextOrFinishButtonLabel = 'nextOrFinishButtonLabel1';
        flowScreen.pauseButtonlabel = 'pauseButtonlabel1';
        flowScreen.pausedText = 'pausedText1';
        flowScreen.showHeader = false;
        flowScreen.showFooter = false;
        usf3.MetadataService.FlowScreenField flowScreenField = new usf3.MetadataService.FlowScreenField();
        flowScreenField.name = 'FlowScreenField1';
        flowScreen.fields = new List<usf3.MetadataService.FlowScreenField>();
        flowScreen.fields.add(flowScreenField);
        flow.screens.add(flowScreen);

        flow.recordLookups = new  List<usf3.MetadataService.FlowRecordLookup>();
        usf3.MetadataService.FlowRecordLookup flowRecordLookup = new usf3.MetadataService.FlowRecordLookup();
        flowRecordLookup.Name = 'test_Record_Lookup';
        flowRecordLookup.connector = new usf3.MetadataService.FlowConnector();
        flowRecordLookup.connector.targetReference = 'test_target_reference_1';
        flowRecordLookup.faultConnector = new usf3.MetadataService.FlowConnector();
        flowRecordLookup.faultConnector.targetReference = 'test_target_reference_1';
        flowRecordLookup.object_x = 'Account';
        flowRecordLookup.filterLogic = 'and';
        flowRecordLookup.sortOrder = '1';
        flowRecordLookup.storeOutputAutomatically = true;


        flow.recordLookups.add(flowRecordLookup);

        flow.recordUpdates = new  List<usf3.MetadataService.FlowRecordUpdate>();
        usf3.MetadataService.FlowRecordUpdate flowRecordUpdate = new usf3.MetadataService.FlowRecordUpdate();
        flowRecordUpdate.Name = 'test_Record_Update';
        flowRecordUpdate.connector = new usf3.MetadataService.FlowConnector();
        flowRecordUpdate.connector.targetReference = 'test_target_reference_1';
        flowRecordUpdate.faultConnector = new usf3.MetadataService.FlowConnector();
        flowRecordUpdate.faultConnector.targetReference = 'test_target_reference_1';
        flowRecordUpdate.object_x = 'Account';
        flowRecordUpdate.inputAssignments = new List<usf3.MetadataService.FlowInputFieldAssignment>();
        flowInputFieldAssignment = new usf3.MetadataService.FlowInputFieldAssignment();
        flowInputFieldAssignment.field = 'Test_Field';
        flowInputFieldAssignment.value = new usf3.MetadataService.FlowElementReferenceOrValue();
        flowInputFieldAssignment.value.numberValue = 321;
        flowRecordUpdate.inputAssignments.add(flowInputFieldAssignment);
        //flow.recordUpdates.add(flowRecordUpdate);

        flowRecordUpdate.filters = new List<usf3.MetadataService.FlowRecordFilter>();
        usf3.MetadataService.FlowRecordFilter flowRecordFilter = new usf3.MetadataService.FlowRecordFilter();
        flowRecordFilter.field = 'Test_Field';
        flowRecordFilter.value = new usf3.MetadataService.FlowElementReferenceOrValue();
        flowRecordFilter.value.numberValue = 321;
        flowRecordUpdate.filters.add(flowRecordFilter);
        flow.recordUpdates.add(flowRecordUpdate);


        flow.start = new  usf3.Flow.FlowStart();
        flow.start.connector = new usf3.MetadataService.FlowConnector();
        flow.start.connector.targetReference = 'test_target_reference_1';
        flow.start.object_x = 'Account';
        flow.start.filterLogic = 'And';
        flow.start.triggerType = 'Create';
        flow.start.schedule = new usf3.Flow.FlowSchedule();
        flow.start.scheduledPaths = new List<usf3.Flow.FlowScheduledPath>();
        usf3.Flow.FlowScheduledPath schedulePath = new usf3.Flow.FlowScheduledPath();
        schedulePath.maxBatchSize = 0;
        schedulePath.offsetNumber = 0;
        schedulePath.offsetUnit = '1';
        schedulePath.pathType = '1';
        schedulePath.recordField = 'id';
        schedulePath.timeSource = 'modifeddate';
        flow.start.scheduledPaths.add(schedulePath);
        flow.start.scheduledPaths.add(schedulePath);



        flow.variables = new  List<usf3.MetadataService.FlowVariable>();
        usf3.MetadataService.FlowVariable flowVariable = new usf3.MetadataService.FlowVariable();
        flowVariable.name = 'Test_Variable';
        flowVariable.value = new usf3.MetadataService.FlowElementReferenceOrValue();
        flowVariable.value.elementReference = 'testvalue';
        flow.variables.add(flowVariable);


        flow.constants = new  List<usf3.MetadataService.FlowConstant>();

        usf3.MetadataService.FlowConstant flowConstant = new usf3.MetadataService.FlowConstant();
        flowConstant.name = 'Test_Constant';
        flowConstant.value = new usf3.MetadataService.FlowElementReferenceOrValue();
        flowConstant.value.elementReference = 'testvalue';
        flow.constants.add(flowConstant);

        return flow;
    }

    public static usf3.MetadataService.Flow genereateFlowForTest2(){
        usf3.MetadataService.Flow flow = genereateFlowForTest1();
        flow.fullName = 'Test_Flow';

        flow.actionCalls = null;

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



        flow.recordCreates = new  List<usf3.MetadataService.FlowRecordCreate>();
        usf3.MetadataService.FlowRecordCreate flowRecordCreate = new usf3.MetadataService.FlowRecordCreate();
        flowRecordCreate.Name = 'test_Record_Create';
        flowRecordCreate.assignRecordIdToReference = 'targetReference';
        flowRecordCreate.connector = new usf3.MetadataService.FlowConnector();
        flowRecordCreate.connector.targetReference = 'test_target_reference_2';
        flowRecordCreate.faultConnector = new usf3.MetadataService.FlowConnector();
        flowRecordCreate.faultConnector.targetReference = 'test_target_reference_2';
        flowRecordCreate.object_x = 'Case';

        flow.recordDeletes = new  List<usf3.MetadataService.FlowRecordDelete>();
        usf3.MetadataService.FlowRecordDelete flowRecordDelete = new usf3.MetadataService.FlowRecordDelete();
        flowRecordDelete.Name = 'test_Record_Delete';
        flowRecordDelete.connector = new usf3.MetadataService.FlowConnector();
        flowRecordDelete.connector.targetReference = 'test_target_reference_2';
        flowRecordDelete.faultConnector = new usf3.MetadataService.FlowConnector();
        flowRecordDelete.faultConnector.targetReference = 'test_target_reference_2';
        flowRecordDelete.object_x = 'Case';
        flowRecordDelete.filterLogic = 'or';


        flow.recordDeletes.add(flowRecordDelete);

        flow.recordLookups = new  List<usf3.MetadataService.FlowRecordLookup>();
        usf3.MetadataService.FlowRecordLookup flowRecordLookup = new usf3.MetadataService.FlowRecordLookup();
        flowRecordLookup.Name = 'test_Record_Lookup';
        flowRecordLookup.connector = new usf3.MetadataService.FlowConnector();
        flowRecordLookup.connector.targetReference = 'test_target_reference_2';
        flowRecordLookup.faultConnector = new usf3.MetadataService.FlowConnector();
        flowRecordLookup.faultConnector.targetReference = 'test_target_reference_2';
        flowRecordLookup.object_x = 'Case';
        flowRecordLookup.filterLogic = 'or';
        flowRecordLookup.sortOrder = '2';
        flowRecordLookup.storeOutputAutomatically = false;


        flow.recordLookups.add(flowRecordLookup);


        flowRecordCreate.inputAssignments = new List<usf3.MetadataService.FlowInputFieldAssignment>();
        usf3.MetadataService.FlowInputFieldAssignment flowInputFieldAssignment = new usf3.MetadataService.FlowInputFieldAssignment();
        flowInputFieldAssignment.field = 'Test_Field2';
        flowInputFieldAssignment.value = new usf3.MetadataService.FlowElementReferenceOrValue();
        flowInputFieldAssignment.value.numberValue = 32;
        flowRecordCreate.inputAssignments.add(flowInputFieldAssignment);
        flow.recordCreates.add(flowRecordCreate);

        flow.recordUpdates = new  List<usf3.MetadataService.FlowRecordUpdate>();
        usf3.MetadataService.FlowRecordUpdate flowRecordUpdate = new usf3.MetadataService.FlowRecordUpdate();
        flowRecordUpdate.Name = 'test_Record_Update';
        flowRecordUpdate.connector = new usf3.MetadataService.FlowConnector();
        flowRecordUpdate.connector.targetReference = 'test_target_reference_2';
        flowRecordUpdate.faultConnector = new usf3.MetadataService.FlowConnector();
        flowRecordUpdate.faultConnector.targetReference = 'test_target_reference_2';
        flowRecordUpdate.object_x = 'Case';
        flowRecordUpdate.inputAssignments = new List<usf3.MetadataService.FlowInputFieldAssignment>();
        flowInputFieldAssignment = new usf3.MetadataService.FlowInputFieldAssignment();
        flowInputFieldAssignment.field = 'Test_Field2';
        flowInputFieldAssignment.value = new usf3.MetadataService.FlowElementReferenceOrValue();
        flowInputFieldAssignment.value.numberValue = 321;
        flowRecordUpdate.inputAssignments.add(flowInputFieldAssignment);
        //flow.recordUpdates.add(flowRecordUpdate);


        flowRecordUpdate.filters = new List<usf3.MetadataService.FlowRecordFilter>();
        usf3.MetadataService.FlowRecordFilter flowRecordFilter = new usf3.MetadataService.FlowRecordFilter();
        flowRecordFilter.field = 'Test_Field3';
        flowRecordFilter.value = new usf3.MetadataService.FlowElementReferenceOrValue();
        flowRecordFilter.value.numberValue = 321;
        flowRecordUpdate.filters.add(flowRecordFilter);
        flow.recordUpdates.add(flowRecordUpdate);

        flow.subflows = new  List<usf3.MetadataService.FlowSubflow>();
        usf3.MetadataService.FlowSubflow flowSubflow = new usf3.MetadataService.FlowSubflow();
        flowSubflow.Name = 'test_Subflow';
        flowSubflow.connector = new usf3.MetadataService.FlowConnector();
        flowSubflow.connector.targetReference = 'test_target_reference_2';
        flowSubflow.flowName = 'Case';
        flowSubflow.storeOutputAutomatically = false;

        flow.subflows.add(flowSubflow);

        flow.screens = new  List<usf3.MetadataService.FlowScreen>();
        usf3.MetadataService.FlowScreen flowScreen = new usf3.MetadataService.FlowScreen();
        flowScreen.Name = 'test_screen';
        flowScreen.connector = new usf3.MetadataService.FlowConnector();
        flowScreen.connector.targetReference = 'test_target_reference_2';
        flowScreen.allowBack = true;
        flowScreen.allowFinish = true;
        flowScreen.allowPause = true;
        flowScreen.backButtonLabel = 'backButtonLabel2';
        flowScreen.helpText = 'helpText2';
        flowScreen.nextOrFinishButtonLabel = 'nextOrFinishButtonLabel2';
        flowScreen.pauseButtonlabel = 'pauseButtonlabel2';
        flowScreen.pausedText = 'pausedText2';
        flowScreen.showHeader = true;
        flowScreen.showFooter = true;
        usf3.MetadataService.FlowScreenField flowScreenField = new usf3.MetadataService.FlowScreenField();
        flowScreenField.name = 'FlowScreenField2';
        flowScreen.fields = new List<usf3.MetadataService.FlowScreenField>();
        flowScreen.fields.add(flowScreenField);
        flow.screens.add(flowScreen);


        flow.start = new  usf3.Flow.FlowStart();
        flow.start.triggerType = 'test 2';
        flow.start.connector = new usf3.MetadataService.FlowConnector();
        flow.start.connector.targetReference = 'test_target_reference_2';
        flow.start.object_x = 'Case';
        flow.start.filterLogic = 'Or';
        flow.start.triggerType = 'Update';
        flow.start.schedule = new usf3.Flow.FlowSchedule();
        flow.start.schedule.frequency = '1';

        flow.start.scheduledPaths = new List<usf3.Flow.FlowScheduledPath>();
        usf3.Flow.FlowScheduledPath schedulePath = new usf3.Flow.FlowScheduledPath();
        schedulePath.maxBatchSize = 1;
        schedulePath.offsetNumber = 1;
        schedulePath.offsetUnit = '2';
        schedulePath.pathType = '2';
        schedulePath.recordField = 'name';
        schedulePath.timeSource = 'createddate';
        flow.start.scheduledPaths.add(schedulePath);


        flow.variables = new  List<usf3.MetadataService.FlowVariable>();
        usf3.MetadataService.FlowVariable flowVariable = new usf3.MetadataService.FlowVariable();
        flowVariable.name = 'Test_Variable';
        flowVariable.value = new usf3.MetadataService.FlowElementReferenceOrValue();
        flowVariable.value.elementReference = 'testvalue';
        flow.variables.add(flowVariable);


        flow.constants = new  List<usf3.MetadataService.FlowConstant>();
        usf3.MetadataService.FlowConstant flowConstant = new usf3.MetadataService.FlowConstant();
        flowConstant.name = 'Test_Constant';
        flowConstant.value = new usf3.MetadataService.FlowElementReferenceOrValue();
        flowConstant.value.elementReference = 'testvalue';
        flow.constants.add(flowConstant);

        return flow;
    }
}
