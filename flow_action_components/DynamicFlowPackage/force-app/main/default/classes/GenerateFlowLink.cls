public with sharing class GenerateFlowLink {
   
  
  
    @InvocableMethod
    public static List <Results> getLink (List<Requests> requestList) {
        System.debug('entering getLink');
        String flowName = requestList[0].flowName;
       
        String flowLink;

        String baseURL = Url.getOrgDomainUrl().toExternalForm();
        flowLink = baseURL + '/flow/' + flowName;
        
        String params = '';
        params = generateParam(requestList[0].param1Name, requestList[0].param1Value);
        System.debug('params is: ' + params);
        String nextParam = generateParam(requestList[0].param2Name, requestList[0].param2Value);
        if (nextParam != '')
          params = params + '&' + nextParam;
        System.debug('params is: ' + params);
        nextParam = generateParam(requestList[0].param3Name, requestList[0].param3Value);
        if (nextParam != '')
          params = params + '&' + nextParam;
        System.debug('params is: ' + params);
        if (params != '')
          flowLink = flowLink + '?' + params;

        //Create a Results object to hold the return values
        Results response = new Results();

        //add the return values to the Results object
        response.flowLink = flowLink;
        
        //Wrap the Results object in a List container (an extra step added to allow this interface to also support bulkification)
        List<Results> responseWrapper= new List<Results>();
        responseWrapper.add(response);
        return responseWrapper;
    
    }

    public static String generateParam(String name, String value) {
        return name + '=' + value;
    }

    public class Requests {

      @InvocableVariable
      public String flowName;

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
    
    public class Results {
     
      @InvocableVariable
      public String flowLink;

    }

}
