global with sharing class PostToSlack {

        
        @InvocableMethod(label='Post to Slack' description='Post Message to Slack' callout=true configurationEditor='c:postToSlackCPE')
        global static List<Response> execute(List<Request> requests) {
            
            String endpoint = 'https://slack.com/api/' + 'chat.postMessage';
            List<Response> curResponses = new List<Response>();

            Map<String,Object> responseMap = new Map<String,Object>();
            for (Request curRequest: requests ){
                Response curResponse = new Response();
                String token = curRequest.token;
                String body = formBody(curRequest); 
                System.debug('body is: ' + body);

                if(!Test.isRunningTest()) {
                    responseMap = SlackUtils.Send(endpoint, token, body);
                    System.debug('response from chat.postMessage is: ' + responseMap);
                } else {
                    
                    String testResponse = sampleResponse;
                    responseMap = (Map<String, Object>) JSON.deserializeUntyped(testResponse);
                    System.debug('response from chat.postMessage is: ' + responseMap);
                }
               
                curResponse.timeStamp = (String)responseMap.get('ts');
                curResponse.ok = (Boolean)responseMap.get('ok');
                curResponse.errorMessage = (String)responseMap.get('error');
                curResponses.add(curResponse);
            }
            return curResponses;
      
        }

        private static String formBody(Request curRequest) {
            String body = '{';
            body = body + '"channel":"' + curRequest.channelId + '",';
            if(curRequest.blocks != null && curRequest.blocks != '') {
                body = body + '"blocks":' + curRequest.blocks+ ',';
            }
            if(curRequest.thread_ts != null && curRequest.thread_ts != '') {
                body = body + '"thread_ts":"' + curRequest.thread_ts + '",';
            }
            if(curRequest.username != null && curRequest.username != '') {
                body = body + '"username":"' + curRequest.username + '",';
            }
            if(curRequest.unfurl_links != null && curRequest.unfurl_links != '') {
                body = body + '"unfurl_links":"' + curRequest.unfurl_links + '",';
            }
            if(curRequest.attachments != null && curRequest.attachments != '') {
                body = body + '"attachments":"' + curRequest.attachments + '",';
            }
            if(curRequest.text != null && curRequest.text != '') {
                body = body + '"text":"' + curRequest.text + '"';
            }
            
            body = body + '}';
            return body; 

        }

        final static String sampleResponse = '{'
           + ' "ok": true,'
            +'"channel": "C1H9RESGL",'
            +' "ts": "1503435956.000247",'
            +' "message": {'
                +'  "text": "Here\'s a message for you",'
                +' "username": "ecto1",'
                +' "bot_id": "B19LU7CSY",'
                +' "attachments": ['
                    +'  {'
                        +'  "text": "This is an attachment",'
                        +' "id": 1,'
                        +' "fallback": "This is an attachment\'s fallback"'
                     +' }'
                +' ],'
                +' "type": "message",'
                +' "subtype": "bot_message",'
                +' "ts": "1503435956.000247"'
            +' }'
        + '}';

        global class Request {
            @InvocableVariable
            global String text; //main message unless you're using blocks

            @InvocableVariable
            global String blocks;
            
            @InvocableVariable(required=true)
            global String channelId;  

            @InvocableVariable
            global String token;

            @invocableVariable
            global String thread_ts;

            @invocableVariable
            global String username;

            @invocableVariable
            global String unfurl_links;

            @invocableVariable
            global String attachments;

        }
        global class Response {
            @invocableVariable
            global String errorMessage;

            @invocableVariable
            global String timeStamp;

            @invocableVariable
            global Boolean ok;
        }

      }