public with sharing class MCAuthorizationResponse {

        @AuraEnabled
        public String access_token;
        @AuraEnabled
        public String token_type;
        @AuraEnabled
        public Integer expires_in;
        @AuraEnabled
        public String scope;
        @AuraEnabled
        public String soap_instance_url;
        @AuraEnabled
        public String rest_instance_url;
    
        
        public static MCAuthorizationResponse parse(String json) {
            return (MCAuthorizationResponse) System.JSON.deserialize(json, MCAuthorizationResponse.class);
        }
    }