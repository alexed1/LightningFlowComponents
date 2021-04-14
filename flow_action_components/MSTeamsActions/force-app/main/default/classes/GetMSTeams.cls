global with sharing class GetMSTeams {
    final static String GET_MSTEAMS_LIST_ENDPOINT = '/groups';
    final static String GET_CHANNEL_LIST_ENDPOINT = '/teams/{0}/channels'; // 0 - team id
    @InvocableMethod(label='Get MS Teams or Channels' callout=true)
    global static List<Response> execute(List<Request> requestList) {

        List<Response> responseList = new List<Response>();

        for (Request item : requestList ){
            HttpRequest req = new HttpRequest();
            req = MSTeamsUtils.prepareHTTPRequest(
                Label.MSTEAM_API_ENDPOINT + ((item.entityType == 'channels') ? String.format(GET_CHANNEL_LIST_ENDPOINT, new List<String> {item.teamId}): GET_MSTEAMS_LIST_ENDPOINT),
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

                    for(MSTeamsUtils.MSTeamsEntity team : teamList) {
                        newRes.labelList.add(team.displayName);
                        newRes.valueList.add(team.id);
                        if(team.membershipType == MSTeamsUtils.PRIVATE_MEMBERSHIP) {
                            newRes.privateChannelLabelList.add(team.displayName);
                            newRes.privateChannelValueList.add(team.id);
                        }
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
        global String entityType;// 'channels or teams' values

        @InvocableVariable
        global String teamId;// if entityType == 'channels'

        @InvocableVariable
        global String token;
        
    }

    global class Response {

        global Response() {
            
        }

        @invocableVariable
        global List<String> valueList = new List<String>();

        @invocableVariable
        global List<String> labelList = new List<String>();

        @invocableVariable
        global List<String> privateChannelValueList = new List<String>();

        @invocableVariable
        global List<String> privateChannelLabelList = new List<String>();

        @invocableVariable
        global Boolean isSuccess;

        @invocableVariable
        global String error;
    }

}
