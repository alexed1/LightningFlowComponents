public without sharing class UnlockRecord { //Need without sharing in order to allow non-admin users to perform this action
    //todo get show toast showing up when it installs as a package
    
    @InvocableMethod
    public static List<Response> Unlock(List<Request> requests) {
        List<Response> responseWrapper= new List<Response>();
        
        for (Request i:  requests) { //Bulkify input - especially if used with Trigger,scheduled path 
            String recordId = i.recordId;
            
            Approval.UnlockResult unlockResult = Approval.unlock(recordId);
            
            //Create a Results object to hold the return values
            Response response = new Response();
            
            //add the return values to the Results object
            response.isSuccess = unlockResult.isSuccess();
            response.errors = packErrorString(unlockResult);
            
            //Wrap the Results object in a List container (an extra step added to allow this interface to also support bulkification)
            responseWrapper.add(response);
            
        }
        return responseWrapper;
    
    }

    public static String packErrorString(Approval.UnlockResult unlockResult) {
        String errorString = '';
        for(Database.Error err : unlockResult.getErrors()) {
            errorString = errorString + (' The following error has occurred.');                   
            errorString = errorString + (' ' + err.getStatusCode() + ': ' + err.getMessage());
        }
        return errorString;

    }



    public class InvocableErrorException extends Exception{}


    public class Request {

      @InvocableVariable
      public String recordId;
      
    }
    
    public class Response {
     
       @invocableVariable
        public Boolean isSuccess; 
        
        @invocableVariable
        public String errors;
    }
    public class InvocableActionException extends Exception {}

}