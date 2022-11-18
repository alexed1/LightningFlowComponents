public with sharing class MainAnalysis_DeleteRecords {
    public static FlowAnalysis analyzeDeleteRecords(usf3.MetadataService.Flow initFlow, usf3.MetadataService.Flow secondFlow) {
        FlowAnalysis result = new FlowAnalysis();
        result.baseFlowName = initFlow.fullName;
        result.baseFlowVersion = (Integer)initFlow.apiVersion;
        result.baseFlowStatus = initFlow.status;
        result.comparisonFlowName = secondFlow.fullName;
        result.comparisonFlowVersion = (Integer)secondFlow.apiVersion;
        result.comparisonFlowStatus = secondFlow.status;
        result.analysisTime = DateTime.now();
        List<ElementStatusChange> changeList = new List<ElementStatusChange>();
        if(initFlow.recordDeletes != null && secondFlow.recordDeletes != null) {
            for(usf3.MetadataService.FlowRecordDelete initRecordDelete : initFlow.recordDeletes) {
                for(usf3.MetadataService.FlowRecordDelete secondRecordDelete : secondFlow.recordDeletes) {
                    if(initRecordDelete.name == secondRecordDelete.name) {

                        ElementStatusChange newChange = FlowElementAnalysisFunctions.subAnalysis_ConnectorAndFaultConnector(initRecordDelete.connector, secondRecordDelete.connector, 'Outbound Primary Connector Path Points To A Different Element');
                        if(newChange != null) {
                            newChange.name = initRecordDelete.name;
                            newChange.label = initRecordDelete.label;
                            changeList.add(newChange);
                        }

                        newChange = FlowElementAnalysisFunctions.subAnalysis_ConnectorAndFaultConnector(initRecordDelete.faultConnector, secondRecordDelete.faultConnector, 'Outbound Fault Connector Path Points To A Different Element');
                        if(newChange != null) {
                            newChange.name = initRecordDelete.name;
                            newChange.label = initRecordDelete.label;
                            changeList.add(newChange);
                        }

                        newChange = FlowElementAnalysisFunctions.SubAnalysis_InputVariable(initRecordDelete.inputReference, secondRecordDelete.inputReference);
                        if(newChange != null) {
                            newChange.name = initRecordDelete.name;
                            newChange.label = initRecordDelete.label;
                            changeList.add(newChange);
                        }

                        newChange = FlowElementAnalysisFunctions.SubAnalysis_ObjectSettings (initRecordDelete.object_x, secondRecordDelete.object_x);
                        if(newChange != null) {
                            newChange.name = initRecordDelete.name;
                            newChange.label = initRecordDelete.label;
                            changeList.add(newChange);
                        }

                        newChange = FlowElementAnalysisFunctions.SubAnalysis_FilterConditions(initRecordDelete.filterLogic, secondRecordDelete.filterLogic, initRecordDelete.filters, secondRecordDelete.filters);
                        if(newChange != null) {
                            newChange.name = initRecordDelete.name;
                            newChange.label = initRecordDelete.label;
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
