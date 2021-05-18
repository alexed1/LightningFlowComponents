global inherited sharing class CreateSlackChannel {

    @InvocableMethod(label='Create Slack Channel' description='Create Slack Channels' callout=true)
    global static List<Response> execute(List<Request> requests) {
        

        List<Response> responses = new List<Response>();

        for (Request curRequest: requests ){
            String endpoint = 'https://slack.com/api/' + 'conversations.create';
            String token = curRequest.token;
            Map<String,Object> responseMap = new Map<String,Object>();
            Response curResponse = new Response();
            
            //ultimately groups should probably be created private by default. However, that creates a of confusion because they don't show up in response to api queries. So defaulting to public, at least for now.
            if (curRequest.isPrivate != true)
                curRequest.isPrivate = false;
         
            

            if (checkValidName(curRequest.channelName) != true) {
                curRequest.channelName = convertInvalidNameCandidate(curRequest.channelName);
                System.debug('resulting name is: ' + curRequest.channelName);
            }
            try {
                
                if(!Test.isRunningTest()) {
                    String body = '{"name":"'+curRequest.channelName+'","is_private":"' + curRequest.isPrivate + '"}';
                    responseMap = SlackUtils.Send(endpoint, token, body);
                    System.debug('response from create channel  is: ' + responseMap);
                } else {
                    
                    String testResponse = '{"ok": true, "channel": {"id": "CXX", "name": "endeavor"}}';
                    responseMap = (Map<String, Object>) JSON.deserializeUntyped(testResponse);
                    System.debug('response from create channel is: ' + responseMap);
                }
            } catch (Exception e) {
                System.debug(LoggingLevel.INFO,'post error: ' + e);
                throw new InvocableActionException('error Creating Slack Channel: ' + e.getMessage());
            }

            
            // throw new InvocableActionException('The proposed name did not meet these requirements: Channel names may only contain lowercase letters, numbers, hyphens, and underscores, and must be 80 characters or less. ');
                
           
            curResponse.ok = (Boolean)responseMap.get('ok');
            Map<String,Object> channelMap = (Map<String,Object>)responseMap.get('channel');
            curResponse.channelInfo.Id = (String)channelMap.get('id');
            curResponse.channelInfo.Name = (String)channelMap.get('name');
            responses.add(curResponse);
             
        }
        return responses;

    }

    global static String convertInvalidNameCandidate(String nameCandidate) {
        String pattern = '\\W+';
        String modifiedName = nameCandidate.replaceAll(pattern, '_').toLowerCase();
        return modifiedName;
    }

    global static Boolean checkValidName(String nameCandidate) {
        //validate that curRequest.Name only contains lowercase letters, numbers, hyphens, and underscores, and must be 80 characters or less 
        String nameRegex = '^[a-z0-9-]{1}[a-z0-9-]{0,20}$';
        Pattern MyPattern = Pattern.compile(nameRegex);
        Matcher MyMatcher = MyPattern.matcher(nameCandidate);
        if(MyMatcher.matches()) {
            System.debug(nameCandidate + 'is Valid');
            return true;
        }
        return false;
    }
          
  
    

    global class InvocableActionException extends Exception{}

    global class Request {

          
        @InvocableVariable(required=true)
        global String channelName;  
    
        @InvocableVariable
        global String token;
        
        @InvocableVariable
        global Boolean isPrivate; //ignored unless action = 'create'
    
        @InvocableVariable
        global String appId; //optional. use to add bot to channel, which is necessary for some management manipulation
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
