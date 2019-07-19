public with sharing class String_Numeralize {

    @invocableMethod(label='Numeralize String')
    public static List<Response>  numeralize(List<Request> request) {
        Response response = new Response();
        String inputStr = request[0].inputStr;
        String type = request[0].type;

        switch on type {
            when 'commas' {
                response.outputStr = Integer.valueOf(inputStr).format();
            }
            when else {
                
            }
        }

        //package up the response
        List<Response> responseList = new List<Response>();
        responseList.add(response);
        return responseList;
    }

    public class Request {
        @invocableVariable
        public String inputStr;

        @invocableVariable
        public String type;

    }

    public class Response {
        @invocableVariable
        public String outputStr;

    }

   
}
