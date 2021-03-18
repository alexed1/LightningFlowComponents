global inherited sharing class GetSlackChannelList {

    @InvocableMethod(label='Get Slack Channel List' description='Get Slack Channel List' callout=true)
    global static List<Response> execute(List<Request> requests) {
        
        List<Response> responses = new List<Response>();

        for (Request curRequest: requests ){

            Response curResponse = new Response();
            List<String> nameList = new List<String>(); //these list structures are easier to work with when it comes to screen UI
            List<String> idList = new List<String>();
            String body =  'token='+curRequest.token+ '&exclude_archived=true';
            String response;
            if(!Test.isRunningTest()){
                System.debug('test isRunning test is false');
                response = SlackUtils.PrepareAndSend(body, 'conversations.list');
                System.debug('1response from get slack channel list is: ' + response);
            } else {
                response = GetSlackChannelListTest.channelList;
                System.debug('response from get slack channel list is: ' + response);
            }
           
        

            Map<String,Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(response);
            
            List<SlackConversation> fullConversationDetails = new List<SlackConversation>(); 

            if(responseMap.get('ok') == true) {
                List<Object> channelObjects = (List<Object>)responseMap.get('channels');

                
               
                for (Object curChannel : channelObjects) {
                    String json_instance = Json.serialize(curChannel);
                    Map<String,Object> channelResponseMap = (Map<String, Object>)JSON.deserializeUntyped(json_instance);
                   
                    nameList.add((String)channelResponseMap.get('name'));
                    idList.add((String)channelResponseMap.get('id'));

                    
                    fullConversationDetails.add(populateSlackConversationObject(channelResponseMap));

             
                }

            } 
      
            curResponse.idList = idList;
            curResponse.nameList = nameList;
            curResponse.conversationList = fullConversationDetails;
            curResponse.serializedConversationList = JSON.serialize(fullConversationDetails);
            System.debug('conversationDetails structure: ' + fullConversationDetails);
            System.debug('conversationDetails structure: ' + curResponse.serializedConversationList);
            responses.add(curResponse);
             
        }
        return responses;

    }

    //converts the returned json into an apex object for use in flow components like datatables
    global static SlackConversation populateSlackConversationObject(Map<String, Object> channelResponseMap){
        SlackConversation curConversationObj = new SlackConversation();
        curConversationObj.id = (String)channelResponseMap.get('id');
        curConversationObj.name = (String)channelResponseMap.get('name');
        curConversationObj.isPrivate = (Boolean)channelResponseMap.get('is_private');
        curConversationObj.isArchived = (Boolean)channelResponseMap.get('is_archived');
        curConversationObj.isGeneral = (Boolean)channelResponseMap.get('is_general');
        curConversationObj.isShared = (Boolean)channelResponseMap.get('is_shared');
        curConversationObj.createTime = (Integer)channelResponseMap.get('created');
        curConversationObj.createdBy = (String)channelResponseMap.get('creator');
        //FIX curConversationObj.topic = (Map<String,String>)JSON.deserializeUntyped(JSON.serialize(channelResponseMap.get('topic')));
        //FIX curConversationObj.numberOfMembers = (Integer)channelResponseMap.get('num_members');
        return curConversationObj;
    }

    global static Boolean checkValidName() {
        //validate that curRequest.Name only contains lowercase letters, numbers, hyphens, and underscores, and must be 80 characters or less 
        return true;
    }
          
  
    

    global class InvocableActionException extends Exception{}

    global class Request {
     
        @InvocableVariable
        global String token;

        
    
    }

    global class Response {

        global Response() {
            nameList = new List<String>();
            idList = new List<String>();
            conversationList = new List<SlackConversation>();
        }


        @invocableVariable
        global List<String> nameList;

        @invocableVariable
        global List<String> idList;

        @invocableVariable
        global List<SlackConversation> conversationList;

        @invocableVariable
        global String serializedConversationList; //for use in Datatable

        @invocableVariable
        global String errorMessage;
    }
}
