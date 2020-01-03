global with sharing class GetFirst {
  
  
    @InvocableMethod
    global static List <Results> execute (List<Requests> requestList) {
        System.debug('entering getFirst');
        List<SObject>  inputCollection = requestList[0].inputCollection;
        Boolean enforceSingle = requestList[0].enforceSingleMember;
       
        //TODO if enforceSingle is set, throw an error if count of input collection is not 1 
        SObject  outputMember = inputCollection[0];
        
        //Create a Results object to hold the return values
        Results response = new Results();

        //add the return values to the Results object
        response.outputMember = outputMember;

        //Wrap the Results object in a List container (an extra step added to allow this interface to also support bulkification)
        List<Results> responseWrapper= new List<Results>();
        responseWrapper.add(response);
        return responseWrapper;
    
    }

    global class Requests {
      @InvocableVariable(required=true)
      public List<SObject> inputCollection;

      @InvocableVariable
      public Boolean enforceSingleMember; //not yet implemented
        
    }
    
    global class Results {
     
      @InvocableVariable
      public SObject outputMember;

    }

}
