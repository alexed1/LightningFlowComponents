public class BadHttpResponseMock implements HttpCalloutMock {
        
    public HTTPResponse respond(HTTPRequest req) {
        HTTPResponse res = new HTTPResponse();
        res.setStatusCode(500);
        res.setBody('{'+
                    ' "error": "fail", '+
                    ' "error_code": 500, '+
                    ' "error_description": "fail" '+                 
                    '}');
        return res;
    }
}