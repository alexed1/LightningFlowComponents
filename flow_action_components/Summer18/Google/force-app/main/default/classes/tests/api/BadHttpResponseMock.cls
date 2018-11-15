public class BadHttpResponseMock implements HttpCalloutMock {
        
    public HTTPResponse respond(HTTPRequest req) {
        HTTPResponse res = new HTTPResponse();
        res.setStatusCode(500);
        res.setBody('{'+
                    ' "error": {'+
                    '  "errors": ['+
                    '   {'+
                    '    "domain": "fail",'+
                    '    "reason": "fail",'+
                    '    "message": "fail",'+
                    '    "locationType": "fail",'+
                    '    "location": "fail"'+
                    '   }'+
                    '  ],'+
                    '  "code": 500,'+
                    '  "message": "fail"'+
                    ' }'+
                    '}');
        return res;
    }
}