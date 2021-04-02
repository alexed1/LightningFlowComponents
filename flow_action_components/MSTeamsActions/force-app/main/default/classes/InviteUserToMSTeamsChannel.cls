global with sharing class InviteUserToMSTeamsChannel {
    final static String POST_ADD_MEMBER_ENDPOINT = '/teams/{0}/channels/{1}/members'; // 0 - team id, 1 - channel id
    @InvocableMethod(label='Add Member to MS Teams Channel' callout=true)
    global static List<Response> execute(List<Request> requestList) {

        List<Response> responseList = new List<Response>();

        for (Request item : requestList ){
            Map<String, String> requestMap = new Map<String, String> ();
            requestMap.put('@odata.type', '#microsoft.graph.aadUserConversationMember');
            requestMap.put('user@odata.bind',Label.MSTEAM_API_ENDPOINT + '/users(\'' + item.userId + '\')');
            HttpRequest req = new HttpRequest();
            req = MSTeamsUtils.prepareHTTPRequest(
                Label.MSTEAM_API_ENDPOINT + String.format(POST_ADD_MEMBER_ENDPOINT,new List<String>{item.teamId, item.channelId}),
                MSTeamsUtils.POST_METHOD,
                JSON.serialize(requestMap), 
                item.token
            );

            Http http = new http();
            HttpResponse res = http.send(req);
            Response newRes = new Response();
            System.debug(item.userId);
            System.debug(req.getBody());
            System.debug(res.getBody());
            if(res.getStatusCode() == 201) {
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
