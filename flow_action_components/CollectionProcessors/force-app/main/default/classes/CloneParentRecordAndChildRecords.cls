//credit for major code from
//Author Charlie Jonas (charlie@callaway.cloud)
// Class to clone an SObject and it's children.
//   - Not currently optimized for bulk use!
//   See https://github.com/ChuckJonas/SObjectDeepClone 

global with sharing class CloneParentRecordAndChildRecords {
    @InvocableMethod
    global static List <Results> clone(List<Requests> requestList) {

        System.debug('entering clone:' + requestList);
        SObject inputRecord = requestList[0].inputRecord;
        String inputRecordId = requestList[0].inputRecordId;
        String childObjectNamesCSV = requestList[0].childObjectNamesCSV;
        List<String> childObjectNames = requestList[0].childObjectNames;

        Boolean preserveId = requestList[0].preserveId != null ? requestList[0].preserveId : false;
        Boolean saveImmediately = requestList[0].saveImmediately != null ? requestList[0].saveImmediately : false;
        Map<String, ChildRelationshipProps> relationshipMap = new Map<String, ChildRelationshipProps>();


        List<Results> responseWrapper = new List<Results>();

        Results response = new Results();
        try {
            if (inputRecordId == null && inputRecord == null) {
                throw new InvocableActionException('You need to pass either a record or a recordId into this action, representing the entity you want to clone');
            } else if (inputRecordId != null && inputRecord != null) {
                throw new InvocableActionException('You need to pass either a record or a recordId into this action, but you can not pass both');
            }
            
             if ((childObjectNames == null || childObjectNames.isEmpty()) && childObjectNamesCSV == null) {
                throw new InvocableActionException('You need to pass in the name of at least one child relationship name. You can do this either via a collection of strings or a single comma-separated string');
            } else if (childObjectNames != null && !childObjectNames.isEmpty() && childObjectNamesCSV != null) {
                throw new InvocableActionException('You need to pass either a value for childObjectNames or for childObjectNamesCSV into this action, but you can not pass both');
            } 
            if (childObjectNamesCSV != null){
                childObjectNames = childObjectNamesCSV.split(',');
            }
            SObjectType curObjectType;
            String curObjectTypeName;

            //must be either childcsv or child
            //if saveImmediately is false, the length must be exactly 1
            System.debug('childObjectNames is: ' + childObjectNames);
            if (inputRecordId != null) {
                curObjectType = ID.valueOf(inputRecordId).getSObjectType();
                curObjectTypeName = curObjectType.getDescribe().getName();
                inputRecord = Database.query('SELECT Id, Name From ' + curObjectTypeName + ' Where Id = :inputRecordId');       
            } else {
                curObjectType = inputRecord.getSObjectType();
            }
            System.debug('made it through validation. inputRecord is: ' + inputRecord);
            relationshipMap = mapStringsToRelationships(curObjectType, childObjectNames);
            response.clonedRecord = inputRecord.clone(preserveId);   
            System.debug('after in-memory clone, clonedRecord is: ' + response.clonedRecord);
        } 
        catch ( Exception e) {
            response.errorText = e.getMessage() + ' LN:' + e.getLineNumber();
     
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

    private static Map<string, ChildRelationshipProps>  mapStringsToRelationships(SObjectType curObjectType, List<String> relationshipStrings) {

        Map<string, ChildRelationshipProps> relationshipMap = new Map<string, ChildRelationshipProps>();
        Map<String, ChildRelationship> childRelationMap = new Map<String, ChildRelationship>();
        System.debug ('curObjectType is: ' + curObjectType);
        for(ChildRelationship rel : curObjectType.getDescribe().getChildRelationships()){
            String relName = rel.getRelationshipName();
            if(relName != null){ //not sure why this would happen but it does
                childRelationMap.put(rel.getRelationshipName().toUpperCase(), rel);
            }
        }

        for(String relStr : relationshipStrings){
            relStr = relStr.toUpperCase();
            System.debug('childRelationMap is: ' + childRelationMap.get('CONTACTS'));
            if(childRelationMap.containsKey(relStr)){
                ChildRelationship rel = childRelationMap.get(relStr);
                relationshipMap.put(rel.getRelationshipName().toUpperCase(), new ChildRelationshipProps(rel));
            }else{
                throw new InvocableActionException(
                    'Child Relationship \'' + relStr + '\' does not exist on ' + curObjectType.getDescribe().getName()
                );
            }
        }
        return relationshipMap;
    }
    

    global class InvocableActionException extends Exception {}

    //seralizable subset of ChildRelationship properties that we need
    private class ChildRelationshipProps{
        public SObjectType sObjectType;
        public SObjectField field;
        public ChildRelationshipProps(ChildRelationship rel){
            this.sObjectType = rel.getChildSObject();
            this.field = rel.getField();
        }
    }

    global class Requests {
        @InvocableVariable()
        global SObject inputRecord;

        @InvocableVariable()
        global String inputRecordId;

        @InvocableVariable
        global List<String> childObjectNames;

        @InvocableVariable
        global String childObjectNamesCSV;

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