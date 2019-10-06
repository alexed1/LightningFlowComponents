
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




