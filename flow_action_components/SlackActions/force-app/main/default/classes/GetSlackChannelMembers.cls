global inherited sharing class GetSlackChannelMembers {
    @InvocableMethod(label='Get Slack Channel Members List' description='Get Slack Channel Members List' callout=true)
    global static List<Response> execute(List<Request> requests) {
        
        List<Response> responses = new List<Response>();

        for (Request curRequest: requests ){

            Response curResponse = new Response();
            List<String> nameList = new List<String>(); //these list structures are easier to work with when it comes to screen UI
            List<String> idList = new List<String>();
            String body =  'token='+curRequest.token + '&channel=' + curRequest.channelId;

            String response; 
                
            if(!Test.isRunningTest()) {
                response = SlackUtils.PrepareAndSend(body, 'conversations.members');             
            } else {             
                response = sampleResponse; 
            }



            List<SlackConversation> fullConversationDetails = new List<SlackConversation>(); 
            SlackResponse_GetChannelMembers curSlackResponse = (SlackResponse_GetChannelMembers) JSON.deserialize(response, SlackResponse_GetChannelMembers.class);
            if(curSlackResponse.ok == 'true') {
                curResponse.ok = true;
                System.debug('serialized return is: ' + curSlackResponse.members);
                for (String curMemberId : curSlackResponse.members) {
                    idList.add(curMemberId);         
                }

            } 
      
            curResponse.idList = idList;
            System.debug('curResponse.idList is: ' + curResponse.idList);
            responses.add(curResponse);
             
        }
        System.debug('member list is: ' + responses);
        return responses;

    }
    final static String sampleResponse = '{'
    + ' "ok": true,'
    +' "members": ['
            +' "U023BECGF",'
            +' "U061F7AUR",'
            +' "W012A3CDE"'
        +'],'
        +'"response_metadata": {'
            +'"next_cursor": "e3VzZXJfaWQ6IFcxMjM0NTY3fQ=="'
        +'}'
    +'}';
    
  
    

    global class InvocableActionException extends Exception{}

    global class Request {
     
        @InvocableVariable
        global String token;

        @InvocableVariable
        global String channelId;
    
    }

    global class Response {

        global Response() {
            idList = new List<String>();
        }

        @invocableVariable
        global boolean ok; 
        
        @invocableVariable
        global List<String> idList;


    }
}