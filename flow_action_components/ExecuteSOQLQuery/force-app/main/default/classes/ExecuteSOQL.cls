public with sharing class ExecuteSOQL {
    @InvocableMethod
    public static List <Results> getEligibleProducts(List<Requests> requestList) {

        Results results = new Results();
        List<Results> responseWrapper = new List<Results>();
        String soqlQuery = requestList[0].soqlQuery;
        results.sObjects = Database.query(soqlQuery);
        responseWrapper.add(results);
        return responseWrapper;
    }

    public class Requests {
        @InvocableVariable(required=true)
        public String soqlQuery;
    }

    public class Results {
        public Results() {
            sObjects = new List<SObject>();
        }
        @InvocableVariable
        public List<SObject> sObjects;

    }
}