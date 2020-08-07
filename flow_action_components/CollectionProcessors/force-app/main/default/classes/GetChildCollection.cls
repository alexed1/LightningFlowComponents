global with sharing class GetChildCollection {
 

        
    //    get the type of the input record
    //    get the child relationships of that type
    //    find the relationship that has the object type OpportunityContactRole (https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_class_Schema_ChildRelationship.htm#apex_Schema_ChildRelationship_getChildSObject)
    //    query for all of that object where the field *getField()* (https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_class_Schema_ChildRelationship.htm#apex_Schema_ChildRelationship_getField) is equal to the id of the record


    @InvocableMethod
    global static List <Results> get(List<Request> requestList) {

        List<Results> responseWrapper = new List<Results>();

        Results response = new Results();
        for (Request curRequest : requestList) {
            response = new Results();
            SObject inputRecord = curRequest.inputRecord;
            String inputRecordId = curRequest.inputRecordId;

            SObjectType recordType;
            SObjectField lookupField;
            

            try {
                if (inputRecordId == null && inputRecord == null) {
                    throw new InvocableActionException('You need to pass either a record or a recordId into this action, representing the entity you want to start with');
                } else if (inputRecordId != null && inputRecord != null) {
                    throw new InvocableActionException('You need to pass either a record or a recordId into this action, but you can not pass both');
                }
                if (inputRecordId != null) {
                    recordType = ID.valueOf(inputRecordId).getSObjectType();
                    String typeName = recordType.getDescribe().getName();
                    inputRecord = Database.query('SELECT Id From ' + typeName + ' Where Id = :inputRecordId');
                } else {
                    recordType = inputRecord.getSObjectType();    
                }
                System.debug('made it through validation. inputRecord is: ' + inputRecord);
                for(ChildRelationship curChildRel : recordType.getDescribe().getChildRelationships()){
                    Schema.DescribeSObjectResult childRelDescribe = curChildRel.getChildSObject().getDescribe();
                    System.debug('childRelDescribe.getName():::'+childRelDescribe.getName());
                    if (childRelDescribe.getName() == curRequest.childRelationshipName) {
                        lookupField = curChildRel.getField();
                    }
                }
                if (lookupField == null)
                    throw new InvocableActionException('Did not find the relationship ' + curRequest.childRelationshipName + ' on the passed in record or id');
    
                
                // query for all of that object where the field *getField()* (https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_class_Schema_ChildRelationship.htm#apex_Schema_ChildRelationship_getField) is equal to the id of the record
                String qry = 'SELECT ' + curRequest.childRecordFieldsCSV + ' FROM ' + curRequest.childRelationshipName + ' WHERE ' + lookupField.getDescribe().getName() + ' = \'' + inputRecord.Id + '\'';
                System.debug ('query is: ' + qry);
                
               
                response.childCollection = Database.query(qry);
                System.debug ('childCollection is: ' + response.childCollection);
               
            } 
            catch ( Exception e) {
                response.errorText = e.getMessage();
                System.debug('error is: ' + e.getMessage());
            }

            
            
        }
        responseWrapper.add(response);
        return responseWrapper;
    }

    global class InvocableActionException extends Exception {}

    global class Request {
        @InvocableVariable 
        global SObject inputRecord;

        @InvocableVariable 
        global String inputRecordId;

        @InvocableVariable
        global String childRelationshipName;

        @InvocableVariable
        global String childRecordFieldsCSV;

         
       
    }

    global class Results {

        public Results() {
            childCollection = new List<SObject>();
        }

  
        @InvocableVariable
        global List<SObject> childCollection;

        @InvocableVariable
        global String errorText;



    }
}