@isTest
public with sharing class GenerateFlowFromPersonalWorkflowTest {
    @isTest
    static void invokeTest() {

        PersonalWorkflow__c personalWorkflow = new PersonalWorkflow__c();
        personalWorkflow.Name = 'Test Personal Workflow';

        personalWorkflow.Action_Description__c = 'Action Description';
        personalWorkflow.Activity__c = 'Activity';
        personalWorkflow.Trigger_Description__c = 'Trigger Description';
        personalWorkflow.Unique_Name__c = 'TestPersonalWorkflow';

        insert personalWorkflow;
        PersonalWorkflowAction__c personalWorkflowAction = new PersonalWorkflowAction__c();
        personalWorkflowAction.Label__c = 'Action Label';
        personalWorkflowAction.Parent_Workflow_Id__c = personalWorkflow.Id;
        personalWorkflowAction.PersonalWorkflowActionInputParam__c = '[{"name":"channelId","newValue":"id","newValueDataType":"String"}]';
        insert personalWorkflowAction;

        PersonalWorkflowTrigger__c personalWorkflowTrigger = new PersonalWorkflowTrigger__c();

        personalWorkflowTrigger.TriggerCriteriaFormula__c = '$Account.Id == TEXT("2")';
        personalWorkflowTrigger.Personal_Workflow__c = personalWorkflow.Id;
        personalWorkflowTrigger.TriggerFilterType__c = 'Expression';
        personalWorkflowTrigger.TriggeringEvents__c = 'Creation of a New Record';
        personalWorkflowTrigger.TriggerObjectName__c = 'Account';
        personalWorkflowTrigger.TriggerType__c = '';
        insert personalWorkflowTrigger;


        GenerateFlowFromPersonalWorkflow.Request request = new GenerateFlowFromPersonalWorkflow.Request();
        request.personalWorkflowId = personalWorkflow.Id;
        GenerateFlowFromPersonalWorkflow.Response response = GenerateFlowFromPersonalWorkflow.Invoke(new List<GenerateFlowFromPersonalWorkflow.Request>{request})[0];

        System.assert(String.isNotEmpty(response.flowXML));
        
        
    }
}
