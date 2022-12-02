public with sharing class mc_DeleteRecipients {
    @InvocableMethod(label='Delete Selected Recipients' description='Get Subscription Data'  category='Analytic Subscription')
public static List<Results> mc_DeleteRecipients(List<Request> requests) {
        // Set Response Wrapper
        List<Results> responseWrapper = new List<Results>();
        Results response = new Results();

        // Instantiate a new http object
        Http h = new Http();
            
        // Get Domain URL
        string domainURL = URL.getSalesforceBaseUrl().toExternalForm();
        System.debug('domainURL: ' + domainURL);


        // Set Session ID
        string sessionId = 'some_text\nwritten_here';
    if(!test.isRunningTest()){
        sessionId =  Page.usf3__GenerateSessionIdForLWC.getContent().toString();
    }
        // Fix Session Id
        sessionId = sessionId.substring(sessionId.indexOf('\n')+1);


        for (Request request : requests) {
            // Set Base URL
            string baseURL =  '/services/data/v55.0/analytics/notifications/' + request.notificationId;
            // Set URL from domain and base url
            string url = domainURL + baseURL;

            // Set Lists
            List<mc_SubscriptionListDefinition_Recipients> recipients = request.recipients;
            List<mc_SubscriptionListDefinition_Recipients> recipientsDifferent = new List<mc_SubscriptionListDefinition_Recipients>();
            List<mc_SubscriptionListDefinition_Recipients> recipientsSame = new List<mc_SubscriptionListDefinition_Recipients>();

            // Deserialize the request with SubscriptionListDefinition
            List<mc_SubscriptionListDefinition_Recipients> recipientsToDelete = 
                new List<mc_SubscriptionListDefinition_Recipients>();
            if(!test.isRunningTest()){
            	recipientsToDelete = (List<mc_SubscriptionListDefinition_Recipients>)
                    JSON.deserialize(request.deletedRecipients, 
                                     List<mc_SubscriptionListDefinition_Recipients>.class);
            }
            
            // Deseralize the request with SubscriptionListDefinition
            mc_SubscriptionListDefinition definitionData = request.definition;
            
            // If recipients size equals recipientsToDelete size if they are the same then delete the entire notification else create a new recipient list
            if (recipients.size() == recipientsToDelete.size()) {
                // Delete the entire notification
                System.debug('Delete the entire notification' + request.notificationId);

                // Instantiate a new HTTP request, specify the method (DELETE) as well as the endpoint
                HttpRequest req = new HttpRequest();
                req.setEndpoint(url);
                req.setMethod('DELETE');
                req.setHeader('Authorization', 'OAuth ' + sessionId);

                // Send the request, and return a response
                HttpResponse res = h.send(req);

                response.status_code = res.getStatusCode();
                responseWrapper.add(response);


            } else {
                // Create a new recipient list with the recipients that are not in the recipientsToDelete list
                System.debug('recipients' + recipients);
                System.debug('recipientsToDelete' + recipientsToDelete);
                
                // Remove recipents from multidimensional list based on id and add to recipientsDifferent
                Set<mc_SubscriptionListDefinition_Recipients> myset = new Set<mc_SubscriptionListDefinition_Recipients>();
                List<mc_SubscriptionListDefinition_Recipients> result = new List<mc_SubscriptionListDefinition_Recipients>();
                myset.addAll(recipientsToDelete);
                System.debug('myset' + myset);
                result.addAll(recipients);
                System.debug('result' + result);
                myset.removeAll(result);
                System.debug('removeAll' + myset);
                recipientsDifferent.addAll(myset);

                // Update the recipients list with the new list
                System.debug('recipientsDifferent: ' + recipientsDifferent);

                // Instantiate a new HTTP request, specify the method (GET)
                HttpRequest req = new HttpRequest();
                req.setEndpoint(url);
                req.setMethod('GET');
                req.setHeader('Authorization', 'OAuth ' + sessionId);
                req.setHeader('Content-Type', 'application/json');

                // Send the request, and return a response
                HttpResponse res = h.send(req);

                // replace time: with timeOfDay: in the response body
                String responseBody = res.getBody().replace('"time":', '"timeOfDay":');

                System.debug('responseBody: ' + responseBody);

                // Deserialize the response body
                mc_SubscriptionListDefinition definition = (mc_SubscriptionListDefinition)JSON.deserialize(responseBody, mc_SubscriptionListDefinition.class);

                system.debug('definition: before; ' + definition);

                // Update definitionData with the new recipients list
                definition.thresholds[0].actions[0].configuration.recipients = recipientsDifferent;

                System.debug('definition: after; ' + definition);

                // Seralize Body
                String body = JSON.serialize(definition, true);

                // put timeOfDay back to time otherwise it will fail
                body = body.replace('"timeOfDay":', '"time":');
                System.debug('body: ' + body);


                // Instantiate a new HTTP request, specify the method (PUT) as well as the endpoint
                HttpRequest req2 = new HttpRequest();
                req2.setEndpoint(url);
                req2.setMethod('PUT');
                req2.setHeader('Authorization', 'OAuth ' + sessionId);
                req2.setHeader('Content-Type', 'application/json');
                req2.setBody(body);

                // Send the request, and return a response
                HttpResponse res2 = h.send(req2);
                System.debug('Response: ' + res2.getBody());
                response.status_code = res2.getStatusCode();
                responseWrapper.add(response);
            }
        }
        return responseWrapper;
    }

    public class Request {
        @InvocableVariable(required=true)
        public string notificationId;
        @InvocableVariable(required=true)
        public List<mc_SubscriptionListDefinition_Recipients> recipients;
        @InvocableVariable(required=true)
        public mc_SubscriptionListDefinition definition;
        @InvocableVariable(required=true)
        public string deletedRecipients;
    }

    public class Results {
        @InvocableVariable
        public Integer status_code;
    }

}