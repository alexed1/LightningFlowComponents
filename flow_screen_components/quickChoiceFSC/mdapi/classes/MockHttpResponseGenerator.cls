@isTest
    global class MockHttpResponseGenerator implements HttpCalloutMock {
        // Implement this interface method
        global HTTPResponse respond(HTTPRequest req) {
            // Optionally, only send a mock response for a specific endpoint
            // and method.
            // System.assertEquals('http://example.com/example/test', req.getEndpoint());
            //System.assertEquals('GET', req.getMethod());
            
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"entityTypeName": "ProfileLayout","records": [{"attributes": {"type": "ProfileLayout","url": "/services/data/v47.0/tooling/sobjects/ProfileLayout/01G1F00000pf0cZUAQ"},"Layout": {"attributes": {"type": "Layout","url": "/services/data/v47.0/tooling/sobjects/Layout/00h1F000001mbtuQAA"},"Name": "Account Layout","TableEnumOrId": "Account"}}]}');
            res.setStatusCode(200);
            return res;

            
            }   
    }
