global inherited sharing class SlackUtils {
    

    global static String PrepareAndSend(String body, String apiName){
        String endpoint = 'https://slack.com/api/' + apiName;     
        String response;
        try {
            response = SlackUtils.SendUsingUUEncoding(endpoint, body);
            
        } catch (Exception e) {
            System.debug(LoggingLevel.INFO,'post error: ' + e);
            throw new InvocableActionException(e.getMessage());
        }
        return response;
    }


    global static String SendUsingUUEncoding(String endpoint,  String body) {
        try {
            HttpRequest req = new HttpRequest();
            req.setEndpoint(endpoint);
            req.setMethod('POST');
            req.setHeader('Content-type', 'application/x-www-form-urlencoded');
            req.setBody(body);
            String result = transmit(req);
            return result;
            
        } catch (Exception e) {
           throw new InvocableActionException('Something went wrong calling Slack: ' + e.getMessage());
        }
    }


    global static Map<String,Object>  Send(String endpoint, String token, String body) {
        Map<String,Object> responseMap = new Map<String,Object>();

        try {
            HttpRequest req = new HttpRequest();
            req.setEndpoint(endpoint);
            req.setMethod('POST');
            req.setHeader('Content-type', 'application/json; charset=utf-8');
            req.setHeader('Authorization', 'Bearer ' + token);
            req.setBody(body);
            String res = transmit(req);
            
            responseMap = (Map<String, Object>) JSON.deserializeUntyped(res);
            if(responseMap.get('ok') == true) {
                return responseMap;
               
            } else {
                throw new InvocableActionException('Error from Slack: '+ (String)responseMap.get('error'));
            }
            
        } catch (Exception e) {
            responseMap.put('error', e.getMessage());
            throw new InvocableActionException('Error from Slack: '+ (String)responseMap.get('error'));
        }
    }

    private  static  string transmit(HttpRequest req) {
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


    global class InvocableActionException extends Exception{}
}
