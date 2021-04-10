@isTest
public with sharing class CreateMSTeamChannelTest {
    @isTest 
    static void createChannelTest() {
        Test.setMock(HttpCalloutMock.class, new MSTeamsMock(true));
        CreateMSTeamChannel.Request  req = new CreateMSTeamChannel.Request();
        req.description = 'test description';
        req.teamId = 'teamId';
        req.membershipType = 'private';
        req.displayName = 'test name';
        req.token = 'token';

        CreateMSTeamChannel.Response res = CreateMSTeamChannel.execute(new List<CreateMSTeamChannel.Request> {req})[0];
        System.assert(res.isSuccess);

        Test.setMock(HttpCalloutMock.class, new MSTeamsMock(false));
        try{
        res = CreateMSTeamChannel.execute(new List<CreateMSTeamChannel.Request> {req})[0];
            System.assert(false);
        }catch(Exception e){
            System.assert(true);
        }
    }
}
