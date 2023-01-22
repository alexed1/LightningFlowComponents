// https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_class_Database_AssignmentRuleHeader.htm#apex_class_Database_AssignmentRuleHeader
//this action uses dmloptions headers to run lead assignment rules. this action was never fully finished but might be ready to go.
public with sharing class RunLeadAssignmentRules {

    @InvocableMethod
    public static List<Result> execute(List<Request> requestList)
    {
        List<Result> resultList = new List<Result>();
        for (Request curRequest : requestList ){ 


            if (String.isEmpty(curRequest.singleLeadId) && curRequest.collectionLeadIds == null) {
                throw new InvocableActionException('no lead ids were provided to RunLeadAssignment Rules');
            } else {
                List<Id> collectionLeadIds  = curRequest.collectionLeadIds;
                collectionLeadIds.add(curRequest.singleLeadId);
            }
        
            
            Database.DMLOptions dmo = new Database.DMLOptions();
            dmo.assignmentRuleHeader.useDefaultRule= true;          
            Lead leadRecords=[select id from lead where lead.id in :collectionLeadIds];
            leadRecords.setOptions(dmo);
            update leadRecords;
        } 
        return resultList;
       
   }


    public class Request {

        @invocableVariable
        public List<String> singleLeadId;

        @invocableVariable
        public List<String> collectionLeadIds;



    }

    public class Result {


        @invocableVariable
        public String placeholder;


    }

    public class InvocableActionException extends Exception{}




}