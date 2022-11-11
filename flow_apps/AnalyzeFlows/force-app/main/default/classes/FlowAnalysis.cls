public with sharing class FlowAnalysis {

    @AuraEnabled
    public String baseFlowName;
    @AuraEnabled
    public Integer baseFlowVersion;
    @AuraEnabled
    public String baseFlowStatus;
    @AuraEnabled
    public String comparisonFlowName;
    @AuraEnabled
    public integer comparisonFlowVersion;
    @AuraEnabled
    public String comparisonFlowStatus;
    @AuraEnabled
    public DateTime analysisTime;
    @AuraEnabled
    public List<ElementStatusChange> elementChanges;
}
