//not currently used
global with sharing class GetFlowMetadata {



    @InvocableMethod
    global static List <Result> execute(List<Request> requestList) {
     
    final String TEST_SESSION_ID = 'TEST_SESSION_ID';
    List<Result> responses = new List<Result>();
    for (Request curRequest: requestList ){
        try {

           String sessionId = Test.isRunningTest() ? TEST_SESSION_ID : Page.usf3__GenerateSessionIdForLWC.getContent().toString();

            
            FlowDefinitionView curFlowDef = new FlowDefinitionView();
            curFlowDef = [SELECT Id FROM FlowDefinitionView WHERE ApiName = :curRequest.flowName];
            System.debug('retrievedFlow is: ' + curFlowDef);

            String baseurl = 'https://customization-agility-5482-dev-ed.lightning.force.com';
            String endpoint =  '/services/data/v55.0/tooling/sobjects/Flow/' + curFlowDef.Id;
           // String params = 'maxResults=' + maxResultsString + '&orderBy=' + orderBy + '&singleEvents=true&timeMin='+ startTime;

                
            String url = baseurl + endpoint ;
            System.debug('call is:' + url);
        
            Map<String,Object> responseMap = new Map<String,Object>();
            Result curResponse = new Result();
            String responseJSON;
            Result curResult = new Result();
            
                
            if(!Test.isRunningTest()) {
                System.debug ('url is: ' + url);
                curResult = Send(url, curResponse, sessionid);       
                
            } else {
                    
                String testResponse = '{"ok": true, "channel": {"id": "CXX", "name": "endeavor"}}';
                responseMap = (Map<String, Object>) JSON.deserializeUntyped(testResponse);
                System.debug('response  is: ' + responseMap);
                curResult.responseBody = testResponse;
            }
            
            if (String.isEmpty(curResponse.errors)) {
                responseJSON = curResult.responseBody;
                System.debug('initial responseJSON is: ' + responseJSON);
                responseJSON = responseJSON.replace('"dateTime"', '"startTime"');
                System.debug('modified responseJSOn is: ' + responseJSON);
                curResponse.responseBody= responseJSON;
                //(GoogleCalendarEvent) System.JSON.deserialize(json, GoogleCalendarEvent.class);
                usf3.MetadataService.Flow curFlow  = new usf3.MetadataService.Flow();
                curFlow = (usf3.MetadataService.Flow)System.JSON.deserialize(responseJSON, usf3.MetadataService.Flow.class);
                System.debug('flow parsed out is: ' + curFlow);
    
    
                curResponse.flowMetadata=curFlow;
            }
            
            responses.add(curResponse);

        //Google returns start times with the key 'datetime', which causes problems in Salesforce, so we map it to something more useful
        } catch (Exception e) {
            System.debug(LoggingLevel.INFO,'post error: ' + e);
            Result curResponse = new Result();
            curResponse.errors = e.getMessage();
            responses.add(curResponse);
            
        }
         
    }
    return responses;
}


    global static Result  Send(String endpoint, Result curResponse, String sessionId) {
        
        HttpResponse res;
        try {
            HttpRequest req = new HttpRequest();
            req.setEndpoint(endpoint);
            req.setMethod('GET');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Authorization', 'Bearer ' + sessionId); 
            req.setHeader('Accept-Encoding', 'gzip, deflate, br');
            req.setHeader('Accept', '*/*');

            System.debug('request is: ' + req);
            res = transmit(req);

            if(res.getStatusCode() != 200) {
                throw new InvocableActionException(res.getBody());
            }
            curResponse.responseBody = res.getBody();
            
        } catch (Exception e) {
            System.debug('error:' + e.getMessage());
            //throw new InvocableActionException('Error: '+ e.getMessage());
            curResponse.errors=e.getMessage();
        }

        return curResponse;
    
    }

    global  static  HttpResponse transmit(HttpRequest req) {
        Http http = new Http();
        System.debug('req is: ' + req);
        System.debug('body is: ' + req.getBody());
        if(!Test.isRunningTest()){
            HttpResponse res = http.send(req);
            System.debug('made it back: ' + res);
            System.debug('made it back: ' + res.getBody());
            while (res.getStatusCode() == 302) {
                req.setEndpoint(res.getHeader('Location'));
                res = new Http().send(req);
                System.debug('made it back: ' + res);
                System.debug('made it back: ' + res.getBody());
            }
            return res;
        } else {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setBody('{"ok":true}');
            return res;
        }
    }
    

    global class Request {
      

        @InvocableVariable(required=true)
        global String flowName;

    }

    global class Result {



        @InvocableVariable
        global usf3.MetadataService.Flow flowMetadata;

        @InvocableVariable
        global String errors;

        @InvocableVariable
        global String responseBody; 

    }
    public class InvocableActionException extends Exception{}
}
