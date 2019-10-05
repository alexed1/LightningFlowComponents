public with sharing class EvaluateFormula {
   
    @InvocableMethod
    public static List <Results> evaluate (List<Requests> requestList) {
        System.debug('entering Evaluate Formula');


        String formulaString = requestList[0].formulaString;
        String contextDataString = requestList[0].contextDataString;
       
        //the parser currently can't handle a null value
        if (contextDataString == null)
            contextDataString = '[]';

        String result = FormulaEvaluator.parseFormula(formulaString, contextDataString);
       
	 
        //Create a Results object to hold the return values
        Results response = new Results();
        response.result = result;

        //Wrap the Results object in a List container (an extra step added to allow this interface to also support bulkification)
        List<Results> responseWrapper= new List<Results>();
        responseWrapper.add(response);
        System.debug('response is: '+ response);
        System.debug('responseWrapper is: '+ responseWrapper);

        return responseWrapper;
    
    }

    

    public  class Requests {
       
      @InvocableVariable
      public String formulaString;

       @InvocableVariable
      public String contextDataString;
        
    }
    
    public  class Results {

     
      @InvocableVariable
      public String result;

        }
}
