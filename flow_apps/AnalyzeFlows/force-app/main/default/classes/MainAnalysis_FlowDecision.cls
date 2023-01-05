public with sharing class MainAnalysis_FlowDecision {
    public static FlowAnalysis analyzeFlowDecisions(usf3.MetadataService.Flow initFlow, usf3.MetadataService.Flow secondFlow) {
        FlowAnalysis result = FlowElementAnalysisFunctions.initFlowAnalysisObject(initFlow, secondFlow);
        List<ElementStatusChange> changeList = new List<ElementStatusChange>();
        changeList = FlowElementAnalysisFunctions.compareFlowArrayStructure(
            (List<Object>)JSON.deserializeUntyped(JSON.serialize(initFlow.decisions)), 
            (List<Object>)JSON.deserializeUntyped(JSON.serialize(secondFlow.decisions))
        );
        result.elementChanges = changeList;
        return result;
    }
}
