public with sharing class FormulaBuilderController {
    
    @AuraEnabled(cacheable=true)
    public static List<String> getFieldList(String objectName) {
        List<String> result = new List<String>();

        Schema.DescribeSObjectResult describeObject = Schema.getGlobalDescribe().get(objectName).getDescribe(); 
        Map<String, Schema.SObjectField> fields = describeObject.fields.getMap();

        for(Schema.sObjectField field : fields.values()) { 
            result.add(field.getDescribe().getName());
        }

        return result;
    }
    
}
