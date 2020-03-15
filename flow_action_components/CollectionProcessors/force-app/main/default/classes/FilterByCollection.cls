//filtering get records against a collection, like we can with bind variables in apex, anytime soon? 
//e.g. get a set of campaigns in step 1, get all campaign members in step 2.

global with sharing class FilterByCollection {
    @InvocableMethod
    global static List <Results> filter(List<Requests> requestList) {
        Results response = new Results();
      
        List<SObject> containingCollection = requestList[0].containingCollection;
        String objectName = requestList[0].objectName;
        String returnFields = requestList[0].returnFields;
        String bindField = requestList[0].bindField;
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
        List<Results> responseWrapper = new List<Results>();
        responseWrapper.add(response);

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