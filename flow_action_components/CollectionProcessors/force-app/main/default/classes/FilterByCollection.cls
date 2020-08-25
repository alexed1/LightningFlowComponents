//filtering get records against a collection, like we can with bind variables in apex, anytime soon? 
//e.g. get a set of campaigns in step 1, get all campaign members in step 2.

global with sharing class FilterByCollection {
    @InvocableMethod
    global static List <Results> filter(List<Requests> requestList) {
        List<Results> responseWrapper = new List<Results>();
        for (Requests curRequest : requestList) {
            Results response = new Results();
            List<SObject> containingCollection = curRequest.containingCollection;
            String objectName = curRequest.objectName;
            String returnFields = curRequest.returnFields;
            String bindField = curRequest.bindField;
            if (returnFields == '' || returnFields == null)
                returnFields = 'Id';
            if (bindField == '' || bindField == null)
                bindField = 'Id';
            
            if (containingCollection != null && !containingCollection.isEmpty() && objectName != null) {
                String queryString;
                queryString = 'SELECT ' + returnFields + ' FROM ' + objectName + ' WHERE ' + bindField + ' IN :containingCollection'; 
                System.debug ('queryString is: ' + queryString);
                queryString = 'SELECT Name,Id,CampaignId FROM CampaignMember WHERE CampaignId IN :containingCollection';
                response.foundRecords = Database.query(queryString);
            } else {
                throw new InvocableActionException('ContainingCollection or ObjectName did not contain valid values');
            }
            
            responseWrapper.add(response);

        }
      
       

        return responseWrapper;


    }
    
    global class InvocableActionException extends Exception {}

    global class Requests {
        @InvocableVariable(required=true)
        global String objectName;

        @InvocableVariable
        global String returnFields;

        @InvocableVariable
        global String bindField;

        @InvocableVariable(required=true)
        global List<SObject> containingCollection;

    }

    global class Results {

       
        @InvocableVariable
        global String errors;

        @InvocableVariable
        global List<SObject> foundRecords;
    }
}