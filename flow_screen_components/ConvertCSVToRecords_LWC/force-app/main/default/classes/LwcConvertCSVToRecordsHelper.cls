public with sharing class LwcConvertCSVToRecordsHelper {
    // Get Object fields from objectName parameter and return as a list of strings
    @AuraEnabled
    public static List<Map<String,String>> getObjectFields(String objectName) {
        SObjectType contactType = Schema.getGlobalDescribe().get(objectName);
        Map<String,Schema.SObjectField> mfields = contactType.getDescribe().fields.getMap();
        List<Map<String,String>> fields = new List<Map<String,String>>();
        // Store field name and type in a map
        for (Schema.SObjectField field : mfields.values()) {
            Map<String,String> fieldMap = new Map<String,String>();
            fieldMap.put('name', field.getDescribe().getName());
            fieldMap.put('type', field.getDescribe().getType().name());
            fields.add(fieldMap);
        }
        System.debug('fields: ' + fields);
        return fields;
    }
}