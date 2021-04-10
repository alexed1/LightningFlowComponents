@isTest
public with sharing class GetMSTeamsUsersTest {
    @isTest 
    static void createChannelTest() {
        Test.setMock(HttpCalloutMock.class, new MSTeamsMock(true));
        GetMSTeamsUsers.Request  req = new GetMSTeamsUsers.Request();
        req.userScope = 'channel';
        req.teamId = 'teamId';
        req.channelId = 'channelid';
        req.token = 'token';


        GetMSTeamsUsers.Response res = GetMSTeamsUsers.execute(new List<GetMSTeamsUsers.Request> {req})[0];
        System.assert(res.isSuccess);

        Test.setMock(HttpCalloutMock.class, new MSTeamsMock(false));
        try{
        res = GetMSTeamsUsers.execute(new List<GetMSTeamsUsers.Request> {req})[0];
            System.assert(false);
        }catch(Exception e){
            System.assert(true);
        }
    }
}
