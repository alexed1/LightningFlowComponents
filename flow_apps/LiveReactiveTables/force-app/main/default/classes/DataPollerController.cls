public with sharing class DataPollerController {
    @AuraEnabled
    public static List<SObject> getSobjects(String queryString){
        return Database.query(queryString);
    }
}
