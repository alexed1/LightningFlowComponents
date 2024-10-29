global with sharing class ConvertCSVToStringCollection {

    @invocableMethod(label='Convert Comma-separated-values to String Collection'
                     description='Converts a Comma-separated-values string (eg, from a field) to a String Collection' 
                     category= 'Utilities')
    global static List<Response> execute (List<Request> requests) {

        List<Response> responseList = new List<Response>();
        for (Request curRequest : requests) {
            if(curRequest.delimiter == null) {
                curRequest.delimiter = ',';
            }

            Response response = new Response();
            response.stringCollection = curRequest.csvString?.split(curRequest.delimiter);
            responseList.add(response);
        }

        return responseList;
    }

    global class Request {
        @invocableVariable(label='Input String' description='Input' required=true)
        global String csvString;
        
        @invocableVariable(label='Delimiter' description='Delimiter string; defaults to comma (,)' required=false)
        global String delimiter;
    }

    global class Response {
        @invocableVariable(label='String Collection' description='Collection variable to store output')
        global List<String> stringCollection;

    }
}
