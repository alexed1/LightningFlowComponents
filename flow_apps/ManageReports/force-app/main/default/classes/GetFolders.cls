global with sharing class GetFolders {

    @AuraEnabled
    global static Result execute(String selectedFolderId, String namedCredential) {
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        HttpResponse response = new HttpResponse();
        Result curResult = new Result();
        String url;
        if(selectedFolderId != null && selectedFolderId != '') {
            url = 'callout:' + namedCredential +'/services/data/v58.0/folders/' + selectedFolderId + '/children';

        } else {
            url = 'callout:' + namedCredential +'/services/data/v58.0/folders/';
        }
      
        if(!Test.isRunningTest()) {
            response = ManagerReportsUtils.Send(url );  
            System.debug('response body string is: ' + response.getBody());            
            if(response.getStatusCode() != 200) {
                throw new InvocableActionException(response.getBody());
            }
            curResult.data = response.getBody();
               
        } else {               
            String testResponse ='foo';
            response.setBody(testResponse);
        
        }
        System.debug('rreturrning curRResult: ' + curResult);
        return curResult;
    }

    @InvocableMethod(label='Get Folders' description='Get Folders')
    global static List<Result> batchExecute (List<Request> requestList) {
        
        System.debug('entering Get Folders');
        List<Result> results =  new List<Result>();
        Result curResult = new Result();
        for (Request curRequest: requestList) {
           curResult = execute(curRequest.selectedFolderId, curRequest.namedCredential);
           results.add(curResult);
        }
        return results;
    }



    global class Request {
        

        @InvocableVariable(description='Named Credential' )
        global String namedCredential;

        @InvocableVariable(description='Base Folder ID. If null, will fetch the root folders. If provided, fetches the child folders' )
        global String selectedFolderId;

    }
    
    global class Result {

        @InvocableVariable
        global String data;

        @InvocableVariable
        global String errors;


 
    }
    public class InvocableActionException extends Exception{}

}