@isTest
public with sharing class RunFlowOnAnotherOrgTest {
    @isTest
    static void executeTest() {
        RunFlowOnAnotherOrg.Request request = new RunFlowOnAnotherOrg.Request();
        Test.setMock(HttpCalloutMock.class, new RunFlowOnAnotherOrgMock());
        request.baseOrgURL = 'http://example.com/example/test';
        request.consumerKey = 'consumerkey';
        request.consumerSecret ='consumersecret';
        request.flowName = 'run_Flow';
        request.inputsJSON = '[{"key" : "key", "value" : "value"}] ';
        request.password = 'password';
        request.useFutureMethod = false;

        request.username = 'username';

        RunFlowOnAnotherOrg.Response response= RunFlowOnAnotherOrg.execute(new List<RunFlowOnAnotherOrg.Request> {request})[0];
        System.assertEquals(response.result, 'success');

        //run future method
        Test.startTest();
        request.useFutureMethod = true;

        request.username = 'username';

        response = RunFlowOnAnotherOrg.execute(new List<RunFlowOnAnotherOrg.Request> {request})[0];
        Test.stopTest();

    }


    public class RunFlowOnAnotherOrgMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            System.assertEquals('POST', req.getMethod());
            
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"example":"test"}');
            res.setStatusCode(200);
            return res;
        }
    }
}
