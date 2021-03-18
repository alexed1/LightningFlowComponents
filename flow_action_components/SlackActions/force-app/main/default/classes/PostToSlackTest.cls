@isTest
public inherited sharing class PostToSlackTest {
    @isTest
    public static void CanPostToSlack() {
        String channelId = 'dummyChannelId';
        String text = 'this is a message';
        String blocks = '[{"type": "section", "text": {"type": "plain_text", "text": "Hello world"}}]';


        PostToSlack.Request curRequest = new PostToSlack.Request();
        curRequest.token = 'dummyToken';
        curRequest.channelId = channelId;
        curRequest.text = text;
        curRequest.blocks = blocks;

        List<PostToSlack.Request> curRequests = new List<PostToSlack.Request>();
        curRequests.add(curRequest);
        List<PostToSlack.Response> curResponses = PostToSlack.execute(curRequests);
        System.debug('curResponses is:' + curResponses);
        System.assertEquals(curResponses[0].ok, true);
        System.assertEquals(curResponses[0].timeStamp, '1503435956.000247');
    }
}
