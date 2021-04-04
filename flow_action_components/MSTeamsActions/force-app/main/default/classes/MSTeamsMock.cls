public with sharing class MSTeamsMock implements HttpCalloutMock{
    Boolean isSuccessResponse = true;

    public MSTeamsMock(Boolean isSuccessResponse) {
        this.isSuccessResponse = isSuccessResponse;
    }

     public HttpResponse respond(HttpRequest req) {
        StaticResource sr = [SELECT Id, Body FROM StaticResource WHERE Name = 'MSTEAMSApiResponse' LIMIT 1];
        String method = req.getMethod();
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(sr.Body.toString());
        if(!isSuccessResponse) {
            res.setStatusCode(404);
        } else if(method == MSTeamsUtils.GET_METHOD) {
            res.setStatusCode(200);
        } else if(method == MSTeamsUtils.POST_METHOD) {
            res.setStatusCode(201);
        } else if(method == MSTeamsUtils.DELETE_METHOD) {
            res.setStatusCode(204);
        }

        return res;
     }
}
