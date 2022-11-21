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
            newChange.elementType = 'String';
            newChange.newValue = secondFlowObject;
            newChange.oldValue = initFlowObject;
        }

        return newChange;

    }

    public static ElementStatusChange SubAnalysis_InputVariable(String initFlowInputReference, String secondFlowInputReference) {
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

    public static ElementStatusChange SubAnalysis_InputAndOutputParams(List<usf3.MetadataService.FlowInputFieldAssignment> initFlowInputFieldAssignmentList,List<usf3.MetadataService.FlowInputFieldAssignment> secondFlowInputFieldAssignmentList) {
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

    public static ElementStatusChange SubAnalysis_OutputHandling(Map<String, Object> initFlowElementMap, Map<String, Object> secondFlowElementMap) {
        ElementStatusChange newChange;
        if(initFlowElementMap.get('getFirstRecordOnly') != secondFlowElementMap.get('getFirstRecordOnly') 
            || initFlowElementMap.get('outputReference') != secondFlowElementMap.get('outputReference')
            || initFlowElementMap.get('storeOutputAutomatically') != secondFlowElementMap.get('storeOutputAutomatically')
            || JSON.serialize(initFlowElementMap.get('outputAssignments')) != JSON.serialize(secondFlowElementMap.get('outputAssignments'))
            || JSON.serialize(initFlowElementMap.get('queriedFields')) != JSON.serialize(secondFlowElementMap.get('queriedFields'))
        ) {
            newChange = new ElementStatusChange();
            newChange.changeType = 'Output Handling Has Been Modified';
            newChange.elementType = 'String';
            newChange.newValue = ' N/A';
            newChange.oldValue = ' N/A';
        }

        return newChange;

    }
}
