public with sharing class ExecuteNBAStrategy {
    public static List<Results> ExecuteNBAStrategy(List<Requests> requests) {
        String contextRecordId = requests[0].contextRecordId;
        Integer maxResults = requests[0].maxResults;
        String strategyName = requests[0].strategyName;

        ConnectApi.NBARecommendations curRec = ConnectApi.NextBestAction.executeStrategy(strategyName, maxResults, contextRecordId);
    
        //Create a Results object to hold the return values
        Results response = new Results();

        //add the return values to the Results object
        response.flowLink = flowLink;
        
        //Wrap the Results object in a List container (an extra step added to allow this interface to also support bulkification)
        List<Results> responseWrapper= new List<Results>();
        responseWrapper.add(response);
        return responseWrapper;
    
    }


    public class InvocableErrorException extends Exception{}


    public class Requests {

      @InvocableVariable
      public String contextRecordId;

      @InvocableVariable
      public String strategyName;

      @InvocableVariable
      public Integer maxResults;
    }
    
    public class Results {
     
      @InvocableVariable
      public ConnectApi.NBARecommendations curRecs;

    }


}
