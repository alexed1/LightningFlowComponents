global with sharing class SendSMSViaMessageBird {
        @InvocableMethod
        global static List <Result> execute(List<Request> requestList) {
         

        List<Result> responses = new List<Result>();

        for (Request curRequest: requestList ){
            String endpoint = 'https://rest.messagebird.com/messages';
            String token = curRequest.token;
            Map<String,Object> responseMap = new Map<String,Object>();
            Result curResponse = new Result();
            
            try {
                
                if(!Test.isRunningTest()) {
                    String body = '{"recipients": "'+curRequest.recipients+'","originator":"' + curRequest.originator + '","body":"' +  curRequest.body + '"}';
                    System.debug ('body string is: ' + body);
                    String responseJSON = Send(endpoint, token, body);
                    curResponse.responseBody= responseJSON;
                    responseMap = (Map<String, Object>) JSON.deserializeUntyped(responseJSON);

                    System.debug('response from create channel  is: ' + responseMap);
                } else {
                    
                    String testResponse = '{"ok": true, "channel": {"id": "CXX", "name": "endeavor"}}';
                    responseMap = (Map<String, Object>) JSON.deserializeUntyped(testResponse);
                    System.debug('response from create channel is: ' + responseMap);
                }
            } catch (Exception e) {
                System.debug(LoggingLevel.INFO,'post error: ' + e);
                curResponse.errors = e.getMessage();
                
            }
                
           
            //curResponse.ok = (Boolean)responseMap.get('ok');
            //Map<String,Object> channelMap = (Map<String,Object>)responseMap.get('channel');
            //curResponse.channelInfo.Id = (String)channelMap.get('id');
            //curResponse.channelInfo.Name = (String)channelMap.get('name');
           
            
            
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
                req.setHeader('Accept', 'application/json');
                req.setHeader('Content-type', 'application/json; charset=utf-8');
                req.setHeader('Authorization', 'AccessKey ' + token);
                req.setBody(body);
                System.debug('set body to:' + body);
                System.debug('req is: ' + req);
                res = transmit(req);
                System.debug('Response is: ' + res);
                
                
                
            } catch (Exception e) {
                System.debug('error:' + e.getMessage());
                throw new InvocableActionException('Error from MessageBird: '+ e.getMessage());
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
    
            @InvocableVariable(required=true)
            global String body ;
    
            @InvocableVariable
            global String originator ;

            @InvocableVariable
            global String recipients ;
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