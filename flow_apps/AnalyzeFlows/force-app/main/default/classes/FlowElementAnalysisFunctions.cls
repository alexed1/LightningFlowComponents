public with sharing class FlowElementAnalysisFunctions {
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
        } else if(initFlowInputFieldAssignmentList == null && secondFlowInputFieldAssignmentList!= null) {
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

    static Boolean isPrimitiveObject(Object obj) {
        return obj instanceof String || obj instanceof Boolean || obj instanceof Integer || obj instanceof Double;
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
}
