global with sharing class GetLookupCollection {
    //    convert to a Set of ID's
    //    setup the query 
   

    @InvocableMethod
    global static List <Results> get(List<Request> requestList) {

        List<Results> responseWrapper = new List<Results>();

        Results response = new Results();
        for (Request curRequest : requestList) {
            response = new Results();
            List<SObject> inputRecords = curRequest.inputCollection;
            List<String> inputIds = curRequest.inputIds;

            SObjectField lookupField;
            Schema.DescribeSObjectResult inputObjectTypeDescribe;
            String inputObjectTypeName;
            String lookupFieldName;

            try {
                if (inputIds == null && inputRecords == null) {
                    throw new InvocableActionException('You need to pass either a collection of records or a collection of record IDs into this action, representing the initial set of records');
                } else if (inputIds != null && inputRecords != null) {
                    throw new InvocableActionException('You need to pass either a collection of records or a collection of record IDs into this action, but you can not pass both');
                }

                //convert input to a Set of Ids
                Set<Id> resultIds;
                if (inputRecords != null && !inputRecords.isEmpty()) {
                    resultIds = (new Map<Id,SObject>(inputRecords)).keySet();
                    inputObjectTypeDescribe = inputRecords[0].getSObjectType().getDescribe();
                    inputObjectTypeName = inputObjectTypeDescribe.getName();
                     
                    //inputRecord = Database.query('SELECT Id, Name From ' + typeName + ' Where Id = :inputRecordId');    */    
                } else {
                    //recordType = inputRecord.getSObjectType();  
                     List<Id> idList = new List<Id>( (List<Id>)inputIds );
                     resultIds = new Set<Id>(idList);
                     inputObjectTypeDescribe = ID.valueOf(idList[0]).getSObjectType().getDescribe();
                     inputObjectTypeName = inputObjectTypeDescribe.getName();
                }
                System.debug('set of Ids is: ' + resultIds);
                System.debug('inputObjectType is: ' + inputObjectTypeName);
                
        
                Schema.SObjectType lookupObjectType = Schema.getGlobalDescribe().get(curRequest.lookupObjectName);

                for (ChildRelationship childRel : lookupObjectType.getDescribe().getChildRelationships()) {
                    if (childRel.getChildSObject() == inputRecords[0].getSObjectType()) {
                        lookupFieldName = childRel.getField().getDescribe().getName();
                    }
                }

                String qry = 'SELECT ' + curRequest.lookupRecordFieldsCSV + ' FROM ' + curRequest.lookupObjectName + ' WHERE Id in (SELECT ' + lookupFieldName  + ' FROM ' + inputObjectTypeName + ' WHERE Id ' + ' IN :resultIds)';
                System.debug ('query is: ' + qry);

                response.lookupCollection = Database.query(qry);
                System.debug ('lookup collection is: ' + response.lookupCollection);
               
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
        global List<SObject> inputCollection;

        @InvocableVariable 
        global List<String> inputIds;

        @InvocableVariable
        global String lookupRecordFieldsCSV;

        @InvocableVariable
        global String lookupObjectName;

         
       
    }

    global class Results {

        public Results() {
            lookupCollection = new List<SObject>();
        }

  
        @InvocableVariable
        global List<SObject> lookupCollection;

        @InvocableVariable
        global String errorText;



    }
}