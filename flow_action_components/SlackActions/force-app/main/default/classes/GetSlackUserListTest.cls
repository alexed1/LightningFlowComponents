@isTest
public inherited sharing class GetSlackUserListTest {
    @isTest
    public static void CanGetSlackUserList() {
       
        GetSlackUserList.Request curRequest = new GetSlackUserList.Request();
        curRequest.token = 'dummyToken';

        List<GetSlackUserList.Request> curRequests = new List<GetSlackUserList.Request>();
        curRequests.add(curRequest);
        List<GetSlackUserList.Response> curResponses = GetSlackUserList.execute(curRequests);
        System.debug('curResponses is:' + curResponses);
        System.assertEquals(curResponses[0].ok, true);
        System.assertNotEquals(curResponses[0].nameList, null);
    }
}