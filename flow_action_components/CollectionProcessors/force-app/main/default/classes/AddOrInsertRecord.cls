public with sharing class AddOrInsertRecord {
    @InvocableMethod
    public static List <Results> addOrInsertRecord(List<Requests> requestList) {

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

    public class Requests {
        @InvocableVariable(required=true)
        public List<SObject> inputCollection;
        @InvocableVariable(required=true)
        public SObject inputRecord;
        @InvocableVariable
        public Integer index;
    }

    public class Results {

        public Results() {
            outputCollection = new List<SObject>();
        }

        @InvocableVariable
        public List<SObject> outputCollection;
    }
}