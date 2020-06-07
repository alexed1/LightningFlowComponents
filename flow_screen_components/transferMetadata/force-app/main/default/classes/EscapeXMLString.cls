public with sharing class EscapeXMLString {

    @invocableMethod
    public static List<Result> escape(List<Request> requests) {
        List<Result> responseWrapper = new List<Result>();

        for (Request curRequest : requests) {
            Result curResult = new Result();
            String processedString = curRequest.unescapedString;
            System.debug ('initial: ' + processedString);
            processedString = processedString.replace('<', '&lt;');
            System.debug ('replace lt: ' + processedString);
            processedString = processedString.replace('>', '&gt;');
            System.debug ('replace gt: ' + processedString);
            curResult.escapedString = processedString;
            responseWrapper.add(curResult);
        }

        return responseWrapper;

    }

     

    public class Request {
       

        @InvocableVariable 
        public String unescapedString;
      

    }

    public class Result {

        @InvocableVariable
        public String errors;

       
        @InvocableVariable
        public String escapedString;

    }

    public class InvocableActionException extends Exception{}
}
