global with sharing class KickUserFromMSTeamChannel {
    final static String DELETE_MEMBER_ENDPOINT = '/teams/{0}/channels/{1}/members/{2}'; // 0 - team id, 1 - channel id, 2 - member id
    @InvocableMethod(label='Kick Member from MS Teams Channel' callout=true)
    global static List<Response> execute(List<Request> requestList) {

        List<Response> responseList = new List<Response>();

        for (Request item : requestList ){
            HttpRequest req = new HttpRequest();
            req = MSTeamsUtils.prepareHTTPRequest(
                Label.MSTEAM_API_ENDPOINT + String.format(DELETE_MEMBER_ENDPOINT, new List<String>{item.teamId, item.channelId, item.userId}),
                MSTeamsUtils.DELETE_METHOD,
                null, 
                item.token
            );

            Http http = new http();
            HttpResponse res = http.send(req);
            Response newRes = new Response();

            if(res.getStatusCode() == 204) {
                newRes.isSuccess = true;
            } else {
                newRes.isSuccess = false;
                throw new InvocableActionException(MSTeamsUtils.getErrorMessageFromResponse(res.getBody()));
            }
            responseList.add(newRes);
        }
        return responseList;

    }
    
    global class InvocableActionException extends Exception{}

    global class Request {
        @InvocableVariable
        global String channelId;

        @InvocableVariable
        global String teamId;

        @InvocableVariable
        global String userId;

        @InvocableVariable
        global String token;
        
    }

    global class Response {

        global Response() {
            
        }

        @invocableVariable
        global Boolean isSuccess;

        @invocableVariable
        global String error;
    }
}
