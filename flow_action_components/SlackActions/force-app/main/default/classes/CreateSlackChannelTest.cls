@isTest
public inherited sharing class CreateSlackChannelTest {
    final public static string token = 'xoxb-1612733320291-1799432051616-LwgS3ko9RYHdJxPKRgDdx6oz';

    @isTest
    public static void CanCreateSlackChannel() {
        String channelName = 'foo';
  
        

        CreateSlackChannel.Request curRequest = new CreateSlackChannel.Request();
        curRequest.channelName = channelName;
        curRequest.token = token;
        List<CreateSlackChannel.Request> curRequests = new List<CreateSlackChannel.Request>();
        curRequests.add(curRequest);
        List<CreateSlackChannel.Response> curResponses = CreateSlackChannel.execute(curRequests);
        System.debug('curResponses is:' + curResponses);
        System.assertEquals(curResponses[0].ok, true);
    }
}