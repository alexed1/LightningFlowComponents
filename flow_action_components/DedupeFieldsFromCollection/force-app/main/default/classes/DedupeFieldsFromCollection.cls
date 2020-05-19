global with sharing class DedupeFieldsFromCollection {
    global class DedupeFieldsException extends Exception {}
    
    @InvocableMethod(label='Dedupe Fields from Collection' description='Dedupe a list of records using a given field as the unique value and return a collection of the unique field values' category='Util')
    global static List<FlowResponse> dedupe(List<FlowRequest> requests) {
        List<FlowResponse> flowResponses = new List<FlowResponse>();
        for (FlowRequest request : requests) {
            if (request.inputRecordCollection == null || request.inputRecordCollection.size() == 0) {
                throw new DedupeFieldsException('Input record list is required, but empty');
            }
            if (request.fieldAPIName == null || request.fieldAPIName.length() == 0) {
                throw new DedupeFieldsException('Field to dedupe on is required, but empty');
            }
            if (request.dedupeValues == null) {
                request.dedupeValues = true;
            }
            FlowResponse flowResponse = new FlowResponse();
            flowResponse.fieldValueCollection = getUniqueTextCollection(request);
            flowResponse.fieldValueString = String.join(flowResponse.fieldValueCollection, ',');
            flowResponses.add(flowResponse);
        }
        return flowResponses;
    }

    private static List<String> getUniqueTextCollection(FlowRequest request) {
        Set<String> stringsSet = new Set<String>();
        List<String> stringsList = new List<String>{};
        for (SObject record : request.inputRecordCollection) {
            String fieldValue = String.valueOf(record.get(request.fieldAPIName));
            if (fieldValue != null) {
                if (request.dedupeValues) {
                    stringsSet.add(fieldValue);
                } else {
                    stringsList.add(fieldValue);
                }
            }
        }
        return request.dedupeValues ? new List<String>(stringsSet): stringsList;
    }

    global class FlowRequest {
        @InvocableVariable(description='List of records to extract field values from' required=true)
        global List<SObject> inputRecordCollection;
        
        @InvocableVariable(description='API name of the field' required=true)
        global String fieldAPIName;

        @InvocableVariable(description='If true only unique values will be returned. The default value is true')
        global Boolean dedupeValues;
    }

    global class FlowResponse {
        @InvocableVariable(description='List of unique field values for API name provided')
        global List<String> fieldValueCollection;

        @InvocableVariable(description='Comma separated string of unique field values for API name provided')
        global String fieldValueString;
    }
}