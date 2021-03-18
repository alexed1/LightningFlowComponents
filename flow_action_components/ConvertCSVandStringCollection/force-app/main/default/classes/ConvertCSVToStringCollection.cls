public with sharing class ConvertCSVToStringCollection {

    @invocableMethod(label='Convert Comma-separated-values to String Collection')
    public static List<Response> execute (List<Request> requests) {

        List<Response> responseList = new List<Response>();
        for (Request curRequest : requests) {

            Response response = new Response();
            response.stringCollection = curRequest.csvString?.split(',');
            responseList.add(response);
        }

        return responseList;
    }

    public class Request {
        @invocableVariable
        public String csvString;
    }

    public class Response {
        @invocableVariable
        public List<String> stringCollection;

    }
}
