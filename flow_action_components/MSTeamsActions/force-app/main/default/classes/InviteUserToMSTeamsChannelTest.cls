@isTest
public with sharing class InviteUserToMSTeamsChannelTest {
    @isTest 
    static void inviteUserTest() {
        Test.setMock(HttpCalloutMock.class, new MSTeamsMock(true));
        InviteUserToMSTeamsChannel.Request  req = new InviteUserToMSTeamsChannel.Request();
        req.teamId = 'teamId';
        req.channelId = 'channelid';
        req.userId = 'userId';
        req.token = 'token';

        InviteUserToMSTeamsChannel.Response res = InviteUserToMSTeamsChannel.execute(new List<InviteUserToMSTeamsChannel.Request> {req})[0];
        System.assert(res.isSuccess);

        Test.setMock(HttpCalloutMock.class, new MSTeamsMock(false));
        try{
        res = InviteUserToMSTeamsChannel.execute(new List<InviteUserToMSTeamsChannel.Request> {req})[0];
            System.assert(false);
        }catch(Exception e){
            System.assert(true);
        }
    }
}
