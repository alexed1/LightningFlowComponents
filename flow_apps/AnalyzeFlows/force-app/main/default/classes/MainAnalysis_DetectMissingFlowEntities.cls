public with sharing class MainAnalysis_DetectMissingFlowEntities {
    public static FlowAnalysis detectMissingFlowEntities(usf3.MetadataService.Flow initFlow, usf3.MetadataService.Flow secondFlow) {
        return FlowElementAnalysisFunctions.detectNewOrRemovedFlowEntities(secondFlow, initFlow, 'Removed');

    }
}