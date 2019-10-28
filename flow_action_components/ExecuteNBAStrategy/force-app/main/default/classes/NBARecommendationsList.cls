
    //This Apex-defined Type is designed to match this data structure: https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_connectapi_output_n_b_a_recommendations.htm#apex_connectapi_output_n_b_a_recommendations
    //That structure is returned from the executeStrategy method that is defined here: https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_ConnectAPI_NextBestAction_static_methods.htm#apex_ConnectAPI_NextBestAction_methods
    //For information on how this class is used to map the return data from the Apex executeStrategy call for use in Flows and LWC's, see:
    // https://unofficialsf.com/part-1-manipulate-complex-internet-data-in-flow-without-code/
    
    global with sharing class NBARecommendationsList {
        global NBARecommendationsList() {
            recommendations = new List<NBARecommendation>();
        }

        @auraEnabled
        global List<NBARecommendation>  recommendations;

        @auraEnabled
        global String errors;
        
        @auraEnabled
        global String executionId;

        @auraEnabled
        global String onBehalfOfId;
        
        @auraEnabled
        global String debug;

    }




