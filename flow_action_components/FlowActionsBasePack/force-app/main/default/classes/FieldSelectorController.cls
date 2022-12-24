public with sharing class FieldSelectorController {
    @AuraEnabled(cacheable=true)
    public static List<Field> getObjectFields(String objectName) {
        List<Field> fields = new List<Field>();
        try {
            Map<String, Schema.SObjectField> tokenMap = ((SObject)Type.forName('Schema', objectName).newInstance()).getSObjectType().getDescribe().fields.getMap();
            for (String fieldName : tokenMap.keySet()) {
                Schema.DescribeFieldResult fieldResult = tokenMap.get(fieldName).getDescribe();
                Field newField = new Field(fieldResult.getName(), fieldResult.getLabel(), fieldResult.getType().name());
                if (fieldResult.getReferenceTo().size() == 1) {
                    newField.parentObjectName = fieldResult.getReferenceTo()[0].getDescribe().getName();
                    newField.relationshipName = fieldResult.getRelationshipName();
                }
                System.debug(newField);
                fields.add(newField);
            }        
        } catch (Exception e) {
            return null;
        }
        return fields;
    }

    public class Response {
        public String errorMessage;
        public List<Field> fields;
    }

    public class Field {
        @AuraEnabled public String name;
        @AuraEnabled public String label;
        @AuraEnabled public String type;
        @AuraEnabled public String parentObjectName;    // Used for lookup fields
        @AuraEnabled public String relationshipName;    // Used for lookup fields

        public Field(String name, String label, String type) {
            this.name = name;
            this.label = label;
            this.type = type;
        }
    }
}