global with sharing class ConvertStringCollectionToCSV_CP {

    @invocableMethod(   label='Convert String Collection to Comma-separated-values [USF Collection Processor]' 
                        description='Converts a String Collection to Comma-separated-values string' 
                        category= 'Util'
                        iconName='resource:CollectionProcessorsSVG:colproc')

    global static List<Response> execute (List<Request> requests) {

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

    global class Request {
        @invocableVariable(label='String Collection' description='Input' required=true)
        global List<String> stringCollection;
        
        @invocableVariable(label='Delimiter' description='Delimiter string; defaults to comma (,)' required=false)
        global String delimiter;
    }

    global class Response {
        @invocableVariable(label='String' description='String variable to store output')
        global String csvString;
    }

}
