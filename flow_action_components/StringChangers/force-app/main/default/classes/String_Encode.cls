public with sharing class String_Encode {

     @invocableMethod(label='URL Encode String' description='This replaces spaces and other characters that are not allowed in urls with placeholders')
     public static List<Response> encodeStringForURL(List<Request> request) {
        Response response = new Response();
        String inputStr = request[0].inputStr;
        String curEncoding = request[0].curEncoding;
     

        response.outputStr = EncodingUtil.urlEncode(inputStr, curEncoding);

        //package up the response
        List<Response> responseList = new List<Response>();
        responseList.add(response);
        return responseList;
    }


     public class Request {
        @invocableVariable
        public String inputStr;

        @invocableVariable
        public String curEncoding = 'UTF-8';

    }

    public class Response {
        @invocableVariable
        public String outputStr;

    }
}
