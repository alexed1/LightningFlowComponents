@isTest
public with sharing class KickUserFromMSTeamChannelTest {
    @isTest 
    static void kickUserTest() {
        Test.setMock(HttpCalloutMock.class, new MSTeamsMock(true));
        KickUserFromMSTeamChannel.Request  req = new KickUserFromMSTeamChannel.Request();
        req.teamId = 'teamId';
        req.channelId = 'channelid';
        req.userId = 'userId';
        req.token = 'token';

        KickUserFromMSTeamChannel.Response res = KickUserFromMSTeamChannel.execute(new List<KickUserFromMSTeamChannel.Request> {req})[0];
        System.assert(res.isSuccess);

        Test.setMock(HttpCalloutMock.class, new MSTeamsMock(false));
        try{
        res = KickUserFromMSTeamChannel.execute(new List<KickUserFromMSTeamChannel.Request> {req})[0];
            System.assert(false);
        }catch(Exception e){
            System.assert(true);
        }
    }
}
