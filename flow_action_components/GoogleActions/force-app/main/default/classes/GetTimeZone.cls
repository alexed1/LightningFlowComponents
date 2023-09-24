public with sharing class GetTimeZone {
    @InvocableMethod(label='Get Time Zone')
    public static List<Results>  GetTimeZone(List<Request> requests) {
        // Set Response Wrapper
        List<Results> responseWrapper = new List<Results>();
        Results response = new Results();

        string timestamp = String.valueOf(System.now().getTime());
        // Get the first 8 characters of the timestamp
        timestamp = timestamp.substring(0, 8);
        string url = 'https://maps.googleapis.com/maps/api/timezone/json?location=' + requests[0].latitude + '%2C' + requests[0].longitude + '&timestamp=' + timestamp + '&key=' + requests[0].googleApiKey;
        response.requestURL = url;

        // Instantiate a new http object
        Http h = new Http();
        // Instantiate a new HTTP request, specify the method (DELETE) as well as the endpoint
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('GET');

        // Send the request, and return a response
        HttpResponse res = h.send(req);

        // Check the status code of the response
        if (res.getStatusCode() == 200) {
            // Parse the response body as JSON
            Map<String, Object> json = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            response.dstOffset = (Integer) json.get('dstOffset');
            response.rawOffset = (Integer) json.get('rawOffset');
            response.status = (String) json.get('status');
            response.timeZoneId = (String) json.get('timeZoneId');
            response.timeZoneName = (String) json.get('timeZoneName');
            responseWrapper.add(response);
        } else {
            // Handle the error
            System.debug('Error: ' + res.getStatusCode() + ' ' + res.getStatus());
            response.status = res.getStatus();
            response.timeZoneName = res.getBody();
            responseWrapper.add(response);
        }

        return responseWrapper;
    }

    public class Request {
        @InvocableVariable(required=true)
        public string latitude;
        @InvocableVariable(required=true)
        public string longitude;
        @InvocableVariable(required=true)
        public string googleApiKey;
    }

    public class Results {
        @InvocableVariable
        public Integer dstOffset;
        @InvocableVariable
        public Integer rawOffset;
        @InvocableVariable
        public String status;
        @InvocableVariable
        public String timeZoneId;
        @InvocableVariable
        public String timeZoneName;
        @InvocableVariable
        public String requestURL;
    }
}