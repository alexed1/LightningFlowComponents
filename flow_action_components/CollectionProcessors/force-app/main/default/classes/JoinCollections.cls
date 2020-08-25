global with sharing class JoinCollections {
    @InvocableMethod
    global static List <Results> joinCollections(List<Requests> requestList) {

        List<Results> responseWrapper = new List<Results>();
        for (Requests curRequest : requestList) {
            Results response = new Results();
            if (curRequest.inputCollection != null && !curRequest.inputCollection.isEmpty()) {
                response.outputCollection.addAll(curRequest.inputCollection);
            }
            if (curRequest.inputCollection2 != null && !curRequest.inputCollection2.isEmpty()) {
                response.outputCollection.addAll(curRequest.inputCollection2);
            }
    
            responseWrapper.add(response);

        }
       

        return responseWrapper;
    }

    global class Requests {
        @InvocableVariable(required=true)
        global List<SObject> inputCollection;
        @InvocableVariable(required=true)
        global List<SObject> inputCollection2;
    }

    global class Results {

        public Results() {
            outputCollection = new List<SObject>();
        }

        @InvocableVariable
        global List<SObject> outputCollection;
    }
}