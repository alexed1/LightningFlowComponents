global inherited sharing class GetSlackUserList {

        @InvocableMethod(label='Get Slack User List' description='Get Slack User List' callout=true)
        global static List<Response> execute(List<Request> requests) {
            
            List<Response> responses = new List<Response>();
    
            for (Request curRequest: requests ){
                List<String> nameList = new List<String>(); //these list structures are easier to work with when it comes to screen UI
                List<String> idList = new List<String>();
                Response curResponse = new Response();
                String body =  'token='+curRequest.token;

                String response; 
                
                if(!Test.isRunningTest()) {
                    response = SlackUtils.PrepareAndSend(body, 'users.list');             
                } else {             
                    response = sampleResponse; 
                }

                Map<String,Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(response);
                System.debug('response from get slack channel list is: ' + responseMap);
                if(responseMap.get('ok') == true) {
                    curResponse.ok = true;
                    System.debug('responseMap are ' + responseMap);
                    List<Object> userObjects = (List<Object>)responseMap.get('members');
                    System.debug('userlObjects are ' + userObjects);
                   
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
    

              
        final static String sampleResponse = '{'
        + ' "ok": true,'
        +' "members": ['
            +' { '
                +'"id": "W012A3CDE",'
                +'"team_id": "T012AB3C4",'
                +'"name": "spengler"'
            +' }'
         +' ]'
     + '}';
        
    
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
            global Boolean ok;
    
            @invocableVariable
            global List<String> nameList;
    
            @invocableVariable
            global List<String> idList;
    
        }


    }
    