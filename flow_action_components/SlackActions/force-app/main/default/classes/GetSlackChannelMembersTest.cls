@isTest
public inherited sharing class GetSlackChannelMembersTest {
    @isTest
    public static void CanGetSlackChannelMembers() {
        String channelName = 'foo';
  


        GetSlackChannelMembers.Request curRequest = new GetSlackChannelMembers.Request();
        curRequest.token = 'dummyToken';
        curRequest.channelId = channelName;
        List<GetSlackChannelMembers.Request> curRequests = new List<GetSlackChannelMembers.Request>();
        curRequests.add(curRequest);
        List<GetSlackChannelMembers.Response> curResponses = GetSlackChannelMembers.execute(curRequests);
        System.debug('curResponses is:' + curResponses);
        System.assertEquals(curResponses[0].ok, true);
    }
}
