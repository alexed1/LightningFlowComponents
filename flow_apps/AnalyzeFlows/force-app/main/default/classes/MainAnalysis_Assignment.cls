public with sharing class MainAnalysis_Assignment {
    public static FlowAnalysis analyzeAssignments(usf3.MetadataService.Flow initFlow, usf3.MetadataService.Flow secondFlow) {
        FlowAnalysis result = FlowElementAnalysisFunctions.initFlowAnalysisObject(initFlow, secondFlow);
        List<ElementStatusChange> changeList = new List<ElementStatusChange>();
        changeList = FlowElementAnalysisFunctions.compareFlowArrayStructure(
            (List<Object>)JSON.deserializeUntyped(JSON.serialize(initFlow.assignments)), 
            (List<Object>)JSON.deserializeUntyped(JSON.serialize(secondFlow.assignments))
        );
        result.elementChanges = changeList;
        return result;
    }
}
