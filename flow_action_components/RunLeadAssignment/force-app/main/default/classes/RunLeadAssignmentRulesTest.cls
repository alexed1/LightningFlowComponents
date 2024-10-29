@isTest
public with sharing class RunLeadAssignmentRulesTest {
    @isTest 
  
    static void createnewlead() {
    User userToCreate = [Select id from user where profile.name='System Administrator' Limit 1];
    
    Test.startTest();    
    Lead leadToCreate =new Lead();
    List<id> Ids= New List<Id>();
    leadToCreate.ownerid= userToCreate.id;
    leadToCreate.LastName ='Gupta';
    leadToCreate.Company='Salesforce';
    leadToCreate.LeadSource='Partner Referral';
    leadToCreate.Rating='';
    leadToCreate.Status='';
    insert leadToCreate; 
    
    Ids.add(leadToCreate.id);

    RunLeadAssignmentRules.Request testRequest = new RunLeadAssignmentRules.Request();
    testRequest.leadIds = Ids;
    List<RunLeadAssignmentRules.Request> requestList = new List<RunLeadAssignmentRules.Request>();
    requestList.add(testRequest);
    List<RunLeadAssignmentRules.Result> resultList = new List<RunLeadAssignmentRules.Result>();
    resultList = RunLeadAssignmentRules.execute(requestList);  
    
    Test.stopTest();
     }
}
