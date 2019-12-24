public with sharing class ExtractFieldFromCollection {
  //given a fieldname and a collection, return a collection of strings representing the fieldname
//great for extracting the Names of SObjects from SObject Collections
//should rename this
//should support more than just string fields


    @InvocableMethod
    public static List <Results> extract(List<Requests> requestList) {
        Results response = new Results();
        List<Account> inputCollection = requestList[0].inputCollection;
        List<String> outputStringCollection = new List<String>();
        String fieldName = requestList[0].fieldName;

        if (inputCollection != null && !inputCollection.isEmpty() && fieldName != null) {
            for (Account member : inputCollection) {
                Object o = member.get(fieldName);
                outputStringCollection.add(String.valueOf(o));
            } 
        }

        response.outputStringCollection = outputStringCollection;
        List<Results> responseWrapper = new List<Results>();
        responseWrapper.add(response);

        return responseWrapper;


    }
    public class Requests {
        @InvocableVariable(required=true)
        public List<Account> inputCollection;

        @InvocableVariable(required=true)
        public String fieldName;

    }

    public class Results {

        public Results() {
            outputStringCollection = new List<String>();
        }
        @InvocableVariable
        public String errors;

        @InvocableVariable
        public List<String> outputStringCollection;
    }
}