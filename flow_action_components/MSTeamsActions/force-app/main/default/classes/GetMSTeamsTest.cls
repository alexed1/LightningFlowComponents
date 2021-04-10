@isTest
public with sharing class GetMSTeamsTest {
    @isTest 
    static void getMSTeamsTest() {
        Test.setMock(HttpCalloutMock.class, new MSTeamsMock(true));
        GetMSTeams.Request  req = new GetMSTeams.Request();
        //get teams
        req.entityType = 'teams';
        req.token = 'token';

        GetMSTeams.Response res = GetMSTeams.execute(new List<GetMSTeams.Request> {req})[0];
        System.assert(res.isSuccess);
        //get channels
        req.entityType = 'channels';
        req.teamId = 'teamid';
        req.token = 'token';

        res = GetMSTeams.execute(new List<GetMSTeams.Request> {req})[0];
        System.assert(res.isSuccess);

        Test.setMock(HttpCalloutMock.class, new MSTeamsMock(false));
        try{
        res = GetMSTeams.execute(new List<GetMSTeams.Request> {req})[0];
            System.assert(false);
        }catch(Exception e){
            System.assert(true);
        }
    }
}
