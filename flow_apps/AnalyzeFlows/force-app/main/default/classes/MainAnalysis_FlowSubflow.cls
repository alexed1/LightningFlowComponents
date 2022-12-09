public with sharing class MainAnalysis_FlowSubflow {
    public static FlowAnalysis analyzeSubflows(usf3.MetadataService.Flow initFlow, usf3.MetadataService.Flow secondFlow) {
        FlowAnalysis result = FlowElementAnalysisFunctions.initFlowAnalysisObject(initFlow, secondFlow);
        List<ElementStatusChange> changeList = new List<ElementStatusChange>();
        if(initFlow.subflows != null && secondFlow.subflows != null) {
            for(usf3.MetadataService.FlowSubflow initFlowSubflow : initFlow.subflows) {
                for(usf3.MetadataService.FlowSubflow secondFlowSubflow : secondFlow.subflows) {
                    if(initFlowSubflow.name == secondFlowSubflow.name) {
                        if(initFlowSubflow.flowName != secondFlowSubflow.flowName) {
                            changeList.add(new ElementStatusChange(
                                initFlowSubflow.name,
                                initFlowSubflow.name,
                                'A change was detected in the subflow configuration',
                                initFlowSubflow.type,
                                initFlowSubflow.description,
                                '',
                                secondFlowSubflow.flowName,
                                initFlowSubflow.flowName
                               
                            ));
                        }

                        ElementStatusChange newChange = FlowElementAnalysisFunctions.subAnalysis_ConnectorAndFaultConnector(initFlowSubflow.connector, secondFlowSubflow.connector, 'Outbound Primary Connector Path Points To A Different Element');
                        if(newChange != null) {
                            newChange.name = initFlowSubflow.name;
                            newChange.label = initFlowSubflow.label;
                            newChange.elementType = initFlowSubflow.type;
                            changeList.add(newChange);
                        }

                        changeList.addAll(FlowElementAnalysisFunctions.subAnalysis_OutputMappings(
                            (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(initFlowSubflow)), 
                            (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(secondFlowSubflow))
                        ));

                    }
                }
            }
        }

        result.elementChanges = changeList;
        return result;
    }
}
