public with sharing class MainAnalysis_FlowActionCall {
    public static FlowAnalysis analyzeFlowActionCalls(usf3.MetadataService.Flow initFlow, usf3.MetadataService.Flow secondFlow) {
        FlowAnalysis result = FlowElementAnalysisFunctions.initFlowAnalysisObject(initFlow, secondFlow);
        List<ElementStatusChange> changeList = new List<ElementStatusChange>();
        if(initFlow.actionCalls != null && secondFlow.actionCalls != null) {
            for(usf3.MetadataService.FlowActionCall initActionCall : initFlow.actionCalls) {
                for(usf3.MetadataService.FlowActionCall secondActionCall : secondFlow.actionCalls) {
                    if(initActionCall.name == secondActionCall.name) {


                        ElementStatusChange newChange = FlowElementAnalysisFunctions.subAnalysis_ConnectorAndFaultConnector(initActionCall.connector, secondActionCall.connector, 'Outbound Primary Connector Path Points To A Different Element');
                        if(newChange != null) {
                            newChange.name = initActionCall.name;
                            newChange.label = initActionCall.label;
                            newChange.elementType = initActionCall.type;
                            changeList.add(newChange);
                        }

                        newChange = FlowElementAnalysisFunctions.subAnalysis_ConnectorAndFaultConnector(initActionCall.faultConnector, secondActionCall.faultConnector, 'Outbound Fault Connector Path Points To A Different Element');
                        if(newChange != null) {
                            newChange.name = initActionCall.name;
                            newChange.label = initActionCall.label;
                            newChange.elementType = initActionCall.type;
                            changeList.add(newChange);
                        }

                        changeList.addAll(FlowElementAnalysisFunctions.SubAnalysis_InputParameters(
                            (List<Object>)JSON.deserializeUntyped(JSON.serialize(initActionCall.inputParameters)), 
                            (List<Object>)JSON.deserializeUntyped(JSON.serialize(secondActionCall.inputParameters)),
                            initActionCall.type
                        ));

                        changeList.addAll(FlowElementAnalysisFunctions.subAnalysis_OutputMappings(
                            (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(initActionCall)), 
                            (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(secondActionCall))
                        ));
                    }
                }
            }
        }

        result.elementChanges = changeList;
        return result;
    }

}
