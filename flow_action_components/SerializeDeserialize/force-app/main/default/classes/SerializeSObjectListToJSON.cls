global with sharing class SerializeSObjectListToJSON {
    @InvocableMethod
        global static List <Results> serialize (List<Requests> requestList) {
    
            //Wrap the Results object in a List container (an extra step added to allow this interface to also support bulkification)
            List<Results> responseWrapper= new List<Results>();
    
            for (Requests curRequest : requestList) {
                List<SObject> inputSObjectList = curRequest.inputSObjectList;
                String serializedSObjectListString = JSON.serialize(inputSObjectList, true);
                JSON.deserializeUntyped(serializedSObjectListString);
                //Create a Results object to hold the return values
                Results response = new Results();
    
                //add the return values to the Results object
                response.serializedSObjectListString = serializedSObjectListString;
    
                responseWrapper.add(response);
            }
           
            return responseWrapper;
        
        }
    
        global class Results {
          @InvocableVariable
          global String serializedSObjectListString;
        
        }
        
        global class Requests {
         
          @InvocableVariable(required=true)
          global List<SObject> inputSObjectList;
    
        }
}
