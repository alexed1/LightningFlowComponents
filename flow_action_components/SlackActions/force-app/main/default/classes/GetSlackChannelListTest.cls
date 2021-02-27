@isTest
public inherited sharing class GetSlackChannelListTest {

    final public static string token = 'xoxb-1612733320291-1799432051616-LwgS3ko9RYHdJxPKRgDdx6oz';

    public static string channelList ='{"ok":true,"channels":[{"id":"C01HKN648BZ",'
    + '"name":"general","is_channel":true,"is_group":false,"is_im":false,"created":1609845003,'
    + '"is_archived":false,"is_general":true,"unlinked":0,"name_normalized":"general",'
    + '"is_shared":false,"parent_conversation":null,"creator":"U01JQAVG0L8",'
    + '"is_ext_shared":false,"is_org_shared":false,"shared_team_ids":["T01J0MK9E8K"],'
    + '"pending_shared":[],"pending_connected_team_ids":[],"is_pending_ext_shared":false,'
    + '"is_member":false,"is_private":false,"is_mpim":false,"topic":{"value":"","creator":"",'
    + '"last_set":0},"purpose":{"value":"This is the one channel that will always include'
    + ' everyone. It\u2019s a great spot for announcements and team-wide conversations.",'
    + '"creator":"U01JQAVG0L8","last_set":1609845003},"previous_names":[],"num_members":4}],'
    + '"response_metadata":{"next_cursor":""}}';


    @isTest
    public static void CanGetSlackChannelList() {
        GetSlackChannelList.Request curRequest = new GetSlackChannelList.Request();
        curRequest.token = token;
        List<GetSlackChannelList.Request> curRequests = new List<GetSlackChannelList.Request>();
        curRequests.add(curRequest);
        List<GetSlackChannelList.Response> curResponses = GetSlackChannelList.execute(curRequests);
        System.debug('curResponses is:' + curResponses);
        System.assertEquals(curResponses[0].conversationList[0].id, 'C01HKN648BZ');
    }
}
