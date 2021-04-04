global with sharing class CreateMSTeamChannel {
    final static String POST_MESSAGE_ENDPOINT = '/teams/{0}/channels';// 0 - team id 
    @InvocableMethod(label='Create MS Teams Channel' callout=true)
    global static List<Response> execute(List<Request> requestList) {

        List<Response> responseList = new List<Response>();

        for (Request item : requestList ){
            HttpRequest req = new HttpRequest();
            Channel newChannel = new Channel(item.displayName, item.description, item.membershipType);
            req = MSTeamsUtils.prepareHTTPRequest(
                Label.MSTEAM_API_ENDPOINT + String.format(POST_MESSAGE_ENDPOINT, new List<String>{item.teamId}),
                MSTeamsUtils.POST_METHOD,
                JSON.serialize(newChannel), 
                item.token
            );

            Http http = new Http();
            HttpResponse res = http.send(req);
            Response newRes = new Response();
            if(res.getStatusCode() == 201) {
                Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
                newRes.isSuccess = true;
                newRes.channelId = (String)responseMap.get('id');
            } else {
                newRes.isSuccess = false;
                newRes.errorText = MSTeamsUtils.getErrorMessageFromResponse(res.getBody());
                throw new InvocableActionException(MSTeamsUtils.getErrorMessageFromResponse(res.getBody()));
            }
            responseList.add(newRes);
              
        }
        return responseList;

    }

          
  
    

    global class InvocableActionException extends Exception{}

    global class Request {

        @InvocableVariable(required=true)
        global String teamId;  
        
        @InvocableVariable(required=true)
        global String description;
        
        @InvocableVariable(required=true)
        global String displayName;

        @InvocableVariable(required=true)
        global String membershipType;

        @InvocableVariable
        global String token;
        
    
    }

    global class Response {

        global Response() {
            
        }

        @invocableVariable 
        global String channelId;

        @invocableVariable
        global Boolean isSuccess;

        @invocableVariable
        global String errorText;
    }

    public class Channel {
        public String description;
        public String displayName;
        public String membershipType;

        public Channel(String displayName, String description, String membershipType) {
            this.description = description;
            this.displayName = displayName;
            this.membershipType = membershipType;
        }
    }

    public class MSTeamError {
        String code;
        String message;
    }
}