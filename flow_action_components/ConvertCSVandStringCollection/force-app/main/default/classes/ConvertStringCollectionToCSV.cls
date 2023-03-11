public with sharing class ConvertStringCollectionToCSV {

    @invocableMethod(label='Convert String Collection to Comma-separated-values' 
                     description='Converts a String Collection to Comma-separated-values string' 
                     category= 'Utilities')
    public static List<Response> execute (List<Request> requests) {

        List<Response> responseList = new List<Response>();
        for (Request curRequest : requests) {
            if(curRequest.delimiter == null) {
                curRequest.delimiter = ',';
            }

            Response response = new Response();

            List<String> stringCollection = curRequest.stringCollection;
            response.csvString = String.join(stringCollection, curRequest.delimiter);
            responseList.add(response);
        }

        return responseList;
    }

    public class Request {
        @invocableVariable(label='String Collection' description='Input' required=true)
        public List<String> stringCollection;
        
        @invocableVariable(label='Delimiter' description='Delimiter string; defaults to comma (,)' required=false)
        public String delimiter;
    }

    public class Response {
        @invocableVariable(label='String' description='String variable to store output')
        public String csvString;
    }

}
