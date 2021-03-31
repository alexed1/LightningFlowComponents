global with sharing class PostToMSTeams {
    final static String POST_MESSAGE_ENDPOINT = '/teams/{0}/channels/{1}/messages'; // 0 - team id, 1 - channel id
    @InvocableMethod(label='Post Message to MS Team' description='Post Message to MS Team' callout=true)
    global static List<Response> execute(List<Request> requestList) {

        List<Response> responseList = new List<Response>();

        for (Request item : requestList ){
            HttpRequest req = new HttpRequest();
            MSTeamsMessage message = new MSTeamsMessage(item.subject, new ItemBody(item.body, 'html'));
            req = MSTeamsUtils.prepareHTTPRequest(
                Label.MSTEAM_API_ENDPOINT + String.format(POST_MESSAGE_ENDPOINT, new List<String> {item.teamId, item.channelId}),
                MSTeamsUtils.POST_METHOD,
                JSON.serialize(message), 
                item.token
            );

            Http http = new Http();
            HttpResponse res = http.send(req);
            if(res.getStatusCode() == 201) {
                Map<String, Object> response = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());

                responseList.add(new Response(true, (String)response.get('id'), null));
            } else {
                responseList.add(new Response(false, null, MSTeamsUtils.getErrorMessageFromResponse(res.getBody())));
                throw new InvocableActionException(MSTeamsUtils.getErrorMessageFromResponse(res.getBody()));
            }
        }
        return responseList;

    }

    global class InvocableActionException extends Exception{}

    global class Request {

        @InvocableVariable(required=true)
        global String teamId;  
        
        @InvocableVariable(required=true)
        global String channelId;
        
        @InvocableVariable(required=true)
        global String body;

        @InvocableVariable(required=true)
        global String subject;

        @InvocableVariable
        global String token;
        
    
    }

    global class Response {

        global Response(Boolean isSuccess, String messageId, String errorText) {
            this.isSuccess = isSuccess;
            this.errorText = errorText;
            this.messageId = messageId;
        }

        @invocableVariable
        global Boolean isSuccess;

        @invocableVariable
        global String errorText;

        @invocableVariable
        global String messageId;
    }

    public class MSTeamsMessage {
        public String subject;
        public ItemBody body;

        public MSTeamsMessage(String subject, ItemBody body) {
            this.subject = subject;
            this.body = body;
        }
    }

    public class ItemBody {
        public String content;
        public String contentType;

        public ItemBody(String content, String contentType){
            this.content = content;
            this.contentType = contentType;
        }
    }

    public class MSTeamError {
        String code;
        String message;
    }
}
