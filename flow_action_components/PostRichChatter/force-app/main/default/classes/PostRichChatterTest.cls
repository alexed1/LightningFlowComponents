@isTest
public with sharing class PostRichChatterTest {
    
    @isTest(SeeAllData=true)
    public static void canPost() {
        PostRichChatter.Requests testReq = new PostRichChatter.Requests();
        testReq.body = 'this is the body';
        testReq.targetNameOrId = 'me';
        

        List<PostRichChatter.Requests> reqList = new List<PostRichChatter.Requests>();
        reqList.add(testReq);

        List<PostRichChatter.Results> testResponseList = PostRichChatter.post(reqList);
        System.assertNotEquals(testResponseList[0].feedItemId,null);
    }
}
