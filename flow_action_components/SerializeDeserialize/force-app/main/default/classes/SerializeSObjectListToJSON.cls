global with sharing class SerializeSObjectListToJSON {
    @InvocableMethod
        global static List <Results> serialize (List<Requests> requestList) {

            //Wrap the Results object in a List container (an extra step added to allow this interface to also support bulkification)
            List<Results> responseWrapper= new List<Results>();
            
            for (Requests curRequest : requestList) {
              String serializedSObjectListString;
              String serializedSObjectString;
              if (curRequest.inputSObjectList != null) {
                List<SObject> inputSObjectList = curRequest.inputSObjectList;
                serializedSObjectListString = JSON.serialize(inputSObjectList, true);
              }
              if (curRequest.inputSObject != null) {
                SObject inputSObject = curRequest.inputSObject;
                serializedSObjectString = JSON.serialize(inputSObject, true);
              }

              Results response = new Results();

              if (!String.isEmpty(serializedSObjectListString) && !String.isEmpty(serializedSObjectString)) {
                response.serializedSObjectListString = serializedSObjectListString.substring(0, serializedSObjectListString.length() - 1) + ',' + serializedSObjectString + ']';
              }
              else if (!String.isEmpty(serializedSObjectListString)) {
                response.serializedSObjectListString = serializedSObjectListString;
              }
              else if (!String.isEmpty(serializedSObjectString)) {
                response.serializedSObjectListString = '[' + serializedSObjectString + ']';
              }
              
              responseWrapper.add(response);
            }
           
            return responseWrapper;
        }
    
        global class Results {
          @InvocableVariable
          global String serializedSObjectListString;
        }
        
        global class Requests {       
          @InvocableVariable
          global SObject inputSObject;
          @InvocableVariable
          global List<SObject> inputSObjectList;
        }
}
