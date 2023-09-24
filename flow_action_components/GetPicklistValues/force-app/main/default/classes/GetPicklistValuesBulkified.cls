//invocable action that, when provided with the name of an object and a picklist field, returns the vales of the picklist
//see https://unofficialsf.com/flow-action-get-picklist-values/

public with sharing class GetPicklistValuesBulkified {
    @TestVisible
    private static final String MSG_OBJECT_OR_FIELD_NOT_PROVIDED = 'Object name or field name not provided.';

    @InvocableMethod(
        label='Get Picklist Values'
        description='Batchable version of GetPicklistValues'
    )
    public static List<Results> getPicklistVals(List<Requests> requestList) {
        System.debug(LoggingLevel.DEBUG, 'entering getPicklistVals');

        List<Results> responseWrapper = new List<Results>();

        for (Requests request : requestList) {
            String objectName = request.objectName;
            String fieldName = request.fieldName;

            if (
                String.isBlank(objectName) == null || String.isBlank(fieldName)
            ) {
                Results response = new Results();
                response.picklistValues = new List<String>();
                response.ok = false;
                response.message = MSG_OBJECT_OR_FIELD_NOT_PROVIDED;
                responseWrapper.add(response);

                continue;
            }

            System.debug(
                LoggingLevel.DEBUG,
                'object and field are  :' +
                objectName +
                'and ' +
                fieldName
            );

            SObjectType objectType = ((SObject) Type.forName(objectName)
                    .newInstance())
                .getSObjectType(); //courtesy of cropredy and sfdcfox https://salesforce.stackexchange.com/a/250041/24822

            //General code below courtesy of sfdcmonkey http://sfdcmonkey.com/2016/12/05/how-to-fetch-picklist-value-from-sobject-and-set-in-uiinputselect/

            // Describe the SObject using its object type.
            Schema.DescribeSObjectResult objDescribe = objectType.getDescribe();

            // Get a map of fields for the SObject
            Map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();

            // Get the list of picklist values for this field.
            List<Schema.PicklistEntry> values = fieldMap.get(fieldName)
                .getDescribe()
                .getPickListValues();

            List<String> picklistStringValues = new List<String>();
            List<String> picklistStringLabels = new List<String>();

            //assemble the values into a List of strings
            for (Schema.PicklistEntry a : values) {
                picklistStringValues.add(a.getValue());
                picklistStringLabels.add(a.getLabel());
            }

            Results response = new Results();
            response.picklistValues = picklistStringValues;
            response.picklistLabels = picklistStringLabels;
            response.ok = true;

            responseWrapper.add(response);
        }

        return responseWrapper;
    }

    public class Requests {
        @InvocableVariable(required=true label='Object\'s API name')
        public String objectName;
        @InvocableVariable(required=true label='Object\'s field API name')
        public String fieldName;
        @InvocableVariable(label='Record Type Developer Name')
        public String recordTypeName;
    }

    public class Results {
        @InvocableVariable
        public List<String> picklistValues;
        @InvocableVariable
        public List<String> picklistLabels;
        @InvocableVariable
        public Boolean ok;
        @InvocableVariable
        public String message;
    }
}
