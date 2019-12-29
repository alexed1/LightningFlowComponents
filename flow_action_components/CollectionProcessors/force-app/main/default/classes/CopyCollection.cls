public with sharing class CopyCollection {
    @InvocableMethod
    public static List <Results> copyCollection(List<Requests> requestList) {

        Results response = new Results();
        List<SObject> inputCollection = requestList[0].inputCollection;

        if (inputCollection != null && !inputCollection.isEmpty()) {
            response.outputCollection = inputCollection.clone();
        }

        List<Results> responseWrapper = new List<Results>();
        responseWrapper.add(response);

        return responseWrapper;
    }

    public class Requests {
        @InvocableVariable(required=true)
        public List<SObject> inputCollection;
    }

    public class Results {

        public Results() {
            outputCollection = new List<SObject>();
        }

        @InvocableVariable
        public List<SObject> outputCollection;
    }
}