public with sharing class ObjectFieldSelectorController {

    public static final String STANDARD = 'standard';
    public static final String SPECIFIC = 'specific';
    public static final String CUSTOM = 'custom';
    public static final String BOTH = 'both';
    public static final String ANCILLARY = 'ancillary';
    public static final String ALL = 'all';

    @AuraEnabled
    public static GetObjectsResult getObjects(String selectionType, List<String> availableObjects) {
        System.debug('in getObjects');
        // if (selectionType != STANDARD && selectionType != SPECIFIC && selectionType != CUSTOM && selectionType != ALL)
        if (String.isBlank(selectionType))
            selectionType = BOTH;
        selectionType = selectionType.toLowerCase();
        GetObjectsResult result = new GetObjectsResult();
        result.objects = new List<ObjectResult>();
        System.debug('selectionType = '+ selectionType);
        List<Schema.DescribeSObjectResult> describeResults = new List<Schema.DescribeSObjectResult>();
        if (selectionType == ALL) {
            Map<String, Schema.SObjectType> objMap = Schema.getGlobalDescribe();
            for (Schema.SObjectType objType : objMap.values()) {
                describeResults.add(objType.getDescribe());
            }
        } else if (selectionType == SPECIFIC) {
            describeResults = Schema.describeSObjects(availableObjects);
        } else {
            List<String> objectNames = new List<String>();
            List<EntityDefinition> entityDefs = new List<EntityDefinition>();
            if (selectionType == STANDARD || selectionType == BOTH) {
                entityDefs.addAll([SELECT KeyPrefix, QualifiedApiName, DeveloperName FROM EntityDefinition WHERE (NOT QualifiedApiName LIKE '%__c') AND (NOT QualifiedApiName LIKE '%Feed') AND (NOT QualifiedApiName LIKE '%Tag') AND (NOT QualifiedApiName LIKE '%Share') AND (NOT QualifiedApiName LIKE '%ChangeEvent') AND (NOT QualifiedApiName LIKE '%History')]);
            }
            if (selectionType == CUSTOM || selectionType == BOTH) {
                entityDefs.addAll([SELECT QualifiedApiName FROM EntityDefinition WHERE QualifiedApiName LIKE '%__c']);
            }
            if (selectionType == ANCILLARY) {
                entityDefs.addAll([SELECT QualifiedApiName, DeveloperName FROM EntityDefinition WHERE QualifiedApiName LIKE '%Feed' OR QualifiedApiName LIKE '%Tag' OR QualifiedApiName LIKE '%Share' OR QualifiedApiName LIKE '%ChangeEvent' OR QualifiedApiName LIKE '%History']);
            }
            for (EntityDefinition def : entityDefs) {
                // The standard list of EntityDefinitions may still return some odd types like metadata, so we filter out any object with double underscores
                if (selectionType != STANDARD || !def.QualifiedApiName.contains('__')) {
                    objectNames.add(def.QualifiedApiName);
                }
            }
            describeResults = Schema.describeSObjects(objectNames);
        }
        for (Schema.DescribeSObjectResult res : describeResults) {
            result.objects.add(new ObjectResult(res.getLabel(), res.getName()));
        }
        return result;
    }

    @AuraEnabled(cacheable=true)
    public static GetObjectFieldsResult getObjectFields(String objectName) {
        GetObjectFieldsResult result = new GetObjectFieldsResult();
        result.fields = new List<FieldResult>();
        try {
            Map<String, Schema.SObjectField> tokenMap = ((SObject)Type.forName('Schema', objectName).newInstance()).getSObjectType().getDescribe().fields.getMap();
            for (Schema.SObjectField objField : tokenMap.values()) {
                FieldResult newField = new FieldResult(objField.getDescribe());
                System.debug(newField);
                result.fields.add(newField);
            }        
        } catch (Exception e) {
            result.errorMessage = e.getMessage();
            return result;
        }
        System.debug('about to return result, with '+ result.fields.size() +' fields');
        return result;
    }

    public class GetObjectsResult {
        @AuraEnabled public List<ObjectResult> objects;
    }

    public class ObjectResult {
        @AuraEnabled public String label;
        @AuraEnabled public String value;

        public ObjectResult(String label, String value) {
            this.label = label;
            this.value = value;
        }        
    }

    public class GetObjectFieldsResult {
        @AuraEnabled public String errorMessage;
        @AuraEnabled public List<FieldResult> fields;
    }

    public class FieldResult {
        @AuraEnabled public String apiName;
        @AuraEnabled public String label;
        @AuraEnabled public String dataType;
        @AuraEnabled public List<String> referenceObjects;
        @AuraEnabled public List<ReferenceToInfo> referenceToInfos;

        public FieldResult(Schema.DescribeFieldResult fieldResult) {
            this.apiName = fieldResult.getName();
            this.label = fieldResult.getLabel();
            this.dataType = fieldResult.getType().name();
            List<ReferenceToInfo> refToInfos = new List<ReferenceToInfo>();
            for (Schema.sObjectType objType : fieldResult.getReferenceTo()) {
                refToInfos.add(new ReferenceToInfo(objType.getDescribe().getName()));
            }
            this.referenceToInfos = refToInfos;
        }
    }

    public class ReferenceToInfo {
        @AuraEnabled public String apiName;

        public ReferenceToInfo(String apiName) {
            this.apiName = apiName;
        }
    }
}