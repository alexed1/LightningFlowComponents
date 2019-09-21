public with sharing class GenerateFlowLink {
   
  
  
    @InvocableMethod
    public static List <Results> getLink (List<Requests> requestList) {
        System.debug('entering getLink');
        String flowName = requestList[0].flowName;
       
        String flowLink;

        String baseURL = Url.getOrgDomainUrl().toExternalForm();
        flowLink = baseURL + '/flow/' + flowName;
        
        //Create a Results object to hold the return values
        Results response = new Results();

        //add the return values to the Results object
        response.flowLink = flowLink;
        
        //Wrap the Results object in a List container (an extra step added to allow this interface to also support bulkification)
        List<Results> responseWrapper= new List<Results>();
        responseWrapper.add(response);
        return responseWrapper;
    
    }

    public class Requests {

      @InvocableVariable
      public String flowName;
        
    }
    
    public class Results {
     
      @InvocableVariable
      public String flowLink;

    }

}

