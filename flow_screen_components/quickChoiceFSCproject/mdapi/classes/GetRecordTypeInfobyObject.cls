 public with sharing class GetRecordTypeInfobyObject {
  //given a fieldname and a collection, return a collection of strings representing the fieldname
//great for extracting the Names of SObjects from SObject Collections
//should rename this
//should support more than just string fields


    @InvocableMethod
    public static List <Results> get(List<Requests> requestList) {
        Results response = new Results();

        String objectName = requestList[0].objectName;
        Boolean onlyReturnActiveRecordTypes = requestList[0].onlyReturnActiveRecordTypes;
        Boolean onlyReturnRecordTypesAvailableToCurrentUser = requestList[0].onlyReturnRecordTypesAvailableToCurrentUser;
        List<String> recordTypeNames = new List<String>();
        List<String> recordTypeIds = new List<String>();
        String errors;
        // Send the email you have created.
        try {
            
            Map<String, Schema.RecordTypeInfo> recTypeInfoMap = Schema.getGlobalDescribe().get(objectName).getDescribe().getRecordTypeInfosByName();
            List<Schema.RecordTypeInfo> recTypeInfoList = recTypeInfoMap.values();
            
            //extract the names and recordIds and return them as List<String> 
            for(Schema.RecordTypeInfo curRecord : recTypeInfoList) {
                System.debug('processing record: ' + curRecord);
                Boolean filteredOut = false;
                //if only active 
                if (onlyReturnActiveRecordTypes = true && ! curRecord.isActive()) {
                        filteredOut = true;    
                }
                if (onlyReturnRecordTypesAvailableToCurrentUser = true && ! curRecord.isAvailable()) {
                        filteredOut = true;    
                }
                if ( filteredOut != true) {
                    recordTypeNames.add(curRecord.getName());
                    recordTypeIds.add(curRecord.getRecordTypeId());
                }
               
            }

        } catch (InvocableActionException e){
            System.debug ('exception occured: ' + e.getMessage());
            
            errors = e.getMessage();
        } 
        response.recordTypeNames = recordTypeNames;
        response.recordTypeIds = recordTypeIds;
        response.errors = errors;
        List<Results> responseWrapper = new List<Results>();
        responseWrapper.add(response);

        return responseWrapper;


    }
    public class Requests {

        @InvocableVariable(label='Object Name' required=true)
        public String objectName;

        @InvocableVariable
        public Boolean onlyReturnActiveRecordTypes;

        @InvocableVariable
        public Boolean onlyReturnRecordTypesAvailableToCurrentUser;

    }

    public class Results {

        public Results() {
            
        }
        @InvocableVariable
        public String errors;

        @InvocableVariable
        public List<String> recordTypeNames;

        @InvocableVariable
        public List<String> recordTypeIds;
    }

    public class InvocableActionException extends Exception {}

}
