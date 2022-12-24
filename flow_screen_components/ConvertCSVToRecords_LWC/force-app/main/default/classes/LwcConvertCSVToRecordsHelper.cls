public with sharing class LwcConvertCSVToRecordsHelper {
    // Get Object fields from objectName parameter and return as a list of strings
    @AuraEnabled
    public static List<String> getObjectFields(String objectName) {
        SObjectType contactType = Schema.getGlobalDescribe().get(objectName);
        Map<String,Schema.SObjectField> mfields = contactType.getDescribe().fields.getMap();

        List<String> sObjectDetailsList = new List<String>();
        for(String s : mfields.keySet()){
            sObjectDetailsList.add(String.valueOf(mfields.get(s)));
        }
        return sObjectDetailsList;
    }
}