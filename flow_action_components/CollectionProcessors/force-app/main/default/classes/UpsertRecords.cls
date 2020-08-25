public with sharing class UpsertRecords {
  
  
        @InvocableMethod
        public static List<Results> execute (List<Request> requestList) {
            System.debug('entering Upsert');
            List<Results> responseWrapper = new List<Results>();
            for (Request curRequest : requestList) {
                List<SObject> inputCollection = curRequest.inputCollection != null ? curRequest.inputCollection : new List<SObject>();
                SObject inputRecord = curRequest.inputRecord;
                Boolean allOrNone = curRequest.allOrNone != null ? curRequest.allOrNone : true;
               
                Schema.SObjectField externalIdField;
                if (curRequest.externalIdFieldName == null) {
                    externalIdField = null;
                } else {
                    List<String> parts = curRequest.externalIdFieldName.split('\\.');
                    Map<String, SObjectField> fieldsMapByName = Schema.getGlobalDescribe().get(parts.get(0).toLowerCase()).getDescribe().fields.getMap();
                    externalIdField = fieldsMapByName.get(parts.get(1).toLowerCase());
                }
               
                if (inputCollection == null && inputRecord == null)
                    throw new InvocableActionException('You must pass in either an inputCollection or an inputRecord to the GenerateCollectionReport Action');
                
                //add the inputRecord to inputCollection so we can just handle inputCollection
                //note that cpe's will be able to ensure these are the same type
                if ( inputRecord != null)
                    inputCollection.add(inputRecord);

                if (externalIdField != null) {
                    Database.upsert(inputCollection,externalIdField,allOrNone);    
                } else {
                    Database.upsert(inputCollection,allOrNone);   
                }
                
                //Create a Results object to hold the return values
                Results response = new Results();

                responseWrapper.add(response);
            }     
         
            return responseWrapper;
        
        }
    
        public class Request {
          @InvocableVariable
          public List<SObject> inputCollection;

          @InvocableVariable
          public SObject inputRecord;

          @InvocableVariable
          public String externalIdFieldName;

          @InvocableVariable
          public Boolean allOrNone;
            
        }
        
        public class Results {
            @InvocableVariable
            public String placeholder; //don't ask

    
        }

        public class InvocableActionException extends Exception {}
}