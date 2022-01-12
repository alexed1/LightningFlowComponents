global with sharing class NBARecommendation {
        global NBARecommendation() {
            params = new List<FlowParameter>();
        }
        //https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_connectapi_output_n_b_a_recommendations.htm
        @auraEnabled
        global String acceptanceLabel;
        
        @auraEnabled
        global String externalId;

        @auraEnabled 
        global String description;

        @auraEnabled
        global String rejectionLabel;

        @auraEnabled
        global String name;

        @auraEnabled
        global String url;

        @auraEnabled
        global String Id;

        @auraEnabled
        global String acceptFlowName;

        @auraEnabled
        global String acceptFlowType;

        @AuraEnabled
        global List<FlowParameter> params;
            
        }