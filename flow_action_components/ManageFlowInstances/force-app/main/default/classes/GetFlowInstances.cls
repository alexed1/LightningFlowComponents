public with sharing class GetFlowInstances {
    public GetFlowInstances() {

    }

     @InvocableMethod
    public static List<Results> GetFlowInstanceData(List<Requests> requests) {
       // String contextRecordId = requests[0].contextRecordId;
        //Integer maxResults = requests[0].maxResults;
        //String strategyName = requests[0].strategyName;

  
        List<FlowInterview> curPausedFlows =  [ SELECT 
                    Id, InterviewLabel, CurrentElement, Guid, 
                    Name, OwnerId, PauseLabel, WasPausedFromScreen
                FROM FlowInterview 
                WHERE Name != 'foo' ];
        System.debug('curPausedFlows is: ' + curPausedFlows);



        //Create a Results object to hold the return values
        Results response = new Results();

        //add the return values to the Results object
        response.curPausedFlows = curPausedFlows;
        
        //Wrap the Results object in a List container (an extra step added to allow this interface to also support bulkification)
        List<Results> responseWrapper= new List<Results>();
        responseWrapper.add(response);
        return responseWrapper;
    
    }

  


    public class InvocableErrorException extends Exception{}


    public class Requests {

      @InvocableVariable
      public String foo;

      
    }
    
    public class Results {
     
      @InvocableVariable
      public List<FlowInterview> curPausedFlows;

    }

}
