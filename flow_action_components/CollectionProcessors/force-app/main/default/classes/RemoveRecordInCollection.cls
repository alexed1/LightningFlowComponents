public with sharing class RemoveRecordInCollection {
    @InvocableMethod
    public static List <Results> removeRecordByIndex(List<Requests> requestList) {

        Results response = new Results();

        if (requestList[0].inputCollection != null && !requestList[0].inputCollection.isEmpty()) {
            response.outputCollection.addAll(requestList[0].inputCollection);
        }

        if (requestList[0].index != null && requestList[0].index < response.outputCollection.size()) {
            response.outputCollection.remove(requestList[0].index);
        }

        List<Results> responseWrapper = new List<Results>();
        responseWrapper.add(response);

        return responseWrapper;
    }

    public class Requests {
        @InvocableVariable(required=true)
        public List<SObject> inputCollection;
        @InvocableVariable(required=true)
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