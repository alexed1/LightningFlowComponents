global with sharing class JoinCollections {
    @InvocableMethod
    global static List <Results> joinCollections(List<Requests> requestList) {

        Results response = new Results();
        if (requestList[0].inputCollection != null && !requestList[0].inputCollection.isEmpty()) {
            response.outputCollection.addAll(requestList[0].inputCollection);
        }
        if (requestList[0].inputCollection2 != null && !requestList[0].inputCollection2.isEmpty()) {
            response.outputCollection.addAll(requestList[0].inputCollection2);
        }

        List<Results> responseWrapper = new List<Results>();
        responseWrapper.add(response);

        return responseWrapper;
    }

    global class Requests {
        @InvocableVariable(required=true)
        public List<SObject> inputCollection;
        @InvocableVariable(required=true)
        public List<SObject> inputCollection2;
    }

    global class Results {

        public Results() {
            outputCollection = new List<SObject>();
        }

        @InvocableVariable
        public List<SObject> outputCollection;
    }
}