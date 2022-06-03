global with sharing class PostMessageToWebEx {


    @InvocableMethod
    global static List <Result> execute(List<Request> requestList) {
     

    List<Result> responses = new List<Result>();

    for (Request curRequest: requestList ){
        String endpoint = 'https://webexapis.com/v1/messages';
       // String endpoint = 'https://eofl6ii0dprx77q.m.pipedream.net';
        String token = curRequest.token;
        Map<String,Object> responseMap = new Map<String,Object>();
        Result curResponse = new Result();
        
        try {
            
            if(!Test.isRunningTest()) {
                String body = '{"roomId": "'+curRequest.roomId+'","text":"' + curRequest.text + '"}';
                System.debug ('body string is: ' + body);
                String responseJSON = Send(endpoint, token, body);
                curResponse.responseBody= responseJSON;
                responseMap = (Map<String, Object>) JSON.deserializeUntyped(responseJSON);

                System.debug('response  is: ' + responseMap);
            } else {
                
                String testResponse = '{"ok": true, "channel": {"id": "CXX", "name": "endeavor"}}';
                responseMap = (Map<String, Object>) JSON.deserializeUntyped(testResponse);
                System.debug('response  is: ' + responseMap);
            }
        } catch (Exception e) {
            System.debug(LoggingLevel.INFO,'post error: ' + e);
            curResponse.errors = e.getMessage();
            
        }
            
       
        
        
        responses.add(curResponse);
         
    }
    return responses;
}

    global static String  Send(String endpoint, String token, String body) {
        
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
            System.debug('Response is: ' + res);
            
            
            
        } catch (Exception e) {
            System.debug('error:' + e.getMessage());
            throw new InvocableActionException('Error: '+ e.getMessage());
        }

        return res;
    
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

        @InvocableVariable
        global String text ;

        @InvocableVariable
        global String roomId ;
    }

    global class Result {

        public Result() {
            
        }

        @InvocableVariable
        global String responseBody;

        @InvocableVariable
        global String errors;



    }
    public class InvocableActionException extends Exception{}
}
