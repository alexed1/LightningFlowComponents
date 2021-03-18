@isTest
public inherited sharing class ManageSlackChannelTest {


    final public static string token = 'xoxb-1612733320291-1799432051616-LwgS3ko9RYHdJxPKRgDdx6oz';

    @isTest
    public static void CanManageSlackChannel() {
        String channelId = 'foo';
  


        ManageSlackChannel.Request curRequest = new ManageSlackChannel.Request();
        curRequest.token = token;
        curRequest.channelId = channelId;
        curRequest.action = 'archiveChannel';
        List<ManageSlackChannel.Request> curRequests = new List<ManageSlackChannel.Request>();
        curRequests.add(curRequest);
        List<ManageSlackChannel.Response> curResponses = ManageSlackChannel.execute(curRequests);
        System.debug('curResponses is:' + curResponses);
        System.assertEquals(curResponses[0].ok, true);
    }
}
