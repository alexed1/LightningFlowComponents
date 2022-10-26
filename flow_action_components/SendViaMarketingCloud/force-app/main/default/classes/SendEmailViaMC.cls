global with sharing class SendEmailViaMC {

    @InvocableMethod
    global static List <Result> execute(List<Request> requestList) {
     

        List<Result> responses = new List<Result>();

        for (Request curRequest: requestList ){

            String endpoint = curRequest.apiEndpoint + '/messaging/v1/email/messages/';


 
            if(!String.isEmpty(curRequest.messageKey)) {
                endpoint = endpoint + curRequest.messageKey;
            } else {
                System.debug('generating a message key...');
                Long timestamp = Datetime.now().getTime();
                curRequest.messageKey = String.valueOf(timestamp);
                endpoint = endpoint + curRequest.messageKey;
            }
            if(String.isEmpty(curRequest.contactKey)) {
               curRequest.contactKey=curRequest.toRecipient;
            }
            System.debug('call is:' + endpoint);
        

            String token = curRequest.token;
            Map<String,Object> responseMap = new Map<String,Object>();
            Result curResponse = new Result();

            String responseJSON;
            try {
                String body = '{"definitionKey": "'+curRequest.definitionKey+'",   "recipient": {"contactKey": "' + curRequest.contactKey + 
                '",  "to":  "' + curRequest.toRecipient + '",   "attributes": {' +
                 '"' +curRequest.mergeKey1 + '": "' + curRequest.mergeValue1 + '"' + 
                 ',"' +curRequest.mergeKey2 + '": "' + curRequest.mergeValue2 + '"' + 
                 ',"' +curRequest.mergeKey3 + '": "' + curRequest.mergeValue3 + '"' + 
                 ',"' +curRequest.mergeKey4 + '": "' + curRequest.mergeValue4 + '"' + 
                 ',"' +curRequest.mergeKey5 + '": "' + curRequest.mergeValue5 + '"' + 
                 ' } }}';

                if(!Test.isRunningTest()) {
               
                    System.debug ('url is: ' + endpoint);
                    curResponse = Send(endpoint, token, body, curResponse);
               
                    responseMap = (Map<String, Object>)JSON.deserializeUntyped(curResponse.responseBody);
                    List<Object> responseList  = (List<Object>)responseMap.get('responses');
                    Map<String,Object> mymap = (Map<String,Object>)responseList[0];
                    curResponse.messageKey = (String)mymap.get('messageKey');
                } else {
                    curResponse.responseBody = '{"ok": true, "channel": {"id": "CXX", "name": "endeavor"}}';
                }

                System.debug('errors is: ' + curResponse.errors);
                System.debug('initial responseBody is: ' + curResponse.responseBody);
            } 
            catch (Exception e) {
                System.debug(LoggingLevel.INFO,'post error: ' + e);
                curResponse.errors = e.getMessage();
                
            }
    
            responses.add(curResponse);
            
        }
        return responses;
    }

 


    global static Result  Send(String endpoint, String token, String body, Result curResponse) {
        
        String res;
        try {
            HttpRequest req = new HttpRequest();
            req.setEndpoint(endpoint);
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Authorization', 'Bearer ' + token);
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

        return curResponse;
    
    }

    global  static  string transmit(HttpRequest req) {
        Http http = new Http();
        System.debug('req is: ' + req);
        System.debug('body is: ' + req.getBody());
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
        global String token;

        @InvocableVariable(required=true)
        global String toRecipient;

        @InvocableVariable(required=true)
        global String apiEndpoint;

        @InvocableVariable
        global String contactKey ; //this points to an existing contact in MC but can be set to the current target recipient if they don't exist already

        @InvocableVariable(required=true)
        global String definitionKey ; //this is essentially the apiname of an Email Template in MC

        @InvocableVariable
        global String mergeKey1; 
        @InvocableVariable
        global String mergeValue1; 

        @InvocableVariable
        global String mergeKey2; 
        @InvocableVariable
        global String mergeValue2; 

        @InvocableVariable
        global String mergeKey3; 
        @InvocableVariable
        global String mergeValue3; 

        @InvocableVariable
        global String mergeKey4;
        @InvocableVariable
        global String mergeValue4;  

        @InvocableVariable
        global String mergeKey5;
        @InvocableVariable
        global String mergeValue5;  

        @InvocableVariable
        global String messageKey;  







    }

    global class Result {



        @InvocableVariable
        global String responseBody;

        @InvocableVariable
        global String errors;

        @InvocableVariable
        global String messageKey;
 


    }
    public class InvocableActionException extends Exception{}
}
