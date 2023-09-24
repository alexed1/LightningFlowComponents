global with sharing class FlowAnalysis {

    @AuraEnabled
    global String baseFlowName;
    @AuraEnabled
    global Integer baseFlowVersion;
    @AuraEnabled
    global String baseFlowStatus;
    @AuraEnabled
    global String comparisonFlowName;
    @AuraEnabled
    global integer comparisonFlowVersion;
    @AuraEnabled
    global String comparisonFlowStatus;
    @AuraEnabled
    global DateTime analysisTime;
    @AuraEnabled
    global List<ElementStatusChange> elementChanges;
}
