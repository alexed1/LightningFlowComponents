global with sharing class DedupeRecordCollection {
    global class DedupeRecordException extends Exception {}

    @InvocableMethod(label='Dedupe Records from Collection' description='Dedupe a list of records using a given field as the unique value and return the unique collection of records' category='Util')
    global static List<FlowResponse> dedupe(List<FlowRequest> requests) {
        List<FlowResponse> flowResponses = new List<FlowResponse>();
        for (FlowRequest request : requests) {
            FlowResponse flowResponse = new FlowResponse();
            if (request.inputRecordCollection == null || request.inputRecordCollection.size() == 0) {
                throw new DedupeRecordException('Input record list is required, but empty');
            }
            if (request.fieldToDedupeOn == null || request.fieldToDedupeOn.length() == 0) {
                throw new DedupeRecordException('Field to dedupe on is required, but empty');
            }
            flowResponse.outputRecordCollection = getUniqueSObjectCollection(request);
            flowResponses.add(flowResponse);
        }
        return flowResponses;
    }

    private static List<SObject> getUniqueSObjectCollection(FlowRequest request) {
        Map<String, SObject> sobjectMap = new Map<String, SObject>();
        for (SObject record : request.inputRecordCollection) {
            String fieldValue = String.valueOf(record.get(request.fieldToDedupeOn));
            if (fieldValue == null) {
                if (!sobjectMap.containsKey('null')) {
                    sobjectMap.put('null', record);
                }
            } else if (!sobjectMap.containsKey(fieldValue)) {
                sobjectMap.put(fieldValue, record);
            }
        }
        return sobjectMap.values();
    }

    global class FlowRequest {
        @InvocableVariable(description='List of records to dedupe on' required=true)
        global List<SObject> inputRecordCollection;
        
        @InvocableVariable(description='API name of the field to dedupe on' required=true)
        global String fieldToDedupeOn;
    }

    global class FlowResponse {
        @InvocableVariable(description='List of unique records, removing duplicates on the field name provided')
        global List<SObject> outputRecordCollection;
    }
}
