@isTest
public class GoogleMapsAPITest {
    
    class HttpResponseMock implements HttpCalloutMock {
        
        public HTTPResponse respond(HTTPRequest req) {
            String endpoint = req.getEndpoint();
            System.debug('Test call for: ' + endpoint);
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);       
            if (endpoint.contains('origins=source&destinations=destination')) {
                res.setBody(
                    '{' +
                    ' "destination_addresses" : [ "source" ], ' +
                    ' "origin_addresses" : [ "destination" ], ' +
                    ' "rows": [' + 
                    ' { ' + 
                    '   "elements" : [ ' +
                    '     { ' +
                    '       "distance" : { ' + 
                    '          "text": "distance", ' + 
                    '          "value": 100 ' + 
                    '       }, ' + 
                    '       "duration" : { ' + 
                    '          "text": "duration", ' + 
                    '          "value": 200 ' + 
                    '       }, ' + 
                    '       "status": "OK" ' +
                    '     } ' + 
                    '   ] ' + 
                    '  } ' + 
                    ' ], ' +
                    ' "status" : "OK" ' + 
                    '}');
            }
            else {
                System.debug('Unknown endpoint: ' + endpoint);
            }
            return res;
        }
    }

    @isTest
    public static void getDistanceBetween_ParsedData() {
        Test.setMock(HttpCalloutMock.class, new HttpResponseMock());
        GoogleMapsAPI api = new GoogleMapsAPI(true);
        RoutesResponse response = api.getDistanceBetween('source', 'destination');
        System.assertEquals('OK', response.status);
        System.assert(String.isBlank(response.error_message));
        System.assertEquals(100, response.rows[0].elements[0].distance.value);
    }
}
