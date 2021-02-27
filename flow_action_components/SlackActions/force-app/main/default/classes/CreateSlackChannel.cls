global inherited sharing class CreateSlackChannel {

    @InvocableMethod(label='Create Slack Channel' description='Create Slack Channels' callout=true)
    global static List<Response> execute(List<Request> requests) {
        

        List<Response> responses = new List<Response>();

        for (Request curRequest: requests ){
            String endpoint = 'https://slack.com/api/' + 'conversations.create';
            String body = '{"name":"'+curRequest.channelName+'","is_private":"' + curRequest.isPrivate + '"}';
            String token = curRequest.token;
            Map<String,Object> responseMap = new Map<String,Object>();
            Response curResponse = new Response();

         
            

            if (checkValidName() == true) {
                try {
                    
                    if(!Test.isRunningTest()) {
                        responseMap = SlackUtils.Send(endpoint, token, body);
                        System.debug('response from get slack channel list is: ' + responseMap);
                    } else {
                        
                        String testResponse = '{"ok": true, "channel": {"id": "CXX", "name": "endeavor"}}';
                        responseMap = (Map<String, Object>) JSON.deserializeUntyped(testResponse);
                        System.debug('response from get slack channel list is: ' + responseMap);
                    }
                } catch (Exception e) {
                    System.debug(LoggingLevel.INFO,'post error: ' + e);
                }

            } else {
                throw new InvocableActionException('The proposed name did not meet these requirements: Channel names may only contain lowercase letters, numbers, hyphens, and underscores, and must be 80 characters or less. ');
            }    
            curResponse.ok = (Boolean)responseMap.get('ok');
            Map<String,Object> channelMap = (Map<String,Object>)responseMap.get('channel');
            curResponse.channelInfo.Id = (String)channelMap.get('id');
            curResponse.channelInfo.Name = (String)channelMap.get('name');
            responses.add(curResponse);
             
        }
        return responses;

    }

    global static Boolean checkValidName() {
        //validate that curRequest.Name only contains lowercase letters, numbers, hyphens, and underscores, and must be 80 characters or less 
        return true;
    }
          
  
    

    global class InvocableActionException extends Exception{}

    global class Request {

          
        @InvocableVariable(required=true)
        global String channelName;  
    
        @InvocableVariable
        global String token;
        
        @InvocableVariable
        global Boolean isPrivate; //ignored unless action = 'create'
    
    }

    global class Response {

        global Response() {
            channelInfo = new SlackChannel();
        }

        @invocableVariable
        global Boolean ok;

        @invocableVariable
        global String error;

        @invocableVariable
        global SlackChannel channelInfo;
    }
}
