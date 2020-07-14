global with sharing class MapFields {

    private static final String INPUT_TYPE_SINGLE = 'single';
    private static final String INPUT_TYPE_COLLECTION = 'collection';
    private static final String INPUT_TYPE_APEX = 'apex';
    private static final Map<SObjectType, Map<String, String>> OBJECT_FIELD_TYPE_MAP = new Map<SObjectType, Map<String, String>>();

    @InvocableMethod(label='Map Fields')
    global static List <Result> mapFields(List<Request> requestList) {

        List<Result> responseWrapper = new List<Result>();

        for (Request curRequest : requestList) {
            List<SObject> inputSObjectCollection = new List<SObject>();
            List<SObject> outputSObjectCollection = new List<SObject>();
            String inputType = verifyRequest(curRequest, inputSObjectCollection, outputSObjectCollection);

            Map<String, String> fieldMappings = (Map<String, String>) JSON.deserialize(curRequest.fieldMappings, Map<String, String>.class);
            List<String> inputFields = new List<String>(fieldMappings.keySet());
            List<String> outputFields = new List<String>();
            for (String curInoutField : inputFields) {
                outputFields.add(fieldMappings.get(curInoutField));
            }
            Map<String, String> inputFieldTypesMap = getFieldTypesBySObject(inputSObjectCollection[0], inputFields);
            Map<String, String> outputFieldTypesMap = getFieldTypesBySObject(outputSObjectCollection[0], outputFields);

            Result response = new Result();

            for (Integer objectIndex = 0; objectIndex < inputSObjectCollection.size(); objectIndex++) {
                for (Integer fieldIndex = 0; fieldIndex < inputFields.size(); fieldIndex++) {
                    String inputFieldName = inputFields[fieldIndex];
                    String outputFieldName = outputFields[fieldIndex];
                    try {
                        putType(
                                outputSObjectCollection[objectIndex],
                                outputFieldName,
                                inputFieldTypesMap.get(inputFieldName),
                                outputFieldTypesMap.get(outputFieldName),
                                inputSObjectCollection[objectIndex].get(inputFieldName)
                        );
                    } catch (Exception ex) {
                        response.errors += ex.getMessage();
                    }

                }
            }
            if (inputType == INPUT_TYPE_COLLECTION) {
                response.outputSObjectCollection = outputSObjectCollection;
            } else if (inputType == INPUT_TYPE_SINGLE) {
                response.outputSObject = outputSObjectCollection[0];
            }

            responseWrapper.add(response);
        }
        return responseWrapper;
    }

    private static Map<String, String> getFieldTypesBySObject(SObject curSObject, List<String> inputFields) {
        SObjectType curType = curSObject.getSObjectType();
        if (!OBJECT_FIELD_TYPE_MAP.containsKey(curType)) {
            OBJECT_FIELD_TYPE_MAP.put(curType, CollectionProcessorsUtils.getFieldTypes(curSObject, inputFields));
        }

        return OBJECT_FIELD_TYPE_MAP.get(curType);
    }

    private static String verifyRequest(Request curRequest, List<SObject> inputSObjectCollection, List<SObject> outputSObjectCollection) {
        if (curRequest.inputSObjectCollection == null && curRequest.outputSObjectCollection == null && curRequest.inputSObject != null && curRequest.outputSObject != null) {
            inputSObjectCollection.add(curRequest.inputSObject);
            outputSObjectCollection.add(curRequest.outputSObject);
            return INPUT_TYPE_SINGLE;
        } else if (curRequest.inputSObjectCollection != null && curRequest.outputSObjectCollection != null && curRequest.inputSObject == null && curRequest.outputSObject == null) {
            if (curRequest.inputSObjectCollection.size() != curRequest.outputSObjectCollection.size()) {
                throw new InvocableActionException('Size of input and output collections does not match');
            }
            inputSObjectCollection.addAll(curRequest.inputSObjectCollection);
            outputSObjectCollection.addAll(curRequest.outputSObjectCollection);
            return INPUT_TYPE_COLLECTION;
        } else {
            throw new InvocableActionException('You can specify either single SObject or collection, but you can not specify both');
        }
    }

    private static void putType(SObject obj, String fieldName, String inputFieldType, String outputFieldType, Object fieldValue) {
        if (outputFieldType == 'STRING') {
            obj.put(fieldName, String.valueOf(fieldValue));
        } else if (inputFieldType == 'DATETIME' && outputFieldType == 'DATE') {
            obj.put(fieldName, ((Datetime) fieldValue).date());
        } else {
            obj.put(fieldName, fieldValue);
        }
    }


    global class Request {

        @InvocableVariable(required=false)
        global SObject inputSObject;
        @InvocableVariable(required=false)
        global List<SObject> inputSObjectCollection;
        @InvocableVariable(required=false)
        global SObject outputSObject;
        @InvocableVariable(required=false)
        global List<SObject> outputSObjectCollection;
        @InvocableVariable(required=false)
        global String fieldMappings;
    }

    global class Result {
        @InvocableVariable(required=false)
        global SObject outputSObject;
        @InvocableVariable(required=false)
        global List<SObject> outputSObjectCollection;
        @InvocableVariable
        global String errors;
    }

    global class InvocableActionException extends Exception {
    }
}