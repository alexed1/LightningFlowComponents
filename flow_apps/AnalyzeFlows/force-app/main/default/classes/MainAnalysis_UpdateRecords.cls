public with sharing class MainAnalysis_UpdateRecords {
    public static FlowAnalysis analyzeCreateRecords(usf3.MetadataService.Flow initFlow, usf3.MetadataService.Flow secondFlow) {
        FlowAnalysis result = new FlowAnalysis();
        result.baseFlowName = initFlow.fullName;
        result.baseFlowVersion = (Integer)initFlow.apiVersion;
        result.baseFlowStatus = initFlow.status;
        result.comparisonFlowName = secondFlow.fullName;
        result.comparisonFlowVersion = (Integer)secondFlow.apiVersion;
        result.comparisonFlowStatus = secondFlow.status;
        result.analysisTime = DateTime.now();
        List<ElementStatusChange> changeList = new List<ElementStatusChange>();
        if(initFlow.recordCreates != null && secondFlow.recordCreates != null) {
            for(usf3.MetadataService.FlowRecordUpdate initRecordUpdate : initFlow.recordUpdates) {
                for(usf3.MetadataService.FlowRecordUpdate secondRecordupdate : secondFlow.recordUpdates) {
                    if(initRecordUpdate.name == secondRecordupdate.name) {
                        ElementStatusChange newChange = FlowElementAnalysisFunctions.subAnalysis_ConnectorAndFaultConnector(initRecordUpdate.connector, secondRecordupdate.connector, 'Outbound Primary Connector Path Points To A Different Element');
                        if(newChange != null) {
                            newChange.name = initRecordUpdate.name;
                            newChange.label = initRecordUpdate.label;
                            changeList.add(newChange);
                        }

                        newChange = FlowElementAnalysisFunctions.subAnalysis_ConnectorAndFaultConnector(initRecordUpdate.faultConnector, secondRecordupdate.faultConnector, 'Outbound Fault Connector Path Points To A Different Element');
                        if(newChange != null) {
                            newChange.name = initRecordUpdate.name;
                            newChange.label = initRecordUpdate.label;
                            changeList.add(newChange);
                        }

                        newChange = FlowElementAnalysisFunctions.SubAnalysis_InputVariable(initRecordUpdate.inputReference, secondRecordupdate.inputReference);
                        if(newChange != null) {
                            newChange.name = initRecordUpdate.name;
                            newChange.label = initRecordUpdate.label;
                            changeList.add(newChange);
                        }

                        newChange = FlowElementAnalysisFunctions.SubAnalysis_ObjectSettings (initRecordUpdate.object_x, secondRecordupdate.object_x);
                        if(newChange != null) {
                            newChange.name = initRecordUpdate.name;
                            newChange.label = initRecordUpdate.label;
                            changeList.add(newChange);
                        }

                        newChange = FlowElementAnalysisFunctions.SubAnalysis_InputAndOutputParams(initRecordUpdate.inputAssignments, secondRecordupdate.inputAssignments);
                        if(newChange != null) {
                            newChange.name = initRecordUpdate.name;
                            newChange.label = initRecordUpdate.label;
                            changeList.add(newChange);
                        }

                        newChange = FlowElementAnalysisFunctions.SubAnalysis_FilterConditions(initRecordUpdate.filterLogic, secondRecordupdate.filterLogic, initRecordUpdate.filters, secondRecordupdate.filters);
                        if(newChange != null) {
                            newChange.name = initRecordUpdate.name;
                            newChange.label = initRecordUpdate.label;
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
