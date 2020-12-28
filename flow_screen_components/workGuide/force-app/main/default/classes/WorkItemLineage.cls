//it's not currently easy to extract parental lineage about a work assignment, so we analyze the lineage one time and store it in this data structure
public with sharing class WorkItemLineage {

    public ConnectApi.OrchestrationWorkAssignment curWorkAssignment;
    public ConnectApi.OrchestrationInstance parentOrchInstance;
    public ConnectApi.OrchestrationStageInstance parentOrchStage;
    public ConnectApi.OrchestrationStepInstance parentOrchStep;



}