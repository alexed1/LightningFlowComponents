public with sharing class ExecuteSOQL {
    @InvocableMethod
    public static List <Results> getEligibleProducts(List<Requests> requestList) {

        Results results = new Results();
        List<Results> responseWrapper = new List<Results>();
        String queryString = requestList[0].queryString;
        results.sObjects = Database.query(queryString);
        responseWrapper.add(results);
        return responseWrapper;
    }

    public class Requests {
        @InvocableVariable(required=true)
        public String queryString;
    }

    public class Results {
        public Results() {
            sObjects = new List<SObject>();
        }
        @InvocableVariable
        public List<SObject> sObjects;

    }
}