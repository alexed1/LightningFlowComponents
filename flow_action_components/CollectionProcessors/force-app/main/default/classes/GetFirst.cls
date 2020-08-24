global with sharing class GetFirst {
  
  
    @InvocableMethod
    global static List <Results> execute (List<Requests> requestList) {
        System.debug('entering getFirst');
        List<Results> responseWrapper = new List<Results>();
        for (Requests curRequest : requestList) {
          List<SObject>  inputCollection = curRequest.inputCollection;
          Boolean enforceSingle = curRequest.enforceSingleMember;
         
          //TODO if enforceSingle is set, throw an error if count of input collection is not 1 
          SObject  outputMember = inputCollection[0];
          
          //Create a Results object to hold the return values
          Results response = new Results();
  
          //add the return values to the Results object
          response.outputMember = outputMember;
  
          //Wrap the Results object in a List container (an extra step added to allow this interface to also support bulkification)
     
          responseWrapper.add(response);
        }
      
        return responseWrapper;
    
    }

    global class Requests {
      @InvocableVariable(required=true)
      global List<SObject> inputCollection;

      @InvocableVariable
      global Boolean enforceSingleMember; //not yet implemented
        
    }
    
    global class Results {
     
      @InvocableVariable
      global SObject outputMember;

    }

}