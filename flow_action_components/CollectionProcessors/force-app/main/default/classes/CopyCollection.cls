global with sharing class CopyCollection {
    @InvocableMethod
    global static List <Results> copyCollection(List<Requests> requestList) {

        Results response = new Results();
        List<SObject> inputCollection = requestList[0].inputCollection;

        if (inputCollection != null && !inputCollection.isEmpty()) {
            response.outputCollection = inputCollection.clone();
        }

        List<Results> responseWrapper = new List<Results>();
        responseWrapper.add(response);

        return responseWrapper;
    }

    global class Requests {
        @InvocableVariable(required=true)
        global List<SObject> inputCollection;
    }

    global class Results {

        public Results() {
            outputCollection = new List<SObject>();
        }

        @InvocableVariable
        global List<SObject> outputCollection;
    }
}