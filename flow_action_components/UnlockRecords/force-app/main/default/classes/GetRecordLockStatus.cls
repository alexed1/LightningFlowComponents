public with sharing class GetRecordLockStatus {
   //todo get show toast showing up when it installs as a package
    
    @InvocableMethod
    public static List<Response> GetStatus(List<Request> requests) {
        String recordId = requests[0].recordId;

        Boolean lockStatus = Approval.isLocked(recordId);
        
        
        
        //Create a Results object to hold the return values
        Response response = new Response();

        //add the return values to the Results object
        response.locked = lockStatus;
     
        

        
        //Wrap the Results object in a List container (an extra step added to allow this interface to also support bulkification)
        List<Response> responseWrapper= new List<Response>();
        responseWrapper.add(response);
        return responseWrapper;
    
    }

  



    public class InvocableErrorException extends Exception{}


    public class Request {

      @InvocableVariable
      public String recordId;

      
    }
    
    public class Response {
     
       @invocableVariable
        public Boolean locked; 
        

    }
    public class InvocableActionException extends Exception {}

}
