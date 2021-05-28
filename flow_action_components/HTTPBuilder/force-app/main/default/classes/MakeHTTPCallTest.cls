
    @isTest
    public with sharing class MakeHTTPCallTest {
        public class MakeHTTPCallMockGenerator implements HttpCalloutMock {
            public HTTPResponse respond(HTTPRequest req) {
                // Create a fake response
                if (req.getEndpoint() != 'localhost'){
                    HttpResponse res = new HttpResponse();
                    res.setHeader('Content-Type', 'application/json');
                    res.setBody('{"some-key":"some-value"}');
                    res.setStatusCode(200);
                    return res;
                }
                else{
                    CalloutException e = (CalloutException)CalloutException.class.newInstance();
                    e.setMessage('Test Error');
                    throw e;
                }
            }
    }
        
        @isTest static void TestCallout() {
            Test.setMock(HttpCalloutMock.class, new MakeHTTPCallMockGenerator());
            List<MakeHTTPCall.Request> listRequest =new List<MakeHTTPCall.Request>();
            MakeHTTPCall.Request req1 = new MakeHTTPCall.Request();
            //req1 ==> test success
            req1.Method = 'GET';
            req1.Endpoint = 'http://example.com/example/test';
            req1.Body = '{"key":"value"}';
            req1.Timeout = 15000;
            req1.Headers = '[{"key":"Content-Type","value":"application/json"},{"key":"Accept","value":"*/*"}]';
            req1.Params = '[{"key":"paramname1","value":"value1"},{"key":"paramname2","value":"value2"}]';
            req1.BodyAsBlob = True;
            req1.Compressed_gzip = True;
            listRequest.add(req1);
            //req2 ==> test method is not in (GET, POST, PATCH, PUT, DELETE, TRACE, CONNECT, HEAD, OPTIONS)
            MakeHTTPCall.Request req2 = new MakeHTTPCall.Request();
            req2.Method = 'ELSE';
            listRequest.add(req2);
            //req3 ==> test method body is not as blob, but failed
            MakeHTTPCall.Request req3 = new MakeHTTPCall.Request();
            req3.Method = 'POST';
            req3.Endpoint = 'localhost';
            req3.Body = '{"key":"value"}';
            listRequest.add(req3);
            List<MakeHTTPCall.Response> listResult = MakeHTTPCall.Invoke(listRequest);
            //assert req1
            System.assertEquals(200, listResult[0].status_code);
            //assert req2
            System.assertEquals('Method Not Allowed', listResult[1].Error_message);
            //assert req3
           System.assertEquals('Test Error', listResult[2].Error_message);    
        }
    }