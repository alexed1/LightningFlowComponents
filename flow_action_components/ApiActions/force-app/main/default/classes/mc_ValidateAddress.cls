public with sharing class mc_ValidateAddress {
    @InvocableMethod(label='Validate Address')
    public static List<Results> mc_ValidateAddress(List<Request> requests) {
        // Set Response Wrapper
        List<Results> responseWrapper = new List<Results>();
        Results response = new Results();

        string timestamp = String.valueOf(System.now().getTime());
        // Get the first 8 characters of the timestamp
        timestamp = timestamp.substring(0, 8);
        string url = 'https://addressvalidation.googleapis.com/v1:validateAddress?key=' + requests[0].googleApiKey;
        response.requestURL = url;

        // Instantiate a new http object
        Http h = new Http();
        // Instantiate a new HTTP request, specify the method (DELETE) as well as the endpoint
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');

        // Create body from request
        string body = '{"address": {"addressLines": ["'+requests[0].street+'"], "locality": "'+requests[0].city+'", "administrativeArea": "'+requests[0].state+'", "postalCode": "'+requests[0].postalCode+'"},"enableUspsCass":true}';
        // Set the body of the request
        req.setBody(body);

        // Send the request, and return a response
        HttpResponse res = h.send(req);

        // Check the status code of the response
        if (res.getStatusCode() == 200) {
            // Parse the response body as JSON
            // Get uspsData.standardizedAddress
            // Set response.street = uspsData.standardizedAddress.firstAddressLine
            // Set response.city = uspsData.standardizedAddress.city
            // Set response.state = uspsData.standardizedAddress.state
            // Set response.postalCode = uspsData.standardizedAddress.zipCode
            // Set response.country = 'United States'
            // Set response.latitude = geocode.location.latitude
            // Set response.longitude = geocode.location.longitude
            // Set responseWrapper.add(response)

            System.debug('Response: ' + res.getBody());
            // Parse the response body as JSON
            mc_ValidateAddress_Results results = (mc_ValidateAddress_Results)JSON.deserialize(res.getBody(), mc_ValidateAddress_Results.class);
            System.Debug('results: ' + results);
            response.results = results;
            response.status = res.getStatus();
            
            responseWrapper.add(response);
        } else {
            // Handle the error
            System.debug('Error: ' + res.getStatusCode() + ' ' + res.getStatus());
            response.status = res.getStatus();
            response.errorMessage = res.getBody();
            responseWrapper.add(response);
        }

        return responseWrapper;
    }

    public class Request {
        @InvocableVariable(required=true)
        public string street;
        @InvocableVariable(required=true)
        public string city;
        @InvocableVariable(required=true)
        public string state;
        @InvocableVariable(required=true)
        public string country;
        @InvocableVariable(required=true)
        public string postalCode;
        @InvocableVariable(required=true)
        public string googleApiKey;
    }

    public class Results {
        @InvocableVariable
        public mc_ValidateAddress_Results results;
        @InvocableVariable
        public string requestURL;
        @InvocableVariable
        public string errorMessage;
        @InvocableVariable
        public string status;
        
    }

}