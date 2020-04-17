global with sharing class DeepClone {

    //for each child relationship name, query for the records that have the inputRecord as parent
    //suppose the parent account is Order and we want all the child OrderLines
    //we need to know for our query of OrderLines what the fieldname is of the lookup relationship. It is not deterministic
    //so we have to first find all the child relationships of Order, match them by name with the requested relationships and find the field names of the lookup fields
    //once we have the field name from the ChildRelationship, we can do a query for all the child records
    @TestVisible
    private static String ERROR_NO_RECORD_NO_ID = 'You need to pass either a record or a recordId into this action, representing the entity you want to clone';
    @TestVisible
    private static String ERROR_RECORD_AND_ID = 'You need to pass either a record or a recordId into this action, but you can not pass both';
    @TestVisible
    private static String ERROR_SAVE_CHILD_WITHOUT_PARENT = 'You tried to save child records that didn\'t have a parentId, which might mean that you need to first save the parent record';
    @InvocableMethod
    global static List <Results> clone(List<Requests> requestList) {
        List<Results> responseWrapper = new List<Results>();

        for (Requests curRequest : requestList) {
            SObject inputRecord = curRequest.inputRecord;
            String inputRecordId = curRequest.inputRecordId;
            List<String> childRelationships = curRequest.childRelationships != null ? curRequest.childRelationships : (new List<String>());
            String childRelationshipsCSV = curRequest.childRelationshipsCSV;
            Boolean saveChildRecordsAutomatically = curRequest.saveChildRecordsAutomatically != null ? curRequest.saveChildRecordsAutomatically : false;
            Boolean saveImmediately = curRequest.saveImmediately != null ? curRequest.saveImmediately : false;
            Results response = new Results();
            SObjectDeepClone cloner;


            if (inputRecordId == null && inputRecord == null) {
                throw new InvocableActionException(ERROR_NO_RECORD_NO_ID);
            } else if (inputRecordId != null && inputRecord != null) {
                throw new InvocableActionException(ERROR_RECORD_AND_ID);
            } else if (saveChildRecordsAutomatically && !saveImmediately) {
                throw new InvocableActionException(ERROR_SAVE_CHILD_WITHOUT_PARENT);
            }
            if (childRelationships == null || childRelationships.isEmpty() && !String.isBlank(childRelationshipsCSV)) {
                childRelationships = childRelationshipsCSV.replaceAll(' ', '').split(',');
            }
    
            if (inputRecordId != null) {
                cloner = new SObjectDeepClone(inputRecordId, new Set<String>(childRelationships), saveChildRecordsAutomatically);
            } else if (inputRecord.Id != null) {
                cloner = new SObjectDeepClone(inputRecord.Id, new Set<String>(childRelationships), saveChildRecordsAutomatically);
            } else if (inputRecord != null) {
                cloner = new SObjectDeepClone(inputRecord, new Set<String>(childRelationships), saveChildRecordsAutomatically);
            }
            if (cloner != null) {
                response.clonedRecord = cloner.clone;
                
            }
    
            if (saveImmediately && cloner != null) {
    
                response.clonedRecordId = cloner.save();
                if (!cloner.clonedChildrenPerTypeMap.isEmpty()) {
    
                    for (Integer i = 1; i <= Math.min(5, childRelationships.size()); i++) {
                        String curRelation = childRelationships[i - 1];
    
                        List<SObject> curChildren = cloner.clonedChildrenPerTypeMap.get(curRelation.toUpperCase());
                        if (i == 1) {
                            response.clonedRelatedList1 = curChildren;
                        } else if (i == 2) {
                            response.clonedRelatedList2 = curChildren;
                        } else if (i == 3) {
                            response.clonedRelatedList3 = curChildren;
                        } else if (i == 4) {
                            response.clonedRelatedList4 = curChildren;
                        } else if (i == 5) {
                            response.clonedRelatedList5 = curChildren;
                        }
                    }
                }
            }
    
            responseWrapper.add(response);
        }
        

        



        return responseWrapper;
    }

    global class InvocableActionException extends Exception {
    }

    global class Requests {
        @InvocableVariable(required=false)
        global SObject inputRecord;

        @InvocableVariable(required=false)
        global String inputRecordId;

        @InvocableVariable
        global List<String> childRelationships;

        @InvocableVariable
        global String childRelationshipsCSV;

        @invocableVariable
        global Boolean saveImmediately = true;

        @invocableVariable
        global Boolean saveChildRecordsAutomatically = false;
    }

    global class Results {

        public Results() {
            clonedRelatedList1 = new List<SObject>();
            clonedRelatedList2 = new List<SObject>();
            clonedRelatedList3 = new List<SObject>();
            clonedRelatedList4 = new List<SObject>();
            clonedRelatedList5 = new List<SObject>();

        }

        @InvocableVariable
        global SObject clonedRecord;

        @InvocableVariable
        global List<SObject> clonedRelatedList1;

        @InvocableVariable
        global List<SObject> clonedRelatedList2;

        @InvocableVariable
        global List<SObject> clonedRelatedList3;

        @InvocableVariable
        global List<SObject> clonedRelatedList4;

        @InvocableVariable
        global List<SObject> clonedRelatedList5;

        @invocableVariable
        global String clonedRecordId;

        @invocableVariable
        global String errorText;
    }
}