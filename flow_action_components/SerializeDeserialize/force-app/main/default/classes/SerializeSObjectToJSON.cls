global with sharing class SerializeSObjectToJSON {
  
        @InvocableMethod
        global static List <Results> serialize (List<Requests> requestList) {
            System.debug('entering object json serialize');
    
            //Wrap the Results object in a List container (an extra step added to allow this interface to also support bulkification)
            List<Results> responseWrapper= new List<Results>();
    
            for (Requests curRequest : requestList) {
                SObject inputSObject = curRequest.inputSObject;
                String serializedSObjectString = JSON.serialize(inputSObject);
    
                //Create a Results object to hold the return values
                Results response = new Results();
    
                //add the return values to the Results object
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
         
          @InvocableVariable(required=true)
          global SObject inputSObject;
    
        }
    
    }
    