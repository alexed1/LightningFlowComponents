global with sharing class GenerateMarketingCloudToken {
    @InvocableMethod
    global static List <Result> execute(List<Request> requestList) {
     

        List<Result> responses = new List<Result>();

        for (Request curRequest: requestList ){

            String endpoint = curRequest.authorizationURL;
            String url = endpoint;
            System.debug('endpoint is:' + url);

            Result curResponse = new Result();
            String responseJSON;

            String body = '{"grant_type": "client_credentials","client_id":"' +  + curRequest.clientId + '",   "client_secret":"' + curRequest.clientSecret +
            '",   "scope":"' + curRequest.scope + '",   "account_id":"' + curRequest.accountId + '" }';

            System.debug ('url is: ' + url);

            try {
                
                if(!Test.isRunningTest()) {
                   
                    curResponse = Send(url, body, curResponse);
                    curResponse.responseObject = MCAuthorizationResponse.parse(curResponse.responseBody);
                } else {
                    
                    String testResponse = '{"ok": true, "channel": {"id": "CXX", "name": "endeavor"}}';
                }
            } catch (Exception e) {
                System.debug(LoggingLevel.INFO,'post error: ' + e);
                curResponse.errors = e.getMessage();
                
            }
             
            System.debug('errors is: ' + curResponse.errors);
            System.debug('initial responseBody is: ' + curResponse.responseBody);
            responses.add(curResponse);
            
        }
        return responses;
    }

 


    global static Result  Send(String endpoint, String body, Result curResponse) {
        
        String res;
        try {
            HttpRequest req = new HttpRequest();
            req.setEndpoint(endpoint);
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Accept-Encoding', 'gzip, deflate, br');
            req.setHeader('Accept', '*/*');

            req.setBody(body);
            System.debug('set body to:' + body);
            System.debug('req is: ' + req);
            res = transmit(req);
           
           curResponse.responseBody = res;
            
            
        } catch (Exception e) {
            System.debug('error:' + e.getMessage());
            //throw new InvocableActionException('Error: '+ e.getMessage());
            curResponse.errors=e.getMessage();
        }
        System.debug('raw Response is: ' + curResponse);
        return curResponse;
    
    }

    global  static  string transmit(HttpRequest req) {
        Http http = new Http();
        if(!Test.isRunningTest()){
            HttpResponse res = http.send(req);
            System.debug('made it back: ' + res.getBody());
            return res.getBody();
        } else {
            return '{"ok":true}';
        }
    }



    

    global class Request {
      

        @InvocableVariable(required=true)
        global String clientId;

        @InvocableVariable(required=true)
        global String clientSecret;

        @InvocableVariable(required=true)
        global String accountId ;  

        @InvocableVariable(required=true)
        global String scope ;  

        @InvocableVariable(required=true)
        global String authorizationURL ;  

    }

    global class Result {


        @InvocableVariable
        global MCAuthorizationResponse responseObject;

        @InvocableVariable
        global String responseBody;

        @InvocableVariable
        global String errors;





    }
    public class InvocableActionException extends Exception{}
}
