public with sharing class FindRecordsInCollection {
   
    @InvocableMethod
    public static List <Results> execute (List<Requests> requestList) {
        System.debug('entering FindRecordInCollection');
        List<SObject>  inputCollection = requestList[0].inputCollection;
        String targetField = requestList[0].targetField;
        String targetValue = requestList[0].targetValue;
        String targetObject = requestList[0].targetObject;

        //Create a Results object to hold the return values
        Results response = new Results();


        //given a list of items, and a search string, find all of the matches
        //iterate through input collection
        //check the value of the current input  
        Schema.SobjectField curField = getFieldByName(targetObject,targetField);
        for(SObject curRecord : inputCollection) {
            String value = (String)curRecord.get(curField);
            if (value == targetValue){
                response.multipleOutputMembers.add(curRecord);
            }
        }

        //because a lot of flow manipulations are easier if you're dealing with a single record
        //instead of a collection, we provide a single record return value if there's only one hit.
        if(response.multipleOutputMembers.size() == 1) {
            response.singleOutputMember = response.multipleOutputMembers[0];
        }

        //Wrap the Results object in a List container (an extra step added to allow this interface to also support bulkification)
        List<Results> responseWrapper= new List<Results>();
        responseWrapper.add(response);
         System.debug('response is: '+ response);
        System.debug('responseWrapper is: '+ responseWrapper);

        return responseWrapper;
    
    }

    //given the name of a field, return the actual field itself
    //ref https://salesforce.stackexchange.com/a/192792/24822
    public static Schema.SobjectField getFieldByName (String objectName, String fieldName) {

        // get the SObjectType
        Schema.SObjectType objectType = Schema.getGlobalDescribe().get(objectName);

        // get the fields on the object
        Map<String, SObjectField> fieldMap = objectType.getDescribe().fields.getMap();

        // The key to the map is the api name of the field
        Schema.SobjectField theField = fieldMap.get(fieldName);

        return theField;
    }


    public  class Requests {
      @InvocableVariable(required=true)
      public List<SObject> inputCollection;

      @InvocableVariable
      public String targetObject;

      @InvocableVariable
      public String targetField;

       @InvocableVariable
      public String targetValue;
        
    }
    
    public  class Results {

        public Results() {
           
           multipleOutputMembers = new List<SObject>();
        }
     
      @InvocableVariable
      public SObject singleOutputMember;

      @InvocableVariable
      public List<SObject> multipleOutputMembers;
    }
}
