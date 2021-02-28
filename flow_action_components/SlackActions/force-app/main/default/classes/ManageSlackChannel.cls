global inherited sharing class ManageSlackChannel {
     
    @InvocableMethod(label='Manage Slack Channel' description='Create & Manage Slack Channels' callout=true)
    global static List<Response> execute(List<Request> requests) {
        
        String apiName;
        List<Response> responses = new List<Response>();

        for (Request curRequest: requests ){
            String endpoint = 'https://slack.com/api/';
            String body = '';
            String token = curRequest.token;


            Response curResponse = new Response();

            switch on curRequest.action {
                when 'archiveChannel' {	
                    endpoint = endpoint + 'conversations.archive';
                    body = '{"channel":"'+curRequest.channelId + '"}';
                }	
                when 'inviteUser' {	
                    endpoint = endpoint + 'conversations.invite';
                    System.debug('userlist is: ' + curRequest.userList);
                    body = '{"channel":"'+curRequest.channelId + '","users":"' + curRequest.userList + '"}';
                }
                when 'kickUser' {		
                    endpoint = endpoint + 'conversations.kick';
                    //TODO need to validate that only one value was selected in the dual list box if this is the action
                    body = '{"channel":"'+curRequest.channelId + '","user":"' + curRequest.userId + '"}';
               
                }
                when else {		 
                    throw new InvocableActionException('Manage Slack Channels was passed an unsupported action value');
                }
            }  
            
            Map<String,Object> responseMap = new Map<String,Object>();
            if(!Test.isRunningTest()) {
                responseMap = SlackUtils.Send(endpoint, token, body);
                System.debug('response from get slack channel list is: ' + responseMap);
            } else {
                
                String testResponse = getTestResponse(curRequest.action); //'{"ok": true, "channel": {"id": "CXX", "name": "endeavor"}}';
                responseMap = (Map<String, Object>) JSON.deserializeUntyped(testResponse);
                System.debug('response from get slack channel list is: ' + responseMap);
            }


            curResponse.ok = (Boolean)responseMap.get('ok');
            curResponse.error = (String)responseMap.get('error');
            System.debug('curResponse is: ' + curResponse);
            responses.add(curResponse);
          
        }
        return responses;
    }

    private static string getTestResponse(String actionName) {
            switch on actionName {
                when 'archiveChannel' {	
                    return '{"ok": true}';
                }
            }
            return '';
    }

    global class InvocableActionException extends Exception{}

    global class Request {
        @InvocableVariable
        global String userList; //comma separated list of user IDs. Up to 1000

        @InvocableVariable
        global String userId; //comma separated list of user IDs. Up to 1000
        
        @InvocableVariable
        global String action; //{archive,kickuser,inviteUser}
          
        @InvocableVariable
        global String channelId;  
        
        @InvocableVariable
        global String token;

        
    }

    global class Response {

        @invocableVariable
        global Boolean ok;

        @invocableVariable
        global String error;
    }
  }