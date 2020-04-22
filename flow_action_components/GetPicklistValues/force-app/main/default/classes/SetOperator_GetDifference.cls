public with sharing class SetOperator_GetDifference {
 
  
    @InvocableMethod
    public static List <Results> getSetDifference(List<Requests> requestList) {
        System.debug('entering getSetDifference');
               
        Results response = new Results();
        List<Results> responseWrapper= new List<Results>();

        //response.picklistValues = picklistStringVals;
        responseWrapper.add(response);
        return responseWrapper;
    
    }

    public class Requests {
      @InvocableVariable(required=true)
      public String placeholder;


        
    }
    
    public class Results {
     
      @InvocableVariable
      public List<String> placeholder2;
    }

}