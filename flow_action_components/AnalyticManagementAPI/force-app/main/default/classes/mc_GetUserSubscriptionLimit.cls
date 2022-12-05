public with sharing class mc_GetUserSubscriptionLimit {
    @InvocableMethod(label='Get User Subscription Limit' description='Get the subscription limit for a user' category='Analytic Subscription')
    public static List<Results> mc_GetUserSubscriptionLimitList(List<Request> requestList) {
        // Set list of results
        List<mc_SubscriptionLimitDefinition> userLimit = new List<mc_SubscriptionLimitDefinition>();

        // Set Response wrapper
        List<Results> responseList = new List<Results>();

        for( Request currRequest : requestList ) {
            System.debug('source: ' + currRequest.source);
            System.debug('recordId: ' + currRequest.recordId);
            
            // Instantiate a new http object
            Http http = new Http();

            // Get Domain URL
            string domainURL = URL.getSalesforceBaseUrl().toExternalForm();
            string baseURL = '/services/data/v55.0/analytics/notifications/limits?source=' + currRequest.source;

            // Go throuhg inputs and set parameters
            if ( currRequest.recordId != null ) {
                baseURL += '&recordId=' + currRequest.recordId;
            }

            // Set URL from domain and base URL
            string url = domainURL + baseURL;

            // Set Session Id
            string sessionId = 'session \n id';
            if(!test.isRunningTest()){
            	sessionId =  Page.usf3__GenerateSessionIdForLWC.getContent().toString();
            }
            // Fix Session Id
            sessionId = sessionId.substring(sessionId.indexOf('\n')+1);

            // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
            HttpRequest request = new HttpRequest();
            request.setEndpoint(url);
            request.setMethod('GET');
            request.setHeader('Accept', 'application/json');
            request.setHeader('Accept-Encoding', 'gzip, deflate, br');
            request.setHeader('Authorization', 'OAuth ' + sessionId);

            // Send the request and store the response
            HttpResponse response = http.send(request);

            // Set Response Body
            String responseBody = response.getBody();
            System.debug('responseBody: ' + responseBody);

            // Parse JSON Response
            mc_SubscriptionLimitDefinition parsedResponse = (mc_SubscriptionLimitDefinition)JSON.deserialize(responseBody, mc_SubscriptionLimitDefinition.class);
            Results results = new Results();
            results.definition = parsedResponse;

            responseList.add(results);
        }   

        return responseList;
    }

    public class Request {
        @InvocableVariable(required=true)
        public string source;

        @InvocableVariable
        public string recordId;
    }

    public class Results {
        @InvocableVariable
        public mc_SubscriptionLimitDefinition definition;
    }
}
