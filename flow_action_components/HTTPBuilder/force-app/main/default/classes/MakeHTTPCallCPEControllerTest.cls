@isTest
public with sharing class MakeHTTPCallCPEControllerTest {
    @isTest
    static void makeTestHTTPCallout() {
        Test.setMock(HttpCalloutMock.class, new MakeHTTPCallTest.MakeHTTPCallMockGenerator());
        MakeHTTPCall.Request request =new MakeHTTPCall.Request();
        //req1 ==> test success
        request.Method = 'GET';
        request.Endpoint = 'http://example.com/example/test';
        request.Body = '{"key":"value"}';
        request.Timeout = 15000;
        request.Headers = '[{"key":"Content-Type","value":"application/json"},{"key":"Accept","value":"*/*"}]';
        request.BodyAsBlob = true;
        request.Compressed_gzip = true;


        String responseJSON = MakeHTTPCallCPEController.makeTestHTTPCallout(JSON.serialize(request));
        MakeHTTPCall.Response response = (MakeHTTPCall.Response)JSON.deserialize(responseJSON, MakeHTTPCall.Response.Class);
        System.assertEquals(response.Status_code, 200);
        

    }

}
