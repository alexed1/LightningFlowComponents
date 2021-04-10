@isTest
public with sharing class PostToMSTeamsTest {
    @isTest 
    static void postMessageTest() {
        Test.setMock(HttpCalloutMock.class, new MSTeamsMock(true));
        PostToMSTeams.Request  req = new PostToMSTeams.Request();
        req.body = 'test body';
        req.teamId = 'teamId';
        req.channelId = 'channelId';
        req.subject = 'subject';
        req.token = 'token';

        PostToMSTeams.Response res = PostToMSTeams.execute(new List<PostToMSTeams.Request> {req})[0];
        System.assert(res.isSuccess);

        Test.setMock(HttpCalloutMock.class, new MSTeamsMock(false));
        try{
        res = PostToMSTeams.execute(new List<PostToMSTeams.Request> {req})[0];
            System.assert(false);
        }catch(Exception e){
            System.assert(true);
        }
    }
}
