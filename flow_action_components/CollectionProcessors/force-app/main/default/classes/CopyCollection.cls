global with sharing class CopyCollection {
    @InvocableMethod
    global static List <Results> copyCollection(List<Requests> requestList) {
        
        List<Results> responseWrapper = new List<Results>();
        for (Requests curRequest : requestList) {
            Results response = new Results();

            List<SObject> inputCollection = curRequest.inputCollection;
    
            if (inputCollection != null && !inputCollection.isEmpty()) {
                response.outputCollection = inputCollection.clone();
            }
    
            responseWrapper.add(response);
        }
      

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