global with sharing class GetMSTeamsUsers {
    final static Map<String, String> GET_USER_LIST_ENDPOINT_MAP = new Map<String, String> {
        'all' => '/users',
        'team' => '/teams/{0}/members',
        'channel' => '/teams/{0}/channels/{1}/members'
    };
    @InvocableMethod(label='Get MS Teams Users' callout=true)
    global static List<Response> execute(List<Request> requestList) {

        List<Response> responseList = new List<Response>();

        for (Request item : requestList ){
            HttpRequest req = new HttpRequest();
            req = MSTeamsUtils.prepareHTTPRequest(
                Label.MSTEAM_API_ENDPOINT + String.format(GET_USER_LIST_ENDPOINT_MAP.get(item.userScope), new List<String> {item.teamId, item.channelId}),
                MSTeamsUtils.GET_METHOD,
                null, 
                item.token
            );

            Http http = new http();
            HttpResponse res = http.send(req);
            Response newRes = new Response();
            Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
            if(res.getStatusCode() == 200) {
                newRes.isSuccess = true;
                if(responseMap.get('value') != null) {
                    List<MSTeamsUtils.MSTeamsEntity> teamList = (List<MSTeamsUtils.MSTeamsEntity>)JSON.deserialize(JSON.serialize(responseMap.get('value')), List<MSTeamsUtils.MSTeamsEntity>.Class);
                    newRes.labelList = new List<String>();
                    newRes.valueList = new List<String>();
                    for(MSTeamsUtils.MSTeamsEntity team : teamList) {
                        newRes.labelList.add(team.displayName);
                        newRes.valueList.add(team.id);
                    }
                }
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
        global String userScope = 'all';// 'channel or team all' values. all is default

        @InvocableVariable
        global String teamId;

        @InvocableVariable
        global String channelId;

        @InvocableVariable
        global String token;
        
    }

    global class Response {

        global Response() {
            
        }

        @invocableVariable
        global List<String> valueList;

        @invocableVariable
        global List<String> labelList;

        @invocableVariable
        global Boolean isSuccess;

        @invocableVariable
        global String error;
    }
}
