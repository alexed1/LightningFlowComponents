@SuppressWarnings('PMD.AvoidGlobalModifier')
global with sharing class DedupeRecordCollection {

    @InvocableMethod(Label='Dedupe Record Collection [USF Collection Processor]' Category='Util' IconName='resource:CollectionProcessorsSVG:colproc')
    global static List<FlowResponse> dedupe(List<FlowRequest> requests) {
        List<FlowResponse> flowResponses = new List<FlowResponse>();
        for (FlowRequest request : requests) {
            FlowResponse flowResponse = new FlowResponse();
            flowResponse.outputRecordCollection = getUniqueSObjectCollection(request);
            flowResponses.add(flowResponse);
        }
        return flowResponses;
    }

    @TestVisible
    private static List<SObject> getUniqueSObjectCollection(FlowRequest request) {
        Map<String, SObject> sobjectMap = new Map<String, SObject>();
        for (SObject record : request.inputRecordCollection) {
            try {
                String fieldValue = String.valueOf(record.get(request.fieldToDedupeOn));
                if(!sobjectMap.containsKey(fieldValue)) {
                    sobjectMap.put(fieldValue, record);
                }
            } catch(SObjectException e) {
                System.debug(e.getMessage());
            }
        }
        return sobjectMap.values();
    }

    global class FlowRequest {

        @InvocableVariable(Required=true)
        global List<SObject> inputRecordCollection;
        
        @InvocableVariable(Required=true)
        global String fieldToDedupeOn;
    }

    global class FlowResponse {

        public FlowResponse() {
            outputRecordCollection = new List<SObject>();
        }

        @InvocableVariable
        global List<SObject> outputRecordCollection;

    }
}
