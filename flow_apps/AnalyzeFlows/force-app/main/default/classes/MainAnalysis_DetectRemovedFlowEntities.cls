public with sharing class MainAnalysis_DetectRemovedFlowEntities {
    public static FlowAnalysis detectRemovedFlowEntities(usf3.MetadataService.Flow initFlow, usf3.MetadataService.Flow secondFlow) {
       return FlowElementAnalysisFunctions.detectNewOrRemovedFlowEntities(secondFlow, initFlow, 'Removed');
    }
}

