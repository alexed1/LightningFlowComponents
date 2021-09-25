global with sharing class SerializeSObjectToJSON {
  @InvocableMethod
      global static List <Results> serialize (List<Requests> requestList) {

          //Wrap the Results object in a List container (an extra step added to allow this interface to also support bulkification)
          List<Results> responseWrapper= new List<Results>();
          
          for (Requests curRequest : requestList) {
            String serializedSObjectString;
            if (curRequest.inputSObjectList != null) {
              List<SObject> inputSObjectList = curRequest.inputSObjectList;
              serializedSObjectString = JSON.serialize(inputSObjectList, true);
            }
            if (curRequest.inputSObject != null) {
              SObject inputSObject = curRequest.inputSObject;
              if (!String.isEmpty(serializedSObjectString)) {
                String serializedSingleton = JSON.serialize(inputSObject, true);
                serializedSObjectString = serializedSObjectString.substring(0, serializedSObjectString.length() - 1) + ',' + serializedSingleton + ']';
              }
              else {
                serializedSObjectString = '[' + JSON.serialize(inputSObject, true) + ']';
              }
            }

            Results response = new Results();
            response.serializedSObjectString = serializedSObjectString;
            responseWrapper.add(response);
          }
         
          return responseWrapper;
      }
  
      global class Results {
        @InvocableVariable
        global String serializedSObjectString;
      }
      
      global class Requests {       
        @InvocableVariable
        global SObject inputSObject;
        @InvocableVariable
        global List<SObject> inputSObjectList;
      }
}