global with sharing class RemoveRecordInCollection {
    @InvocableMethod
    global static List <Results> removeRecordByIndex(List<Requests> requestList) {
        List<Results> responseWrapper = new List<Results>();

        for (Requests curRequest : requestList) {
            Results response = new Results();

            if (curRequest.inputCollection != null && !curRequest.inputCollection.isEmpty()) {
                response.outputCollection.addAll(curRequest.inputCollection);
            }
    
            if (curRequest.index != null && curRequest.index < response.outputCollection.size()) {
                response.outputCollection.remove(curRequest.index);
            }
    

            responseWrapper.add(response);
        }


       

        return responseWrapper;
    }

    global class Requests {
        @InvocableVariable(required=true)
        global List<SObject> inputCollection;
        @InvocableVariable(required=true)
        global Integer index;
    }

    global class Results {

        public Results() {
            outputCollection = new List<SObject>();
        }

        @InvocableVariable
        global List<SObject> outputCollection;
    }
}