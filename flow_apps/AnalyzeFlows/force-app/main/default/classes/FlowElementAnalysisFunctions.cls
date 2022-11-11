public with sharing class FlowElementAnalysisFunctions {
    public static ElementStatusChange subAnalysis_ConnectorAndFaultConnector(MetadataService.FlowConnector initFlowConnector, MetadataService.FlowConnector secondFlowConnector, String changeType) {
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
                                                                    List<MetadataService.FlowRecordFilter> initFlowRecordFilterList,
                                                                    List<MetadataService.FlowRecordFilter> secondFlowRecordFilterList) {
        ElementStatusChange newChange;
       
        if(initFlowFilterLogic != secondFlowFilterLogic) {
            newChange = new ElementStatusChange();
            newChange.changeType = 'Filter Conditions have been modified';
            newChange.elementType = 'String';
            newChange.newValue = secondFlowFilterLogic;
            newChange.oldValue = initFlowFilterLogic;
        }
        if(initFlowRecordFilterList.size() != secondFlowRecordFilterList.size()) {
            newChange = new ElementStatusChange();
            newChange.changeType = 'Filter Conditions have been modified';
            newChange.elementType = 'String';
            newChange.newValue = 'Compare the two versions to see the difference';
            newChange.oldValue = 'Compare the two versions to see the difference';
        }

        for(MetadataService.FlowRecordFilter initFlowRecordFilter : initFlowRecordFilterList) {
            boolean isChanged = true;
            for(MetadataService.FlowRecordFilter secondFlowRecordFilter : secondFlowRecordFilterList) {
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

    public static ElementStatusChange SubAnalysis_InputAndOutputParams(List<MetadataService.FlowInputFieldAssignment> initFlowInputFieldAssignmentList,List<MetadataService.FlowInputFieldAssignment> secondFlowInputFieldAssignmentList) {
        ElementStatusChange newChange;
        if((initFlowInputFieldAssignmentList == null && secondFlowInputFieldAssignmentList!= null) || (initFlowInputFieldAssignmentList != null && secondFlowInputFieldAssignmentList == null)) {
            newChange = new ElementStatusChange();
            newChange.changeType = 'The input variable for this element has been modified';
            newChange.elementType = 'FlowInputFieldAssignment';
            newChange.newValue = 'Not Available';
            newChange.oldValue = 'Not Available';
        } else if(initFlowInputFieldAssignmentList == null && secondFlowInputFieldAssignmentList!= null) {
            for(MetadataService.FlowInputFieldAssignment initFlowInputFieldAssignment : initFlowInputFieldAssignmentList) {
                Boolean isChanged = true;
                for(MetadataService.FlowInputFieldAssignment secondFlowInputFieldAssignment : secondFlowInputFieldAssignmentList) {
                    if(initFlowInputFieldAssignment.field == secondFlowInputFieldAssignment.field && initFlowInputFieldAssignment.value == secondFlowInputFieldAssignment.value) {
                        isChanged = false;
                        break;
                    }
                }
                if(isChanged) {
                    newChange = new ElementStatusChange();
                    newChange.changeType = 'The input variable for this element has been modified';
                    newChange.elementType = initFlowInputFieldAssignment.type;
                    newChange.newValue = 'Not Available';
                    newChange.oldValue = 'Not Available';
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
            || initFlowElementMap.get('outputAssignments') != secondFlowElementMap.get('outputAssignments')
            || initFlowElementMap.get('queriedFields') != secondFlowElementMap.get('queriedFields')
        ) {
            newChange = new ElementStatusChange();
            newChange.changeType = 'Output Handling Has Been Modified';
            newChange.elementType = 'String';
            newChange.newValue = ' Not Available';
            newChange.oldValue = ' Not Available';
        }

        return newChange;

    }
}
