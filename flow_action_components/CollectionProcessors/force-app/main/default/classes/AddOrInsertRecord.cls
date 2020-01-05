global with sharing class AddOrInsertRecord {
    @InvocableMethod
    global static List <Results> addOrInsertRecord(List<Requests> requestList) {

        Results response = new Results();
        List<SObject> inputCollection = requestList[0].inputCollection;
        SObject inputRecord = requestList[0].inputRecord;
        Integer index = requestList[0].index;

        if (inputCollection != null && inputRecord != null) {
            if (index == null || index >= inputCollection.size()) {
                inputCollection.add(inputRecord);
            } else {
                inputCollection.add(index, inputRecord);
            }
            response.outputCollection = inputCollection.clone();
        }

        List<Results> responseWrapper = new List<Results>();
        responseWrapper.add(response);

        return responseWrapper;
    }

    global class Requests {
        @InvocableVariable(required=true)
        global List<SObject> inputCollection;
        @InvocableVariable(required=true)
        global SObject inputRecord;
        @InvocableVariable
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