public with sharing class mc_GetRecipients {
    @InvocableMethod(label='Parse Recipient Data' description='Parses the Recipient Data into usuable class for the flow'  category='Analytic Subscription')
    public static List<Results> mc_GetRecipients(List<Request> requests) {
        System.debug('mc_GetRecipients: ' + requests);
        // Set Response Wrapper
        List<Results> responseWrapper = new List<Results>();
        // From the list of requests, get the recipients
        List<mc_SubscriptionListDefinition_Recipients> recipients = new List<mc_SubscriptionListDefinition_Recipients>();

        
        // Loop through the requests
        for (Request request : requests) {
            // Fix definition_string to remove [ and ]]  
            // Remove the first character
            String definition_string = request.definition_string.substring(1);
            // Remove the last character
            definition_string = definition_string.substring(0, definition_string.length() - 1);

            // Deserialize the request with SubscriptionListDefinition
            mc_SubscriptionListDefinition subscriptionListDefinition = (mc_SubscriptionListDefinition)JSON.deserialize(definition_string, mc_SubscriptionListDefinition.class);

            System.debug('mc_GetRecipients: subscriptionListDefinition: ' + subscriptionListDefinition);
            
            Results response = new Results();

            // Check if subscriptionListDefinition is not null and then if not then add to the response wrapper
            if (subscriptionListDefinition != null) {
                response.recipients_string = JSON.serialize(subscriptionListDefinition.thresholds[0].actions[0].configuration.recipients != null ? subscriptionListDefinition.thresholds[0].actions[0].configuration.recipients : null);
                response.recipients = subscriptionListDefinition.thresholds[0].actions[0].configuration.recipients != null ? subscriptionListDefinition.thresholds[0].actions[0].configuration.recipients : null;
                response.notificationId = subscriptionListDefinition.id != null ? subscriptionListDefinition.id : null;
                response.definition = subscriptionListDefinition != null ? subscriptionListDefinition : null;
                responseWrapper.add(response);
                System.debug('recipients_string: ' + response.recipients_string);
                System.debug('recipients: ' + response.recipients);
            }

        }

        return responseWrapper;

    }

    public class Request {
        @InvocableVariable(required=true)
        public string definition_string;
    }

    public class Results {
        @InvocableVariable
        public List<mc_SubscriptionListDefinition_Recipients> recipients;

        @InvocableVariable
        public mc_SubscriptionListDefinition definition;

        @InvocableVariable
        public string notificationId;

        @InvocableVariable
        public string recipients_string;
    }
}