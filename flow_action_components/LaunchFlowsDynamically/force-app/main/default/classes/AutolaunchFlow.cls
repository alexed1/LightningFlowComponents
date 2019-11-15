public with sharing class AutolaunchFlow {

   @InvocableMethod
    public static List <Results> autolaunchFlow (List<Requests> requestList) {
    System.debug('entering autolaunchFlow');
    String flowName = requestList[0].flowName;
    String namespace = requestList[0].namespace;
    Map<String,String> inputVariables = new Map<String,String>();
    inputVariables = generateParam(requestList[0].param1Name, requestList[0].param1Value,inputVariables);
    inputVariables = generateParam(requestList[0].param2Name, requestList[0].param2Value,inputVariables);
    inputVariables = generateParam(requestList[0].param3Name, requestList[0].param3Value,inputVariables);
    System.debug('inputVariables  is: ' + inputVariables);
     //Create a Results object to hold the return values
    Results response = new Results();

    try {
       Flow.Interview curInterview =  Flow.Interview.createInterview(namespace, flowName, inputVariables);
       curInterview.start();
    }
    catch (InvocableErrorException ex) {
            response.IsSuccess = false;
            response.ErrorMessage = ex.getMessage();
        }  
    

   

    //add the return values to the Results object
    //Wrap the Results object in a List container (an extra step added to allow this interface to also support bulkification)
    List<Results> responseWrapper= new List<Results>();
    responseWrapper.add(response);
    return responseWrapper;
    
    
    }
   public class InvocableErrorException extends Exception{}

   public static Map<String,String> generateParam(String name, String value, Map<String,String> inputVariables) {
        //if one is present but the other is null, throw error
        //neither is present, return empty string
        //else return concatenation
        if ((name != null && value == null) || (name== null && value != null))
          throw new InvocableErrorException('In the call to GenerateFlowLink, either a param name was passed without a value, or a value was passed without a name');
        if (name == null && value == null)
          return inputVariables;
        
        inputVariables.put(name, value);
        return inputVariables;
        

    }


    public  class Requests {
     @InvocableVariable
      public String flowName;

      @InvocableVariable
      public String namespace;
 
      @InvocableVariable
      public String param1Name;

      @InvocableVariable
      public String param1Value;

      @InvocableVariable
      public String param2Name;

      @InvocableVariable
      public String param2Value;

      @InvocableVariable
      public String param3Name;

      @InvocableVariable
      public String param3Value;
        
        
    }
    
    public  class Results {
        public Results() {
            isSuccess=true;
        }
     
      @InvocableVariable
      public Boolean isSuccess;

      @InvocableVariable
      public String errorMessage;
    }
}