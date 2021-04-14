global with sharing class DeleteMSTeamChannel {
    final static String DELETE_CHANNEL_ENDPOINT = '/teams/{0}/channels/{1}';// 0 - team id, 1 - channel id
    @InvocableMethod(label='Delete MS Teams Channel' callout=true)
    global static List<Response> execute(List<Request> requestList) {

        List<Response> responseList = new List<Response>();

        for (Request item : requestList ){
            HttpRequest req = new HttpRequest();
            req = MSTeamsUtils.prepareHTTPRequest(
                Label.MSTEAM_API_ENDPOINT + String.format(DELETE_CHANNEL_ENDPOINT, new List<String>{item.teamId, item.channelId}),
                MSTeamsUtils.DELETE_METHOD,
                null, 
                item.token
            );

            Http http = new Http();
            HttpResponse res = http.send(req);
            Response newRes = new Response();
            if(res.getStatusCode() == 204) {
                newRes.isSuccess = true;
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
        global String channelId;  

        @InvocableVariable
        global String token;
    
    }

    global class Response {

        global Response() {
            
        }

        @invocableVariable
        global Boolean isSuccess;

        @invocableVariable
        global String errorText;
    }

}
