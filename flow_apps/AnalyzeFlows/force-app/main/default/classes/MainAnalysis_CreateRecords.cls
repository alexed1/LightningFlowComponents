public with sharing class MainAnalysis_CreateRecords {
    public static FlowAnalysis analyzeCreateRecords(usf3.MetadataService.Flow initFlow, usf3.MetadataService.Flow secondFlow) {
        FlowAnalysis result = FlowElementAnalysisFunctions.initFlowAnalysisObject(initFlow, secondFlow);
        List<ElementStatusChange> changeList = new List<ElementStatusChange>();
        if(initFlow.recordCreates != null && secondFlow.recordCreates != null) {
            for(usf3.MetadataService.FlowRecordCreate initRecordCreate : initFlow.recordCreates) {
                for(usf3.MetadataService.FlowRecordCreate secondRecordCreate : secondFlow.recordCreates) {
                    if(initRecordCreate.name == secondRecordCreate.name) {

                        if(initRecordCreate.assignRecordIdToReference != secondRecordCreate.assignRecordIdToReference) {
                            ElementStatusChange newChange = new ElementStatusChange();
                            newChange.name = initRecordCreate.name;
                            newChange.label = initRecordCreate.label;
                            newChange.changeType = 'Sorting configuration has been modified';
                            newChange.description = initRecordCreate.description;
                            newChange.elementType = initRecordCreate.type;
                            newChange.newValue = initRecordCreate.assignRecordIdToReference;
                            newChange.oldValue = secondRecordCreate.assignRecordIdToReference;
                            changeList.add(newChange);
                        }

                        ElementStatusChange newChange = FlowElementAnalysisFunctions.subAnalysis_ConnectorAndFaultConnector(initRecordCreate.connector, secondRecordCreate.connector, 'Outbound Primary Connector Path Points To A Different Element');
                        if(newChange != null) {
                            newChange.name = initRecordCreate.name;
                            newChange.label = initRecordCreate.label;
                            newChange.elementType = initRecordCreate.type;
                            changeList.add(newChange);
                        }

                        newChange = FlowElementAnalysisFunctions.subAnalysis_ConnectorAndFaultConnector(initRecordCreate.faultConnector, secondRecordCreate.faultConnector, 'Outbound Fault Connector Path Points To A Different Element');
                        if(newChange != null) {
                            newChange.name = initRecordCreate.name;
                            newChange.label = initRecordCreate.label;
                            newChange.elementType = initRecordCreate.type;
                            changeList.add(newChange);
                        }

                        newChange = FlowElementAnalysisFunctions.SubAnalysis_InputVariable(initRecordCreate.inputReference, secondRecordCreate.inputReference);
                        if(newChange != null) {
                            newChange.name = initRecordCreate.name;
                            newChange.label = initRecordCreate.label;
                            newChange.elementType = initRecordCreate.type;
                            changeList.add(newChange);
                        }

                        newChange = FlowElementAnalysisFunctions.SubAnalysis_ObjectSettings (initRecordCreate.object_x, secondRecordCreate.object_x);
                        if(newChange != null) {
                            newChange.name = initRecordCreate.name;
                            newChange.label = initRecordCreate.label;
                            newChange.elementType = initRecordCreate.type;
                            changeList.add(newChange);
                        }

                        newChange = FlowElementAnalysisFunctions.SubAnalysis_OutputHandling((Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(initRecordCreate)),(Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(secondRecordCreate)));
                        if(newChange != null) {
                            newChange.name = initRecordCreate.name;
                            newChange.label = initRecordCreate.label;
                            newChange.elementType = initRecordCreate.type;
                            changeList.add(newChange);
                        }

                        newChange = FlowElementAnalysisFunctions.SubAnalysis_InputAndOutputParams(initRecordCreate.inputAssignments, secondRecordCreate.inputAssignments);
                        if(newChange != null) {
                            newChange.name = initRecordCreate.name;
                            newChange.label = initRecordCreate.label;
                            newChange.elementType = initRecordCreate.type;
                            changeList.add(newChange);
                        }
                    }
                }
            }
        }

        result.elementChanges = changeList;
        return result;
    }
}
