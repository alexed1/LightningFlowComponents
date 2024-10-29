public with sharing class MainAnalysis_UpdateRecords {
    public static FlowAnalysis analyzeUpdateRecords(usf3.MetadataService.Flow initFlow, usf3.MetadataService.Flow secondFlow) {
        FlowAnalysis result = FlowElementAnalysisFunctions.initFlowAnalysisObject(initFlow, secondFlow);
        List<ElementStatusChange> changeList = new List<ElementStatusChange>();
        if(initFlow.recordUpdates != null && secondFlow.recordUpdates != null) {
            for(usf3.MetadataService.FlowRecordUpdate initRecordUpdate : initFlow.recordUpdates) {
                for(usf3.MetadataService.FlowRecordUpdate secondRecordupdate : secondFlow.recordUpdates) {
                    if(initRecordUpdate.name == secondRecordupdate.name) {
                        ElementStatusChange newChange = FlowElementAnalysisFunctions.subAnalysis_ConnectorAndFaultConnector(initRecordUpdate.connector, secondRecordupdate.connector, 'Outbound Primary Connector Path Points To A Different Element');
                        if(newChange != null) {
                            newChange.name = initRecordUpdate.name;
                            newChange.label = initRecordUpdate.label;
                            newChange.elementType = initRecordUpdate.type;
                            changeList.add(newChange);
                        }

                        newChange = FlowElementAnalysisFunctions.subAnalysis_ConnectorAndFaultConnector(initRecordUpdate.faultConnector, secondRecordupdate.faultConnector, 'Outbound Fault Connector Path Points To A Different Element');
                        if(newChange != null) {
                            newChange.name = initRecordUpdate.name;
                            newChange.label = initRecordUpdate.label;
                            newChange.elementType = initRecordUpdate.type;
                            changeList.add(newChange);
                        }

                        newChange = FlowElementAnalysisFunctions.SubAnalysis_InputReference(initRecordUpdate.inputReference, secondRecordupdate.inputReference);
                        if(newChange != null) {
                            newChange.name = initRecordUpdate.name;
                            newChange.label = initRecordUpdate.label;
                            newChange.elementType = initRecordUpdate.type;
                            changeList.add(newChange);
                        }

                        newChange = FlowElementAnalysisFunctions.SubAnalysis_ObjectSettings (initRecordUpdate.object_x, secondRecordupdate.object_x);
                        if(newChange != null) {
                            newChange.name = initRecordUpdate.name;
                            newChange.label = initRecordUpdate.label;
                            newChange.elementType = initRecordUpdate.type;
                            changeList.add(newChange);
                        }

                        newChange = FlowElementAnalysisFunctions.SubAnalysis_ManualInputAssignments(initRecordUpdate.inputAssignments, secondRecordupdate.inputAssignments);
                        if(newChange != null) {
                            newChange.name = initRecordUpdate.name;
                            newChange.label = initRecordUpdate.label;
                            newChange.elementType = initRecordUpdate.type;
                            changeList.add(newChange);
                        }

                        newChange = FlowElementAnalysisFunctions.SubAnalysis_FilterConditions(initRecordUpdate.filterLogic, secondRecordupdate.filterLogic, initRecordUpdate.filters, secondRecordupdate.filters);
                        if(newChange != null) {
                            newChange.name = initRecordUpdate.name;
                            newChange.label = initRecordUpdate.label;
                            newChange.elementType = initRecordUpdate.type;
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
