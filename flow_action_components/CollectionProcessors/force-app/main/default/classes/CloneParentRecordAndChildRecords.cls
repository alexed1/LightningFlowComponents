global with sharing class CloneParentRecordAndChildRecords {
    @InvocableMethod
    global static List <Results> clone(List<Requests> requestList) {

        
        SObject inputRecord = requestList[0].inputRecord;
        String inputRecordId = requestList[0].inputRecordId;
        Boolean preserveId = requestList[0].preserveId != null ? requestList[0].preserveId : false;
        Boolean saveImmediately = requestList[0].saveImmediately != null ? requestList[0].saveImmediately : false;


        List<Results> responseWrapper = new List<Results>();

        Results response = new Results();
        try {
            if (inputRecordId == null && inputRecord == null) {
                throw new InvocableActionException('You need to pass either a record or a recordId into this action, representing the entity you want to clone');
            } else if (inputRecordId != null && inputRecord != null) {
                throw new InvocableActionException('You need to pass either a record or a recordId into this action, but you can not pass both');
            }
            if (inputRecordId != null) {
                String typeName = ID.valueOf(inputRecordId).getSObjectType().getDescribe().getName();
                inputRecord = Database.query('SELECT Id, Name From ' + typeName + ' Where Id = :inputRecordId');       
            }
            System.debug('made it through validation. inputRecord is: ' + inputRecord);
            response.clonedRecord = inputRecord.clone(preserveId);   
            System.debug('after in-memory clone, clonedRecord is: ' + response.clonedRecord);
        } 
        catch ( Exception e) {
            response.errorText = e.getMessage();
        }

        if (saveImmediately)  {
            // setup the save point for rollback
            Savepoint sp = Database.setSavepoint();
            System.debug('Saving clone...');
            
            try {
                insert response.clonedRecord;
                response.clonedRecordId = response.clonedRecord.Id;
                System.debug('saved record id is: ' + response.clonedRecord.Id);
            } catch(Exception e){
                Database.rollback(sp);
                response.errorText = e.getMessage();
            }
        }
        
        //for each child relationship name, query for the records that have the inputRecord as parent
        //suppose the parent account is Order and we want all the child OrderLines
        //we need to know for our query of OrderLines what the fieldname is of the lookup relationship. It is not deterministic
        //so we have to first find all the child relationships of Order, match them by name with the requested relationships and find the field names of the lookup fields 
        //once we have the field name from the ChildRelationship, we can do a query for all the child records

        responseWrapper.add(response);
        return responseWrapper;
    }

    global class InvocableActionException extends Exception {}

    global class Requests {
        @InvocableVariable(required=true)
        global SObject inputRecord;

        @InvocableVariable(required=true)
        global String inputRecordId;

        @InvocableVariable
        global List<String> childRelationships;

        @InvocableVariable
        global String childRelationshipsCSV;

        @invocableVariable
        global Boolean saveImmediately;

        @invocableVariable
        global Boolean preserveId;
       
    }

    global class Results {

        public Results() {
            clonedRelatedList = new List<SObject>();
        }

        @InvocableVariable(required=true)
        global SObject clonedRecord;

        @InvocableVariable
        global List<SObject> clonedRelatedList;

        @invocableVariable
        global String clonedRecordId;

        @invocableVariable
        global String errorText;
    }
}