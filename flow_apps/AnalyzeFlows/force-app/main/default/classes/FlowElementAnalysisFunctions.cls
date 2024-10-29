public with sharing class FlowElementAnalysisFunctions {
    static Set<String> excludedFieldSet = new Set<String> {
        'label',
        'locationY',
        'locationX',
        'type'
    };

    public static ElementStatusChange subAnalysis_ConnectorAndFaultConnector(usf3.MetadataService.FlowConnector initFlowConnector, usf3.MetadataService.FlowConnector secondFlowConnector, String changeType) {
        ElementStatusChange newChange;
        if(initFlowConnector == null && secondFlowConnector!= null) {
            newChange = new ElementStatusChange();
            newChange.changeType = changeType;
            newChange.elementType = secondFlowConnector.type;
            newChange.newValue = secondFlowConnector.targetReference;
            newChange.oldValue = null;
        } else if(initFlowConnector != null && secondFlowConnector == null) {
            newChange = new ElementStatusChange();
            newChange.changeType = changeType;
            newChange.elementType = initFlowConnector.type;
            newChange.newValue = null;
            newChange.oldValue = initFlowConnector.targetReference;
        } else if(initFlowConnector != null && secondFlowConnector!= null && initFlowConnector.targetReference != secondFlowConnector.targetReference) {
            newChange = new ElementStatusChange();
            newChange.changeType = changeType;
            newChange.elementType = initFlowConnector.type;
            newChange.newValue = secondFlowConnector.targetReference;
            newChange.oldValue = initFlowConnector.targetReference;

        }

        return newChange;
    }

    public static ElementStatusChange SubAnalysis_FilterConditions( String initFlowFilterLogic, 
                                                                    String secondFlowFilterLogic, 
                                                                    List<usf3.MetadataService.FlowRecordFilter> initFlowRecordFilterList,
                                                                    List<usf3.MetadataService.FlowRecordFilter> secondFlowRecordFilterList) {
        ElementStatusChange newChange;
       
        if(initFlowFilterLogic != secondFlowFilterLogic) {
            newChange = new ElementStatusChange();
            newChange.changeType = 'Filter Conditions have been modified';
            newChange.elementType = 'String';
            newChange.newValue = secondFlowFilterLogic;
            newChange.oldValue = initFlowFilterLogic;
        }
        if(initFlowRecordFilterList != null && secondFlowRecordFilterList != null) {
            if(initFlowRecordFilterList.size() != secondFlowRecordFilterList.size()) {
                newChange = new ElementStatusChange();
                newChange.changeType = 'Filter Conditions have been modified';
                newChange.elementType = 'String';
                newChange.newValue = 'Compare the two versions to see the difference';
                newChange.oldValue = 'Compare the two versions to see the difference';
            }

            for(usf3.MetadataService.FlowRecordFilter initFlowRecordFilter : initFlowRecordFilterList) {
                boolean isChanged = true;
                for(usf3.MetadataService.FlowRecordFilter secondFlowRecordFilter : secondFlowRecordFilterList) {
                    if(initFlowRecordFilter.field == secondFlowRecordFilter.field && initFlowRecordFilter.operator == secondFlowRecordFilter.operator) {
                        isChanged = false;
                    }
                }

                if(isChanged) {
                    newChange = new ElementStatusChange();
                    newChange.changeType = 'Filter Conditions have been modified';
                    newChange.elementType = initFlowRecordFilter.type;
                    newChange.newValue = 'Compare the two versions to see the difference';
                    newChange.oldValue = 'Compare the two versions to see the difference';
                }
            }
        }


        return newChange;
    }

    public static ElementStatusChange SubAnalysis_ObjectSettings(String initFlowObject, String secondFlowObject) {
        ElementStatusChange newChange;
        if(initFlowObject != secondFlowObject) {
            newChange = new ElementStatusChange();
            newChange.changeType = 'The input variable for this element has been modified';
            newChange.elementType = 'Object';
            newChange.newValue = secondFlowObject;
            newChange.oldValue = initFlowObject;
        }

        return newChange;

    }

    public static ElementStatusChange SubAnalysis_InputReference(String initFlowInputReference, String secondFlowInputReference) {
        ElementStatusChange newChange;
        if(initFlowInputReference != secondFlowInputReference) {
            newChange = new ElementStatusChange();
            newChange.changeType = 'The input variable for this element has been modified';
            newChange.elementType = 'String';
            newChange.newValue = secondFlowInputReference;
            newChange.oldValue = initFlowInputReference;
        }

        return newChange;

    }

    public static ElementStatusChange SubAnalysis_ManualInputAssignments(List<usf3.MetadataService.FlowInputFieldAssignment> initFlowInputFieldAssignmentList,List<usf3.MetadataService.FlowInputFieldAssignment> secondFlowInputFieldAssignmentList) {
        ElementStatusChange newChange;
        if((initFlowInputFieldAssignmentList == null && secondFlowInputFieldAssignmentList!= null) || (initFlowInputFieldAssignmentList != null && secondFlowInputFieldAssignmentList == null)) {
            newChange = new ElementStatusChange();
            newChange.changeType = 'The input variable for this element has been modified';
            newChange.elementType = 'FlowInputFieldAssignment';
            newChange.newValue = 'N/A';
            newChange.oldValue = 'N/A';
        } else if(initFlowInputFieldAssignmentList != null && secondFlowInputFieldAssignmentList!= null) {
            for(usf3.MetadataService.FlowInputFieldAssignment initFlowInputFieldAssignment : initFlowInputFieldAssignmentList) {
                Boolean isChanged = true;
                for(usf3.MetadataService.FlowInputFieldAssignment secondFlowInputFieldAssignment : secondFlowInputFieldAssignmentList) {
                    if(
                        initFlowInputFieldAssignment.field == secondFlowInputFieldAssignment.field && 
                        JSON.serialize(initFlowInputFieldAssignment.value) == JSON.serialize(secondFlowInputFieldAssignment.value)
                    ) {
                        isChanged = false;
                        break;
                    }
                }
                if(isChanged) {
                    newChange = new ElementStatusChange();
                    newChange.changeType = 'The input variable for this element has been modified';
                    newChange.elementType = initFlowInputFieldAssignment.type;
                    newChange.newValue = 'N/A';
                    newChange.oldValue = 'N/A';
                }
            }

        }


        return newChange;

    }

    public static FlowAnalysis detectNewOrRemovedFlowEntities(usf3.MetadataService.Flow initFlow, usf3.MetadataService.Flow secondFlow, String changeType) {

        FlowAnalysis result = changeType == 'New' ? FlowElementAnalysisFunctions.initFlowAnalysisObject(initFlow, secondFlow) : FlowElementAnalysisFunctions.initFlowAnalysisObject(secondFlow, initFlow);
        
        Map<String, Object> initFlowMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(initFlow));
        Map<String, Object> secondFlowMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(secondFlow));
        List<ElementStatusChange> changeList = new List<ElementStatusChange>();
        for(String initFlowKey : secondFlowMap.keySet()) {
            if(!initFlowKey.endsWith('_info')) {
                Object secondFlowItem = secondFlowMap.get(initFlowKey);
                Object initFlowItem = initFlowMap.get(initFlowKey);
                if(initFlowItem == null) {
                    if(secondFlowItem instanceof List<Object>) {
                        for(Object obj : (List<Object>)secondFlowItem ) {
                            Map<String, Object> initFlowNode = (Map<String, Object>) obj;
                            ElementStatusChange newChange = new ElementStatusChange();
                            newChange.name = (String)initFlowNode.get('name');
                            newChange.label = (String)initFlowNode.get('label');
                            newChange.changeType = changeType;
                            newChange.description = (String)initFlowNode.get('description');
                            newChange.elementType = (String)initFlowNode.get('type');
                            changeList.add(newChange);
                        }
                    }
                } else if(secondFlowItem != null){
                    if(initFlowItem instanceof List<Object>) {
                        for(Object obj : (List<Object>)secondFlowItem ) {
                            if(obj instanceof Map<String, Object>) {
                                Boolean nodeIsNew = true;
                                Map<String, Object> initFlowNode = (Map<String, Object>) obj;
                                for(Object obj1 : (List<Object>)initFlowItem ) {
                                    Map<String, Object> secondFlowNode = (Map<String, Object>) obj1;
                                    if(initFlowNode.get('name') == secondFlowNode.get('name')) {
                                        nodeIsNew = false;
                                        break;
                                    }
                                }
                                if(nodeIsNew) {
                                    ElementStatusChange newChange = new ElementStatusChange();
                                    newChange.name = (String)initFlowNode.get('name');
                                    newChange.label = (String)initFlowNode.get('label');
                                    newChange.changeType = changeType;
                                    newChange.description = (String)initFlowNode.get('description');
                                    newChange.elementType = (String)initFlowNode.get('type');
                                    changeList.add(newChange);
                                }
                            }

                           
                        }
                    } else if(!isPrimitiveObject(secondFlowItem)){
                        System.debug('isObject ' + initFlowKey);
                        System.debug(secondFlowItem);
                    }
                }
            }
        }

        result.elementChanges = changeList;
        return result;

    }

    public static FlowAnalysis initFlowAnalysisObject(usf3.MetadataService.Flow initFlow, usf3.MetadataService.Flow secondFlow) {
        List<String> initFlowNameList = initFlow.fullName.split('-');
        List<String> secondFlowNameList = secondFlow.fullName.split('-');
        FlowAnalysis result = new FlowAnalysis();
        result.baseFlowName = initFlowNameList[0];
        result.baseFlowVersion = Integer.valueOf(initFlowNameList.size() > 1 ? initFlowNameList[1]: '1');
        result.baseFlowStatus = initFlow.status;
        result.comparisonFlowName = secondFlowNameList[0];
        result.comparisonFlowVersion =Integer.valueOf(initFlowNameList.size() > 1 ? secondFlowNameList[1]: '1');
        result.comparisonFlowStatus = secondFlow.status;
        result.analysisTime = DateTime.now();
        return result;
    }

    public static List<ElementStatusChange> SubAnalysis_InputParameters(List<Object> initFlowInputList,List<Object> secondFlowInputList, String elementType) {
        ElementStatusChange newChange;
        List<ElementStatusChange> newChangeList = new List<ElementStatusChange>();
        initFlowInputList = initFlowInputList == null ? new List<Object>() : initFlowInputList;
        secondFlowInputList = secondFlowInputList == null ? new List<Object>() : secondFlowInputList;
    
        //detect new or changed
        for(Object initFlowInput : initFlowInputList) {
            Map<String, Object> tempInitFlowInput = (Map<String, Object>)initFlowInput;
            Boolean isNew = true;
            for(Object  secondFlowInput: secondFlowInputList) {
                Map<String, Object> tempSecondFlowInput = (Map<String, Object>)secondFlowInput;
                if(tempInitFlowInput.get('name') == tempSecondFlowInput.get('name')) {
                        String initFlowInputValue = getFlowInputValue((usf3.MetadataService.FlowElementReferenceOrValue)JSON.deserialize(JSON.serialize(tempInitFlowInput.get('value')), usf3.MetadataService.FlowElementReferenceOrValue.class));
                        String secondFlowInputValue = getFlowInputValue((usf3.MetadataService.FlowElementReferenceOrValue)JSON.deserialize(JSON.serialize(tempSecondFlowInput.get('value')), usf3.MetadataService.FlowElementReferenceOrValue.class));

                        if(initFlowInputValue != secondFlowInputValue) {
                            newChange = new ElementStatusChange();
                            newChange.changeType = 'An Input parameter value changed';
                            newChange.elementType = elementType;
                            newChange.newValue = initFlowInputValue;
                            newChange.oldValue = secondFlowInputValue;
                            newChangeList.add(newChange);
                        }
                        isNew = false;
                }
            }
            if(isNew) {
                newChange = new ElementStatusChange();
                newChange.changeType = 'An Input parameter value was turned on';
                newChange.elementType = elementType;
                newChange.newValue = getFlowInputValue((usf3.MetadataService.FlowElementReferenceOrValue)JSON.deserialize(JSON.serialize(tempInitFlowInput.get('value')), usf3.MetadataService.FlowElementReferenceOrValue.class));
                newChange.oldValue = 'not present';
                newChangeList.add(newChange);
            }
        }
        //detect old
        for(Object initFlowInput :  secondFlowInputList) {
            Map<String, Object> tempInitFlowInput = (Map<String, Object>)initFlowInput;
            Boolean isOld = true;
            for(Object secondFlowInput : initFlowInputList) {
                Map<String, Object> tempSecondFlowInput = (Map<String, Object>)secondFlowInput;
                if(tempInitFlowInput.get('name') == tempSecondFlowInput.get('name')) {
                    isOld = false;
                }
            }
            if(isOld) {
                newChange = new ElementStatusChange();
                newChange.changeType = 'Input parameter value was turned off';
                newChange.newValue = 'not present';
                newChange.elementType = elementType;
                newChange.oldValue = getFlowInputValue((usf3.MetadataService.FlowElementReferenceOrValue)JSON.deserialize(JSON.serialize(tempInitFlowInput.get('value')), usf3.MetadataService.FlowElementReferenceOrValue.class));
                newChangeList.add(newChange);
            }
        }
    
        return newChangeList;
    }

    public static List<ElementStatusChange> subAnalysis_OutputMappings(Map<String, Object> initFlowElementMap, Map<String, Object> secondFlowElementMap) {
        List<ElementStatusChange> newChangeList = new List<ElementStatusChange>();
        ElementStatusChange newChange;
        if( initFlowElementMap.get('storeOutputAutomatically') != secondFlowElementMap.get('storeOutputAutomatically')
        ) {
            newChange = new ElementStatusChange();
            newChange.changeType = 'StoreOutputAutomatically changed. This implies a change between automatic output mapping and manual mapping.';
            newChange.elementType = String.valueOf(initFlowElementMap.get('type'));
            newChange.newValue = String.valueOf(initFlowElementMap.get('storeOutputAutomatically'));
            newChange.oldValue = String.valueOf(secondFlowElementMap.get('storeOutputAutomatically'));
            newChangeList.add(newChange);
        }

        if(newChangeList.isEmpty()) {
            if(initFlowElementMap.get('outputAssignments') != null || secondFlowElementMap.get('outputAssignments') != null) {
                newChangeList.addAll(SubAnalysis_OutputsParameters(
                    (List<Object>)initFlowElementMap.get('outputAssignments') ,
                    (List<Object>)secondFlowElementMap.get('outputAssignments'), 
                    String.valueOf(initFlowElementMap.get('type'))
                ));
            } else if(initFlowElementMap.get('outputParameters') != null || secondFlowElementMap.get('outputParameters') != null) {
                newChangeList.addAll(SubAnalysis_OutputsParameters(
                    (List<Object>)initFlowElementMap.get('outputParameters') ,
                    (List<Object>)secondFlowElementMap.get('outputParameters'), 
                    String.valueOf(initFlowElementMap.get('type'))
                ));
            }
        }

        return newChangeList;

    }

    public static List<ElementStatusChange> SubAnalysis_OutputsParameters(List<Object> initFlowOutputList,List<Object> secondFlowOutputList, String elementType) {
        ElementStatusChange newChange;
        List<ElementStatusChange> newChangeList = new List<ElementStatusChange>();
        initFlowOutputList = initFlowOutputList == null ? new List<Object>() : initFlowOutputList;
        secondFlowOutputList = secondFlowOutputList == null ? new List<Object>() : secondFlowOutputList;
    
        //detect new or changed
        for(Object initFlowOutput : initFlowOutputList) {
            Map<String, Object> tempInitFlowOutput = (Map<String, Object>)initFlowOutput;
            Boolean isNew = true;
            for(Object  secondFlowOutput: secondFlowOutputList) {
                Map<String, Object> tempSecondFlowOutput = (Map<String, Object>)secondFlowOutput;
                if( equalsOutputNames(tempInitFlowOutput, tempSecondFlowOutput)) {    
                        if(tempInitFlowOutput.get('assignToReference') != tempSecondFlowOutput.get('assignToReference') ) {
                            newChange = new ElementStatusChange();
                            newChange.changeType = 'An Output parameter value changed';
                            newChange.elementType = elementType;
                            newChange.newValue = String.valueOf(tempInitFlowOutput.get('assignToReference'));
                            newChange.oldValue = String.valueOf(tempSecondFlowOutput.get('assignToReference'));
                            newChangeList.add(newChange);
                        }
                        isNew = false;
                }
            }
            if(isNew) {
                newChange = new ElementStatusChange();
                newChange.changeType = 'An Output parameter value was turned on';
                newChange.elementType = elementType;
                newChange.newValue =  String.valueOf(tempInitFlowOutput.get('assignToReference'));
                newChange.oldValue = 'not present';
                newChangeList.add(newChange);
            }
        }
        //detect old
        for(Object initFlowOutput :  secondFlowOutputList) {
            Map<String, Object> tempInitFlowOutput = (Map<String, Object>)initFlowOutput;
            Boolean isOld = true;
            for(Object secondFlowOutput : initFlowOutputList) {
                Map<String, Object> tempSecondFlowOutput = (Map<String, Object>)secondFlowOutput;
                if(equalsOutputNames(tempInitFlowOutput, tempSecondFlowOutput)) {
                    isOld = false;
                }
            }
            if(isOld) {
                newChange = new ElementStatusChange();
                newChange.changeType = 'AN Output parameter value was turned off';
                newChange.newValue = 'not present';
                newChange.elementType = elementType;
                newChange.oldValue = String.valueOf(tempInitFlowOutput.get('assignToReference'));
                newChangeList.add(newChange);
            }
        }
    
        return newChangeList;
    }

    public static List<ElementStatusChange> compareFlowArrayStructure(List<Object> firstVersionArray,List<Object> secondVersionArray) {
        ElementStatusChange newChange;
        List<ElementStatusChange> newChangeList = new List<ElementStatusChange>();
        firstVersionArray = firstVersionArray == null ? new List<Object>() : firstVersionArray;
        secondVersionArray = secondVersionArray == null ? new List<Object>() : secondVersionArray;
    
        for(Object firstVersionItem : firstVersionArray) {
            System.debug(firstVersionItem);
            Map<String, Object> tempFirstVersionItem = (Map<String, Object>) firstVersionItem;
            Map<String, Object> tempSecondVersionItem = getFlowItemByName(secondVersionArray, getElementName(tempFirstVersionItem));
            if(tempSecondVersionItem == null) {
                newChange = new ElementStatusChange();
                newChange.name = String.valueOf(tempFirstVersionItem.get('name'));
                newChange.label = String.valueOf(tempFirstVersionItem.get('label'));
                newChange.changeType = String.valueOf(tempFirstVersionItem.get('type'))  + ' exists in the first version that is not present in identical form in the second version';
                newChange.elementType =  String.valueOf(tempFirstVersionItem.get('type'));
                newChange.oldValue = formatValueFromFlowItem(tempFirstVersionItem);
                newChangeList.add(newChange);
            } else {
                for(String fieldName : tempFirstVersionItem.keySet()) {
                    if(tempFirstVersionItem.get(fieldName) instanceof List<Object> && !fieldName.endsWith('_info')) {
                        List<ElementStatusChange> tempChangeList = compareFlowArrayStructure((List<Object>)tempFirstVersionItem.get(fieldName), (List<Object>)tempSecondVersionItem.get(fieldName));
                        if(tempChangeList.size() > 0) {
                            newChange = new ElementStatusChange();
                            newChange.name = String.valueOf(tempFirstVersionItem.get('name'));
                            newChange.label = String.valueOf(tempFirstVersionItem.get('label'));
                            newChange.changeType = String.valueOf(tempFirstVersionItem.get('type'))  + ' exists in the first version that is not present in identical form in the second version';
                            newChange.elementType =  String.valueOf(tempFirstVersionItem.get('type'));
                            newChange.oldValue = tempFirstVersionItem.get('type') + ':\n' + tempChangeList[0].elementType + ' = difference detected';
                            newChangeList.add(newChange);
                        }
                        for(ElementStatusChange changeItem : tempChangeList) {
                            changeItem.name = String.valueOf(tempFirstVersionItem.get('name'));
                            changeItem.label = String.valueOf(tempFirstVersionItem.get('label'));
                        }
                        newChangeList.addAll(tempChangeList);
                    } else if(!fieldName.endsWith('_info') && !compareField(tempFirstVersionItem.get(fieldName), tempSecondVersionItem.get(fieldName))){
                        newChange = new ElementStatusChange();
                        newChange.name = String.valueOf(tempFirstVersionItem.get('name'));
                        newChange.label = String.valueOf(tempFirstVersionItem.get('label'));
                        newChange.changeType = String.valueOf(tempFirstVersionItem.get('type'))  + ' exists in the first version that is not present in identical form in the second version';
                        newChange.elementType =  String.valueOf(tempFirstVersionItem.get('type'));
                        newChange.oldValue = formatValueFromFlowItem(tempFirstVersionItem, fieldName);
                        newChange.newValue = formatValueFromFlowItem(tempSecondVersionItem, fieldName);
                        newChangeList.add(newChange);
                    }
                }
            }
        }

        for(Object secondVersionItem : secondVersionArray) {
            Map<String, Object> tempSecondVersionItem = (Map<String, Object>) secondVersionItem;
            Map<String, Object> tempFirstVersionItem = getFlowItemByName(firstVersionArray, getElementName(tempSecondVersionItem));
            if(tempFirstVersionItem == null) {
                newChange = new ElementStatusChange();
                newChange.name = String.valueOf(tempSecondVersionItem.get('name'));
                newChange.label = String.valueOf(tempSecondVersionItem.get('label'));
                newChange.changeType = String.valueOf(tempSecondVersionItem.get('type')) + ' exists in the second version that is not present in identical form in the first version';
                newChange.elementType =  String.valueOf(tempSecondVersionItem.get('type'));
                newChange.oldValue = formatValueFromFlowItem(tempSecondVersionItem);
                newChangeList.add(newChange);
            }
        }
        
        return newChangeList;
    }

    

    static String getFlowInputValue(usf3.MetadataService.FlowElementReferenceOrValue value) {
        String resultValue = '';
        if(value.booleanValue != null) {
            resultValue = String.valueOf(value.booleanValue);
        } else if(value.dateTimeValue != null) {
            resultValue = String.valueOf(value.dateTimeValue);
        } else if(value.dateValue != null) {
            resultValue = String.valueOf(value.dateValue);
        } else if(value.elementReference != null) {
            resultValue = String.valueOf(value.elementReference);
        } else if(value.numberValue != null) {
            resultValue = String.valueOf(value.numberValue);
        } else if(value.stringValue != null) {
            resultValue = String.valueOf(value.stringValue);
        }
        return resultValue;

    }

    static Boolean equalsOutputNames(Map<String, Object> initFlowOutput, Map<String, Object> secondFlowOutput) {
        if(initFlowOutput.get('name') != null || secondFlowOutput.get('name') != null) {
            return initFlowOutput.get('name') == secondFlowOutput.get('name');
        } else {
            return  initFlowOutput.get('field') == secondFlowOutput.get('field');
        }
    }

    static Map<String, Object> getFlowItemByName(List<Object> flowItemList, String itemName ) {
        for(Object flowItem : flowItemList) {
            Map<String, Object> tempFlowItem = (Map<String, Object>) flowItem;
             if(getElementName(tempFlowItem) == itemName) {
                return tempFlowItem;
             }
        }

        return null;
    }

    static Boolean isPrimitiveObject(Object obj) {
        return obj instanceof String || obj instanceof Boolean || obj instanceof Integer || obj instanceof Double;
    }

    static String getElementName(Map<String, Object> flowElement) {
        if(flowElement.get('name') != null) {
            return (String) flowElement.get('name');
        } else  if(flowElement.get('field') != null) {
            return (String) flowElement.get('field');
        } else  if(flowElement.get('assignToReference') != null) {
            return (String) flowElement.get('assignToReference');
        }else  if(flowElement.get('leftValueReference') != null) {
            return (String) flowElement.get('leftValueReference');
        }
        
        return null;
    }

    static String formatValueFromFlowItem(Map<String, Object> flowItem) {
        String resultValue = flowItem.get('type') + ': \n';
            for(String fieldName : flowItem.keySet()) {
                if(!excludedFieldSet.contains(fieldName)) {
                Object field = flowItem.get(fieldName);
                resultValue += getFormatValues(field, fieldName);
            }
        }

        return resultValue;
    }

    static String formatValueFromFlowItem(Map<String, Object> flowItem, String fieldName) {
        String resultValue = flowItem.get('type') + ': \n';
        Object field = flowItem.get(fieldName);
        resultValue += getFormatValues(field, fieldName);
        return resultValue;
    }

    static String getFormatValues(Object field, String fieldName) {
        String resultValue = '';
        if(isPrimitiveObject(field)) {
            resultValue += fieldName + ' = ' + field + '\n';
        } else if(field != null && (fieldName == 'value' || fieldName == 'rightValue')) {
            usf3.MetadataService.FlowElementReferenceOrValue valueField = ( usf3.MetadataService.FlowElementReferenceOrValue)JSON.deserialize(JSON.serialize(field),  usf3.MetadataService.FlowElementReferenceOrValue.class);
            resultValue += fieldName + ' = ' + getFlowInputValue(valueField) + '\n';
        } else if(field != null && (fieldName == 'connector' ||fieldName == 'faultConnector' || fieldName == 'defaultConnector')) {
            usf3.MetadataService.FlowConnector valueField = ( usf3.MetadataService.FlowConnector)JSON.deserialize(JSON.serialize(field),  usf3.MetadataService.FlowConnector.class);
            System.debug('FlowConnector' + valueField);
            resultValue += fieldName + ' = ' + valueField.targetReference + '\n';
        }

        return resultValue;
    }

    static Boolean compareField(Object firstItem, Object secondItem) {
        if(isPrimitiveObject( firstItem)) {
            return firstItem == secondItem;
        } else  {
            return JSON.serialize(firstItem) == JSON.serialize(secondItem);
        } 
    }
}