global with sharing class GenerateFieldMap {
    @InvocableMethod(label='Generate Field Map' configurationEditor='c:generateFieldMapCPE')
    global static List <Result> generateFieldMap(List<Request> requestList) {

        List<Result> responseWrapper = new List<Result>();

        for (Request curRequest : requestList) {
            Result response = new Result();
            response.outputMapJson = curRequest.inputMapJson;
            responseWrapper.add(response);
        }

        return responseWrapper;
    }

    global class Request {

        @InvocableVariable(required=false)
        global String inputMapJson;
        @InvocableVariable(required=false)
        global String inputDataType;
        @InvocableVariable(required=false)
        global String inputObject;
        @InvocableVariable(required=false)
        global String outputDataType;
        @InvocableVariable(required=false)
        global String outputObject;
    }

    global class Result {

        @InvocableVariable(required=false)
        global String outputMapJson;
    }
}