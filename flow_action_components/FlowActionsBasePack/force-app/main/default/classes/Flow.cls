global class Flow{

    @JsonAccess(serializable='always' deserializable = 'always')
	global class FlowStart {
        global String type='FlowStart';
        global MetadataService.FlowConnector connector;
        global Boolean doesRequireRecordChangedToMeetCriteria;
        global String filterFormula;
        global String filterLogic;
        global MetadataService.FlowRecordFilter[] filters;
		global Integer locationX;
		global Integer locationY;
        global String object_x;
        global String objectContainer;
        global String recordTriggerType;
        global Flow.FlowSchedule schedule;
        global Flow.FlowScheduledPath[] scheduledPaths;
        global String segment;
        global String triggerType;
        private String[] connector_type_info = new String[]{'connector',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] doesRequireRecordChangedToMeetCriteria_type_info = new String[]{'doesRequireRecordChangedToMeetCriteria',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] filterFormula_type_info = new String[]{'filterFormula',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] filterLogic_type_info = new String[]{'filterLogic',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] filters_type_info = new String[]{'filters',MetadataService.SOAP_M_URI,null,'0','-1','false'};
        //private String[] label_type_info=new String[]{'label',SOAP_M_URI,null,'1','1','false'};
		private String[] locationX_type_info=new String[]{'locationX',MetadataService.SOAP_M_URI,null,'1','1','false'};
		private String[] locationY_type_info=new String[]{'locationY',MetadataService.SOAP_M_URI,null,'1','1','false'};
        private String[] object_x_type_info = new String[]{'object',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] objectContainer_type_info = new String[]{'objectContainer',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] recordTriggerType_type_info = new String[]{'recordTriggerType',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] schedule_type_info = new String[]{'schedule',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] scheduledPaths_type_info = new String[]{'scheduledPaths',MetadataService.SOAP_M_URI,null,'0','-1','false'};
        private String[] segment_type_info = new String[]{'segment',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] triggerType_type_info = new String[]{'triggerType',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{MetadataService.SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'connector','doesRequireRecordChangedToMeetCriteria','filterFormula','filterLogic','filters', 'locationX', 'locationY', 'object_x','objectContainer','recordTriggerType','schedule','scheduledPaths','segment','triggerType'};
    }

    @JsonAccess(serializable='always' deserializable = 'always')
	global class FlowScheduledPath {
        global String type='FlowScheduledPath';
        global String name;
		private String[] name_type_info=new String[]{'name',MetadataService.SOAP_M_URI,null,'0','1','false'};
        global MetadataService.FlowConnector connector;
        global String label;
        global Integer maxBatchSize;
        global Integer offsetNumber;
        global String offsetUnit;
        global String pathType;
        global String recordField;
        global String timeSource;
        private String[] connector_type_info = new String[]{'connector',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] label_type_info = new String[]{'label',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] maxBatchSize_type_info = new String[]{'maxBatchSize',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] offsetNumber_type_info = new String[]{'offsetNumber',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] offsetUnit_type_info = new String[]{'offsetUnit',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] pathType_type_info = new String[]{'pathType',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] recordField_type_info = new String[]{'recordField',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] timeSource_type_info = new String[]{'timeSource',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{MetadataService.SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'name', 'connector','label','maxBatchSize','offsetNumber','offsetUnit','pathType','recordField','timeSource'};
    }

	@JsonAccess(serializable='always' deserializable = 'always')
	global class FlowSchedule {
        global String type='FlowSchedule';
        global String frequency;
        global Date startDate;
        global String startTime;
        private String[] frequency_type_info = new String[]{'frequency',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] startDate_type_info = new String[]{'startDate',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] startTime_type_info = new String[]{'startTime',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{MetadataService.SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'frequency','startDate','startTime'};
    }

	@JsonAccess(serializable='always' deserializable = 'always')
	global class FlowRecordRollback extends MetadataService.FlowNode{
        global String type='FlowRecordRollback';
        global MetadataService.FlowConnector connector;
        global String label;
		global Integer locationX;
		global Integer locationY;
        private String[] connector_type_info = new String[]{'connector',MetadataService.SOAP_M_URI,null,'0','1','false'};
		private String[] label_type_info=new String[]{'label',MetadataService.SOAP_M_URI,null,'1','1','false'};
		private String[] locationX_type_info=new String[]{'locationX',MetadataService.SOAP_M_URI,null,'1','1','false'};
		private String[] locationY_type_info=new String[]{'locationY',MetadataService.SOAP_M_URI,null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{MetadataService.SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'connector', 'label', 'locationX', 'locationY'};
    }

	@JsonAccess(serializable='always' deserializable = 'always')
	global class FlowOrchestratedStage {
        global String type='FlowOrchestratedStage';
        global MetadataService.FlowConnector connector;
        global Flow.FlowStageStepExitActionInputParameter[] exitActionInputParameters;
        global String exitActionName;
        global Flow.FlowStageStepExitActionOutputParameter[] exitActionOutputParameters;
        global String exitActionType;
        global String exitConditionLogic;
        global MetadataService.FlowCondition[] exitConditions;
        global MetadataService.FlowConnector faultConnector;
        Flow.FlowStageStep[] stageSteps;
        private String[] connector_type_info = new String[]{'connector',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] exitActionInputParameters_type_info = new String[]{'exitActionInputParameters',MetadataService.SOAP_M_URI,null,'0','-1','false'};
        private String[] exitActionName_type_info = new String[]{'exitActionName',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] exitActionOutputParameters_type_info = new String[]{'exitActionOutputParameters',MetadataService.SOAP_M_URI,null,'0','-1','false'};
        private String[] exitActionType_type_info = new String[]{'exitActionType',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] exitConditionLogic_type_info = new String[]{'exitConditionLogic',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] exitConditions_type_info = new String[]{'exitConditions',MetadataService.SOAP_M_URI,null,'0','-1','false'};
        private String[] faultConnector_type_info = new String[]{'faultConnector',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] stageSteps_type_info = new String[]{'stageSteps',MetadataService.SOAP_M_URI,null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{MetadataService.SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'connector','exitActionInputParameters','exitActionName','exitActionOutputParameters','exitActionType','exitConditionLogic','exitConditions','faultConnector','stageSteps'};
    }

	@JsonAccess(serializable='always' deserializable = 'always')
	global class FlowStageStepExitActionInputParameter {
        global String type='FlowStageStepExitActionInputParameter';
        global String name;
        global MetadataService.FlowElementReferenceOrValue value;
        private String[] name_type_info = new String[]{'name',MetadataService.SOAP_M_URI,null,'1','1','false'};
        private String[] value_type_info = new String[]{'value',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{MetadataService.SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'name','value'};
    }

	@JsonAccess(serializable='always' deserializable = 'always')
	global class FlowStageStepExitActionOutputParameter {
        global String type='FlowStageStepExitActionOutputParameter';
        global String assignToReference;
        global String name;
        private String[] assignToReference_type_info = new String[]{'assignToReference',MetadataService.SOAP_M_URI,null,'1','1','false'};
        private String[] name_type_info = new String[]{'name',MetadataService.SOAP_M_URI,null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{MetadataService.SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'assignToReference','name'};
    }

	@JsonAccess(serializable='always' deserializable = 'always')
	global class FlowStageStep {
        global String type='FlowStageStep';
        global String actionName;
        global String actionType;
        global Flow.FlowStageStepAssignee[] assignees;
        global Flow.FlowStageStepEntryActionInputParameter[] entryActionInputParameters;
        global String entryActionName;
        global Flow.FlowStageStepEntryActionOutputParameter[] entryActionOutputParameters;
        global String entryActionType;
        global String entryConditionLogic;
        global MetadataService.FlowCondition[] entryConditions;
        global Flow.FlowStageStepExitActionInputParameter[] exitActionInputParameters;
        global String exitActionName;
        global Flow.FlowStageStepExitActionOutputParameter[] exitActionOutputParameters;
        global String exitActionType;
        global Flow.FlowStageStepInputParameter[] inputParameters;
        global String label;
        global Flow.FlowStageStepOutputParameter[] outputParameters;
        global Boolean requiresAsyncProcessing;
        global String stepSubtype;
        private String[] actionName_type_info = new String[]{'actionName',MetadataService.SOAP_M_URI,null,'1','1','false'};
        private String[] actionType_type_info = new String[]{'actionType',MetadataService.SOAP_M_URI,null,'1','1','false'};
        private String[] assignees_type_info = new String[]{'assignees',MetadataService.SOAP_M_URI,null,'0','-1','false'};
        private String[] entryActionInputParameters_type_info = new String[]{'entryActionInputParameters',MetadataService.SOAP_M_URI,null,'0','-1','false'};
        private String[] entryActionName_type_info = new String[]{'entryActionName',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] entryActionOutputParameters_type_info = new String[]{'entryActionOutputParameters',MetadataService.SOAP_M_URI,null,'0','-1','false'};
        private String[] entryActionType_type_info = new String[]{'entryActionType',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] entryConditionLogic_type_info = new String[]{'entryConditionLogic',MetadataService.SOAP_M_URI,null,'1','1','false'};
        private String[] entryConditions_type_info = new String[]{'entryConditions',MetadataService.SOAP_M_URI,null,'0','-1','false'};
        private String[] exitActionInputParameters_type_info = new String[]{'exitActionInputParameters',MetadataService.SOAP_M_URI,null,'0','-1','false'};
        private String[] exitActionName_type_info = new String[]{'exitActionName',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] exitActionOutputParameters_type_info = new String[]{'exitActionOutputParameters',MetadataService.SOAP_M_URI,null,'0','-1','false'};
        private String[] exitActionType_type_info = new String[]{'exitActionType',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] inputParameters_type_info = new String[]{'inputParameters',MetadataService.SOAP_M_URI,null,'0','-1','false'};
        private String[] label_type_info = new String[]{'label',MetadataService.SOAP_M_URI,null,'1','1','false'};
        private String[] outputParameters_type_info = new String[]{'outputParameters',MetadataService.SOAP_M_URI,null,'0','-1','false'};
        private String[] requiresAsyncProcessing_type_info = new String[]{'requiresAsyncProcessing',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] stepSubtype_type_info = new String[]{'stepSubtype',MetadataService.SOAP_M_URI,null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{MetadataService.SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'actionName','actionType','assignees','entryActionInputParameters','entryActionName','entryActionOutputParameters','entryActionType','entryConditionLogic','entryConditions','exitActionInputParameters','exitActionName','exitActionOutputParameters','exitActionType','inputParameters','label','outputParameters','requiresAsyncProcessing','stepSubtype'};
    }

    @JsonAccess(serializable='always' deserializable = 'always')
	global class FlowCollectionProcessor {
        global String type='FlowCollectionProcessor';
        global String assignNextValueToReference;
        global String collectionProcessorType;
        global String collectionReference;
        global String conditionLogic;
        global MetadataService.FlowCondition[] conditions;
        global MetadataService.FlowConnector connector;
        global String formula;
        global Integer limit_x;
        global Flow.FlowCollectionMapItem[] mapItems;
        global String outputSObjectType;
        global Flow.FlowCollectionSortOption[] sortOptions;
        private String[] assignNextValueToReference_type_info = new String[]{'assignNextValueToReference',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] collectionProcessorType_type_info = new String[]{'collectionProcessorType',MetadataService.SOAP_M_URI,null,'1','1','false'};
        private String[] collectionReference_type_info = new String[]{'collectionReference',MetadataService.SOAP_M_URI,null,'1','1','false'};
        private String[] conditionLogic_type_info = new String[]{'conditionLogic',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] conditions_type_info = new String[]{'conditions',MetadataService.SOAP_M_URI,null,'0','-1','false'};
        private String[] connector_type_info = new String[]{'connector',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] formula_type_info = new String[]{'formula',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] limit_x_type_info = new String[]{'limit',MetadataService.SOAP_M_URI,null,'0','1','true'};
        private String[] mapItems_type_info = new String[]{'mapItems',MetadataService.SOAP_M_URI,null,'0','-1','false'};
        private String[] outputSObjectType_type_info = new String[]{'outputSObjectType',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] sortOptions_type_info = new String[]{'sortOptions',MetadataService.SOAP_M_URI,null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{MetadataService.SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'assignNextValueToReference','collectionProcessorType','collectionReference','conditionLogic','conditions','connector','formula','limit_x','mapItems','outputSObjectType','sortOptions'};
    }

	@JsonAccess(serializable='always' deserializable = 'always')
	global class FlowCollectionSortOption {
        global String type='FlowCollectionSortOption';
        global Boolean doesPutEmptyStringAndNullFirst;
        global String sortField;
        global String sortOrder;
        private String[] doesPutEmptyStringAndNullFirst_type_info = new String[]{'doesPutEmptyStringAndNullFirst',MetadataService.SOAP_M_URI,null,'1','1','false'};
        private String[] sortField_type_info = new String[]{'sortField',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] sortOrder_type_info = new String[]{'sortOrder',MetadataService.SOAP_M_URI,null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{MetadataService.SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'doesPutEmptyStringAndNullFirst','sortField','sortOrder'};
    }

    @JsonAccess(serializable='always' deserializable = 'always')
	global class FlowCollectionMapItem {
        global String type='FlowCollectionMapItem';
        global String assignToFieldReference;
        global String operator;
        global MetadataService.FlowElementReferenceOrValue value;
        private String[] assignToFieldReference_type_info = new String[]{'assignToFieldReference',MetadataService.SOAP_M_URI,null,'1','1','false'};
        private String[] operator_type_info = new String[]{'operator',MetadataService.SOAP_M_URI,null,'1','1','false'};
        private String[] value_type_info = new String[]{'value',MetadataService.SOAP_M_URI,null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{MetadataService.SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'assignToFieldReference','operator','value'};
    }

    @JsonAccess(serializable='always' deserializable = 'always')
    global class FlowStageStepOutputParameter {
        global String type='FlowStageStepOutputParameter';
        global String assignToReference;
        global String name;
        private String[] assignToReference_type_info = new String[]{'assignToReference',MetadataService.SOAP_M_URI,null,'1','1','false'};
        private String[] name_type_info = new String[]{'name',MetadataService.SOAP_M_URI,null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{MetadataService.SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'assignToReference','name'};
    }

    @JsonAccess(serializable='always' deserializable = 'always')
    global class FlowStageStepInputParameter {
        global String type='FlowStageStepInputParameter';
        global String name;
        global  MetadataService.FlowElementReferenceOrValue value;
        private String[] name_type_info = new String[]{'name',MetadataService.SOAP_M_URI,null,'1','1','false'};
        private String[] value_type_info = new String[]{'value',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{MetadataService.SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'name','value'};
    }

    @JsonAccess(serializable='always' deserializable = 'always')
    global class FlowStageStepEntryActionOutputParameter {
        global String type='FlowStageStepEntryActionOutputParameter';
        global String assignToReference;
        global String name;
        private String[] assignToReference_type_info = new String[]{'assignToReference',MetadataService.SOAP_M_URI,null,'1','1','false'};
        private String[] name_type_info = new String[]{'name',MetadataService.SOAP_M_URI,null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{MetadataService.SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'assignToReference','name'};
    }

    @JsonAccess(serializable='always' deserializable = 'always')
    global class FlowStageStepEntryActionInputParameter {
        global String type='FlowStageStepEntryActionInputParameter';
        global String name;
        global MetadataService.FlowElementReferenceOrValue value;
        private String[] name_type_info = new String[]{'name',MetadataService.SOAP_M_URI,null,'1','1','false'};
        private String[] value_type_info = new String[]{'value',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{MetadataService.SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'name','value'};
    }

    @JsonAccess(serializable='always' deserializable = 'always')
    global class FlowStageStepAssignee {
        global String type='FlowStageStepAssignee';
        global MetadataService.FlowElementReferenceOrValue assignee;
        global String assigneeType;
        private String[] assignee_type_info = new String[]{'assignee',MetadataService.SOAP_M_URI,null,'1','1','false'};
        private String[] assigneeType_type_info = new String[]{'assigneeType',MetadataService.SOAP_M_URI,null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{MetadataService.SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'assignee','assigneeType'};
    }

    @JsonAccess(serializable='always' deserializable = 'always')
    global class FlowDataTypeMapping {
        global String type='FlowDataTypeMapping';
        global String typeName;
        global String typeValue;
        private String[] typeName_type_info = new String[]{'typeName',MetadataService.SOAP_M_URI,null,'1','1','false'};
        private String[] typeValue_type_info = new String[]{'typeValue',MetadataService.SOAP_M_URI,null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{MetadataService.SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'typeName','typeValue'};
    }

    global class FlowTransform {
        global String type='FlowTransform';
        global String apexClass;
        global MetadataService.FlowConnector connector;
        global String dataType;
        global Boolean isCollection;
        global String objectType;
        global Integer scale;
        global FlowTransformValue[] transformValues;
        private String[] apexClass_type_info = new String[]{'apexClass',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] connector_type_info = new String[]{'connector',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] dataType_type_info = new String[]{'dataType',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] isCollection_type_info = new String[]{'isCollection',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] objectType_type_info = new String[]{'objectType',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] scale_type_info = new String[]{'scale',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] transformValues_type_info = new String[]{'transformValues',MetadataService.SOAP_M_URI,null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{MetadataService.SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'apexClass','connector','dataType','isCollection','objectType','scale','transformValues'};
    }

    global class FlowTransformValue {
        global String type='FlowTransformValue';
        global String inputReference;
        global FlowTransformValueAction[] transformValueActions;
        private String[] inputReference_type_info = new String[]{'inputReference',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] transformValueActions_type_info = new String[]{'transformValueActions',MetadataService.SOAP_M_URI,null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{MetadataService.SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'inputReference','transformValueActions'};
    }

    global class FlowTransformValueAction {
        global String type='FlowTransformValueAction';
        global String outputFieldApiName;
        global String transformType;
        global MetadataService.FlowElementReferenceOrValue value;
        private String[] outputFieldApiName_type_info = new String[]{'outputFieldApiName',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] transformType_type_info = new String[]{'transformType',MetadataService.SOAP_M_URI,null,'1','1','false'};
        private String[] value_type_info = new String[]{'value',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{MetadataService.SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'outputFieldApiName','transformType','value'};
    }

    global class FlowInputParameterTranslation {
        global String type='FlowInputParameterTranslation';
        global String name;
        global FlowFerovTranslation value;
        private String[] name_type_info = new String[]{'name',MetadataService.SOAP_M_URI,null,'1','1','false'};
        private String[] value_type_info = new String[]{'value',MetadataService.SOAP_M_URI,null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{MetadataService.SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'name','value'};
    }

    global class FlowFerovTranslation {
        global String type='FlowFerovTranslation';
        global FlowComplexLiteralTranslation[] complexValues;
        global String stringValue;
        private String[] complexValues_type_info = new String[]{'complexValues',MetadataService.SOAP_M_URI,null,'0','-1','false'};
        private String[] stringValue_type_info = new String[]{'stringValue',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{MetadataService.SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'complexValues','stringValue'};
    }

    global class FlowComplexLiteralTranslation {
        global String type='FlowComplexLiteralTranslation';
        global FlowComplexLiteralTranslation[] complexValues;
        global String customAspectKey;
        global String value;
        private String[] customAspectKey_type_info = new String[]{'customAspectKey',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] value_type_info = new String[]{'value',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{MetadataService.SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'customAspectKey','value'};
    }

    global class FlowVisibilityRule {
        global String type='FlowVisibilityRule';
        global String conditionLogic;
        global MetadataService.FlowCondition[] conditions;
        private String[] conditionLogic_type_info = new String[]{'conditionLogic',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] conditions_type_info = new String[]{'conditions',MetadataService.SOAP_M_URI,null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{MetadataService.SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'conditionLogic','conditions'};
    }

    global class FlowTextTemplateTranslation {
        global String type='FlowTextTemplateTranslation';
        global String name;
        global String text;
        private String[] name_type_info = new String[]{'name',MetadataService.SOAP_M_URI,null,'1','1','false'};
        private String[] text_type_info = new String[]{'text',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{MetadataService.SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'name','text'};
    }

    global class FlowTestPoint {
        global String type='FlowTestPoint';
        global FlowTestAssertion[] assertions;
        global String elementApiName;
        global FlowTestParameter[] parameters;
        private String[] assertions_type_info = new String[]{'assertions',MetadataService.SOAP_M_URI,null,'0','-1','false'};
        private String[] elementApiName_type_info = new String[]{'elementApiName',MetadataService.SOAP_M_URI,null,'1','1','false'};
        private String[] parameters_type_info = new String[]{'parameters',MetadataService.SOAP_M_URI,null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{MetadataService.SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'assertions','elementApiName','parameters'};
    }

    global class FlowTestAssertion {
        global String type='FlowTestAssertion';
        global FlowTestCondition[] conditions;
        global String errorMessage;
        private String[] conditions_type_info = new String[]{'conditions',MetadataService.SOAP_M_URI,null,'0','-1','false'};
        private String[] errorMessage_type_info = new String[]{'errorMessage',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{MetadataService.SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'conditions','errorMessage'};
    }

    global class FlowTestParameter {
        global String type='FlowTestParameter';
        global String leftValueReference;
        global String type_x;
        global FlowTestReferenceOrValue value;
        private String[] leftValueReference_type_info = new String[]{'leftValueReference',MetadataService.SOAP_M_URI,null,'1','1','false'};
        private String[] type_x_type_info = new String[]{'type',MetadataService.SOAP_M_URI,null,'1','1','false'};
        private String[] value_type_info = new String[]{'value',MetadataService.SOAP_M_URI,null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{MetadataService.SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'leftValueReference','type_x','value'};
    }

    global class FlowTestCondition {
        global String type='FlowTestCondition';
        global String leftValueReference;
        global String operator;
        global FlowTestReferenceOrValue rightValue;
        private String[] leftValueReference_type_info = new String[]{'leftValueReference',MetadataService.SOAP_M_URI,null,'1','1','false'};
        private String[] operator_type_info = new String[]{'operator',MetadataService.SOAP_M_URI,null,'1','1','false'};
        private String[] rightValue_type_info = new String[]{'rightValue',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{MetadataService.SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'leftValueReference','operator','rightValue'};
    }

    global class FlowTestReferenceOrValue {
        global String type='FlowTestReferenceOrValue';
        global Boolean booleanValue;
        global DateTime dateTimeValue;
        global Date dateValue;
        global Double numberValue;
        global String sobjectValue;
        global String stringValue;
        private String[] booleanValue_type_info = new String[]{'booleanValue',MetadataService.SOAP_M_URI,null,'0','1','true'};
        private String[] dateTimeValue_type_info = new String[]{'dateTimeValue',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] dateValue_type_info = new String[]{'dateValue',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] numberValue_type_info = new String[]{'numberValue',MetadataService.SOAP_M_URI,null,'0','1','true'};
        private String[] sobjectValue_type_info = new String[]{'sobjectValue',MetadataService.SOAP_M_URI,null,'0','1','true'};
        private String[] stringValue_type_info = new String[]{'stringValue',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{MetadataService.SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'booleanValue','dateTimeValue','dateValue','numberValue','sobjectValue','stringValue'};
    }

    global class FlowCoverageResult {
        global String type='FlowCoverageResult';
        global String[] elementsNotCovered;
        global String flowId;
        global String flowName;
        global String flowNamespace;
        global Integer numElements;
        global Integer numElementsNotCovered;
        global String processType;
        private String[] elementsNotCovered_type_info = new String[]{'elementsNotCovered',MetadataService.SOAP_M_URI,null,'0','-1','false'};
        private String[] flowId_type_info = new String[]{'flowId',MetadataService.SOAP_M_URI,null,'1','1','false'};
        private String[] flowName_type_info = new String[]{'flowName',MetadataService.SOAP_M_URI,null,'1','1','false'};
        private String[] flowNamespace_type_info = new String[]{'flowNamespace',MetadataService.SOAP_M_URI,null,'1','1','true'};
        private String[] numElements_type_info = new String[]{'numElements',MetadataService.SOAP_M_URI,null,'1','1','false'};
        private String[] numElementsNotCovered_type_info = new String[]{'numElementsNotCovered',MetadataService.SOAP_M_URI,null,'1','1','false'};
        private String[] processType_type_info = new String[]{'processType',MetadataService.SOAP_M_URI,null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{MetadataService.SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'elementsNotCovered','flowId','flowName','flowNamespace','numElements','numElementsNotCovered','processType'};
    }

    global class FlowStageTranslation {
        global String type='FlowStageTranslation';
        global String label;
        global String name;
        private String[] label_type_info = new String[]{'label',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] name_type_info = new String[]{'name',MetadataService.SOAP_M_URI,null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{MetadataService.SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'label','name'};
    }

    global class FlowSettings {
        global String type='FlowSettings';
        global Boolean canDebugFlowAsAnotherUser;
        global Boolean doesEnforceApexCpuTimeLimit;
        global Boolean doesFormulaEnforceDataAccess;
        global Boolean doesFormulaGenerateHtmlOutput;
        global Boolean enableFlowBREncodedFixEnabled;
        global Boolean enableFlowCustomPropertyEditor;
        global Boolean enableFlowDeployAsActiveEnabled;
        global Boolean enableFlowFieldFilterEnabled;
        global Boolean enableFlowFormulasFixEnabled;
        global Boolean enableFlowInterviewSharingEnabled;
        global Boolean enableFlowNullPreviousValueFix;
        global Boolean enableFlowPauseEnabled;
        global Boolean enableFlowReactiveScreens;
        global Boolean enableFlowUseApexExceptionEmail;
        global Boolean enableFlowViaRestUsesUserCtxt;
        global Boolean enableLightningRuntimeEnabled;
        global Boolean isAccessToInvokedApexRequired;
        global Boolean isApexPluginAccessModifierRespected;
        global Boolean isEnhancedFlowListViewVisible;
        global Boolean isFlowApexContextRetired;
        global Boolean isFlowBlockAccessToSessionIDEnabled;
        global Boolean isManageFlowRequiredForAutomationCharts;
        global Boolean isSupportRollbackOnErrorForApexInvocableActionsEnabled;
        global Boolean isTimeResumedInSameRunContext;
        private String[] canDebugFlowAsAnotherUser_type_info = new String[]{'canDebugFlowAsAnotherUser',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] doesEnforceApexCpuTimeLimit_type_info = new String[]{'doesEnforceApexCpuTimeLimit',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] doesFormulaEnforceDataAccess_type_info = new String[]{'doesFormulaEnforceDataAccess',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] doesFormulaGenerateHtmlOutput_type_info = new String[]{'doesFormulaGenerateHtmlOutput',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] enableFlowBREncodedFixEnabled_type_info = new String[]{'enableFlowBREncodedFixEnabled',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] enableFlowCustomPropertyEditor_type_info = new String[]{'enableFlowCustomPropertyEditor',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] enableFlowDeployAsActiveEnabled_type_info = new String[]{'enableFlowDeployAsActiveEnabled',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] enableFlowFieldFilterEnabled_type_info = new String[]{'enableFlowFieldFilterEnabled',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] enableFlowFormulasFixEnabled_type_info = new String[]{'enableFlowFormulasFixEnabled',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] enableFlowInterviewSharingEnabled_type_info = new String[]{'enableFlowInterviewSharingEnabled',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] enableFlowNullPreviousValueFix_type_info = new String[]{'enableFlowNullPreviousValueFix',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] enableFlowPauseEnabled_type_info = new String[]{'enableFlowPauseEnabled',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] enableFlowReactiveScreens_type_info = new String[]{'enableFlowReactiveScreens',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] enableFlowUseApexExceptionEmail_type_info = new String[]{'enableFlowUseApexExceptionEmail',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] enableFlowViaRestUsesUserCtxt_type_info = new String[]{'enableFlowViaRestUsesUserCtxt',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] enableLightningRuntimeEnabled_type_info = new String[]{'enableLightningRuntimeEnabled',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] isAccessToInvokedApexRequired_type_info = new String[]{'isAccessToInvokedApexRequired',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] isApexPluginAccessModifierRespected_type_info = new String[]{'isApexPluginAccessModifierRespected',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] isEnhancedFlowListViewVisible_type_info = new String[]{'isEnhancedFlowListViewVisible',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] isFlowApexContextRetired_type_info = new String[]{'isFlowApexContextRetired',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] isFlowBlockAccessToSessionIDEnabled_type_info = new String[]{'isFlowBlockAccessToSessionIDEnabled',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] isManageFlowRequiredForAutomationCharts_type_info = new String[]{'isManageFlowRequiredForAutomationCharts',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] isSupportRollbackOnErrorForApexInvocableActionsEnabled_type_info = new String[]{'isSupportRollbackOnErrorForApexInvocableActionsEnabled',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] isTimeResumedInSameRunContext_type_info = new String[]{'isTimeResumedInSameRunContext',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{MetadataService.SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'canDebugFlowAsAnotherUser','doesEnforceApexCpuTimeLimit','doesFormulaEnforceDataAccess','doesFormulaGenerateHtmlOutput','enableFlowBREncodedFixEnabled','enableFlowCustomPropertyEditor','enableFlowDeployAsActiveEnabled','enableFlowFieldFilterEnabled','enableFlowFormulasFixEnabled','enableFlowInterviewSharingEnabled','enableFlowNullPreviousValueFix','enableFlowPauseEnabled','enableFlowReactiveScreens','enableFlowUseApexExceptionEmail','enableFlowViaRestUsesUserCtxt','enableLightningRuntimeEnabled','isAccessToInvokedApexRequired','isApexPluginAccessModifierRespected','isEnhancedFlowListViewVisible','isFlowApexContextRetired','isFlowBlockAccessToSessionIDEnabled','isManageFlowRequiredForAutomationCharts','isSupportRollbackOnErrorForApexInvocableActionsEnabled','isTimeResumedInSameRunContext'};
    }

    global class FlowCoverageWarning {
        global String type='FlowCoverageWarning';
        global String flowId;
        global String flowName;
        global String flowNamespace;
        global String message;
        private String[] flowId_type_info = new String[]{'flowId',MetadataService.SOAP_M_URI,null,'1','1','true'};
        private String[] flowName_type_info = new String[]{'flowName',MetadataService.SOAP_M_URI,null,'1','1','true'};
        private String[] flowNamespace_type_info = new String[]{'flowNamespace',MetadataService.SOAP_M_URI,null,'1','1','true'};
        private String[] message_type_info = new String[]{'message',MetadataService.SOAP_M_URI,null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{MetadataService.SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'flowId','flowName','flowNamespace','message'};
    }

    global class FlowTest {
        global String type='FlowTest';
        global String description;
        global String flowApiName;
        global String label;
        global FlowTestPoint[] testPoints;
        private String[] description_type_info = new String[]{'description',MetadataService.SOAP_M_URI,null,'0','1','false'};
        private String[] flowApiName_type_info = new String[]{'flowApiName',MetadataService.SOAP_M_URI,null,'1','1','false'};
        private String[] label_type_info = new String[]{'label',MetadataService.SOAP_M_URI,null,'1','1','false'};
        private String[] testPoints_type_info = new String[]{'testPoints',MetadataService.SOAP_M_URI,null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{MetadataService.SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'description','flowApiName','label','testPoints'};
    }
}