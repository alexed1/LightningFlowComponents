global inherited sharing class GetSlackUserList {

        @InvocableMethod(label='Get Slack User List' description='Get Slack User List' callout=true)
        global static List<Response> execute(List<Request> requests) {
            
            List<Response> responses = new List<Response>();
    
            for (Request curRequest: requests ){
                List<String> nameList = new List<String>(); //these list structures are easier to work with when it comes to screen UI
                List<String> idList = new List<String>();
                Response curResponse = new Response();
                String body =  'token='+curRequest.token;
                String response = SlackUtils.PrepareAndSend(body, 'users.list');
                
                 Map<String,Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(response);
                if(responseMap.get('ok') == true) {
                    System.debug('responseMap are ' + responseMap);
                    List<Object> userObjects = (List<Object>)responseMap.get('members');
                    System.debug('userlObjects are ' + userObjects);
                    //List<Map<String, String>> finalChannelsList = new List<Map<String, String>>(); 
                   
                    for (Object curChannel : userObjects) {
                        String json_instance = Json.serialize(curChannel);
                        Map<String,Object> userResponseMap = (Map<String, Object>)JSON.deserializeUntyped(json_instance);
                       
                        nameList.add((String)userResponseMap.get('name'));
                        idList.add((String)userResponseMap.get('id'));
                 
                    }
    
                } 
          
                curResponse.idList = idList;
                curResponse.nameList = nameList;
                
                responses.add(curResponse);
                 
            }
            return responses;
    
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
            }
    
    
            @invocableVariable
            global List<String> nameList;
    
            @invocableVariable
            global List<String> idList;
    
        }


    }
    