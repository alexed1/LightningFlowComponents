@isTest
public with sharing class DeleteMSTeamChannelTest {
    @isTest 
    static void deleteChannelTest() {
        Test.setMock(HttpCalloutMock.class, new MSTeamsMock(true));
        DeleteMSTeamChannel.Request  req = new DeleteMSTeamChannel.Request();
        req.channelId = 'cahnnelId';
        req.teamId = 'teamId';
        req.token = 'token';

        DeleteMSTeamChannel.Response res = DeleteMSTeamChannel.execute(new List<DeleteMSTeamChannel.Request> {req})[0];
        System.assert(res.isSuccess);

        Test.setMock(HttpCalloutMock.class, new MSTeamsMock(false));
        try{
        res = DeleteMSTeamChannel.execute(new List<DeleteMSTeamChannel.Request> {req})[0];
            System.assert(false);
        }catch(Exception e){
            System.assert(true);
        }
    }
}
