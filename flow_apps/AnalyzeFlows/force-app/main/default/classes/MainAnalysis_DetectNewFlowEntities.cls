public with sharing class MainAnalysis_DetectNewFlowEntities {
    public static FlowAnalysis detectNewFlowEntities(usf3.MetadataService.Flow initFlow, usf3.MetadataService.Flow secondFlow) {
        return FlowElementAnalysisFunctions.detectNewOrRemovedFlowEntities(initFlow, secondFlow, 'New');
    }

}
