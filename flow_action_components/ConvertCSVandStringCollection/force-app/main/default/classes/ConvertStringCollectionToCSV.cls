public with sharing class ConvertStringCollectionToCSV {
    @invocableMethod(label='Convert String Collection to Comma-separated-values' )
    public static List<Response> execute (List<Request> requests) {

        List<Response> responseList = new List<Response>();

        for (Request curRequest : requests) {
            Response response = new Response();
            
            List<String> stringCollection = curRequest.stringCollection;
            String csvString;
            response.csvString = String.join(stringCollection, ',');
            responseList.add(response);
        }

        return responseList;
    }


    public class Request {
       
        @invocableVariable
        public List<String> stringCollection;
 
    }

    public class Response {
        @invocableVariable
        public String csvString;
        
    }

    public class InvocableActionException extends Exception {
    }

}
