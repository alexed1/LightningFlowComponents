@isTest
public inherited sharing class SlackUtilsTest {


    @isTest
    public static void CanSendHttp() {

        String endpoint = 'dummyEndpoint';
        String token = 'dummyToken';
        String body = 'dummyBody';
        Map<String,Object> results = SlackUtils.Send(endpoint, token, body);
        System.assertEquals(true, results.get('ok'));
    }
}
