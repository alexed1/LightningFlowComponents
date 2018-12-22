@isTest
public class GrantAccessToQuipDocumentTest {

    class QuipMock implements StubProvider {

        private Map<String, List<List<Object>>> methodCalls;

        public QuipMock(Map<String, List<List<Object>>> methodCalls) {
            this.methodCalls = methodCalls;
        }

        public Object handleMethodCall(
            Object stubbedObject, 
            String stubbedMethodName,
            Type returnType,
            List<Type> listOfParamTypes,
            List<String> listOfParamNames,
            List<Object> listOfArgs) {
            if (methodCalls != null) {
                List<List<Object>> calls = methodCalls.get(stubbedMethodName);
                if (calls == null) {
                    calls = new List<List<Object>>();
                    methodCalls.put(stubbedMethodName, calls);
                }
                calls.add(new List<Object>(listOfArgs));
            }     
            System.debug('Unknown method ' + stubbedMethodName);
            return null;
        }
    }

    @isTest
    public static void GrantAccessToQuipDocument_CallsApi() {
        Map<String, List<List<Object>>> methodCalls = new Map<String, List<List<Object>>>();
        IQuip quip = (IQuip)Test.createStub(IQuip.class, new QuipMock(methodCalls));
        GrantAccessToQuipDocument.Request request = new GrantAccessToQuipDocument.Request();
        request.FileName = 'test';
        request.User1 = 'user1, user2';
        GrantAccessToQuipDocument.Response response = GrantAccessToQuipDocument.GrantAccessToQuipDocumentImpl(quip, request);
        System.assert(response.IsSuccess);
        System.assert(String.isBlank(response.ErrorMessage));
        List<List<Object>> calls = methodCalls.get('grantAccess');
        System.assert(calls != null, 'grantAccess method was not called');
        List<Object> args = calls[0];
        List<String> users = (List<String>)args[1];
        System.assertEquals(2, users.size());
    }

    @isTest
    public static void GrantAccessToQuipDocument_ReturnsResponses() {
        Test.setMock(HttpCalloutMock.class, new BadHttpResponseMock());
        GrantAccessToQuipDocument.Request request = new GrantAccessToQuipDocument.Request();
        request.FileName = 'test';
        request.User1 = 'user';
        List<GrantAccessToQuipDocument.Request> requests = new List<GrantAccessToQuipDocument.Request> { request };
        List<GrantAccessToQuipDocument.Response> responses = GrantAccessToQuipDocument.GrantAccessToQuipDocument(requests);
        System.assertEquals(1, responses.size());
        System.assert(!responses[0].IsSuccess);
        System.assertEquals('fail', responses[0].ErrorMessage);
    }
}
