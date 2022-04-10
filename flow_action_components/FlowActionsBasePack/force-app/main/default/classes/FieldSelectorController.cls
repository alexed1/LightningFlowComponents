global with sharing class FieldSelectorController {
    @AuraEnabled(cacheable=true)
    global static List<Field> getObjectFields(String objectName) {
        List<Field> fields = new List<Field>();
        try {
            Map<String, Schema.SObjectField> tokenMap = ((SObject)Type.forName('Schema', objectName).newInstance()).getSObjectType().getDescribe().fields.getMap();
            for (String fieldName : tokenMap.keySet()) {
                Schema.DescribeFieldResult fieldResult = tokenMap.get(fieldName).getDescribe();
                Field newField = new Field(fieldResult.getName(), fieldResult.getLabel(), fieldResult.getType().name());
                System.debug(newField);
                fields.add(newField);
            }        
        } catch (Exception e) {
            return null;
        }
        return fields;
    }

    global class Response {
        public String errorMessage;
        public List<Field> fields;
    }

    global class Field {
        @AuraEnabled public String name;
        @AuraEnabled public String label;
        @AuraEnabled public String type;

        public Field(String name, String label, String type) {
            this.name = name;
            this.label = label;
            this.type = type;
        }
    }
}