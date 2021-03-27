public with sharing class LaunchFlowDynamically {

   @InvocableMethod
    public static List <Results> launch (List<Requests> requestList) {
    System.debug('entering autolaunchFlow');
    List<Results> responseWrapper= new List<Results>();

    for(Requests curRequest : requestList) {
      String flowName = curRequest.flowName;
      String namespace = curRequest.namespace;
      Boolean useFutureLaunch = curRequest.useFutureLaunch || false;
      Map<String,String> inputVariables = new Map<String,String>();
      inputVariables = generateParam(curRequest.param1Name, curRequest.param1Value,inputVariables);
      inputVariables = generateParam(curRequest.param2Name, curRequest.param2Value,inputVariables);
      inputVariables = generateParam(curRequest.param3Name, curRequest.param3Value,inputVariables);
      System.debug('inputVariables  is: ' + inputVariables);
       //Create a Results object to hold the return values

       Results response = new Results();

       if (! curRequest.useFutureLaunch)
         response = launchImmediate(namespace, flowName, inputVariables);
       else {
         launchFuture(namespace, flowName, inputVariables);
       }
   
       responseWrapper.add(response);
      }
  
    return responseWrapper;
    
   }
   
   private static Results launchImmediate (String namespace, String flowName, Map<String,String> inputVariables) {
      Results response = new Results();
      try {
          Flow.Interview curInterview =  Flow.Interview.createInterview(namespace, flowName, inputVariables);
          curInterview.start();
        }
        catch (InvocableErrorException ex) {
                response.IsSuccess = false;
                response.ErrorMessage = ex.getMessage();
        }  
      return response;

   }

   @future(callout=true)
   private static void launchFuture (String namespace, String flowName, Map<String,String> inputVariables) {
      Results response = new Results();
     
      Flow.Interview curInterview =  Flow.Interview.createInterview(namespace, flowName, inputVariables);
      curInterview.start();
      
 }

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

      @InvocableVariable
      public Boolean useFutureLaunch;
        
        
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

    public class InvocableErrorException extends Exception{}
}