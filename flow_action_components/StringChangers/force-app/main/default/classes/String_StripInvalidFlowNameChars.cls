public with sharing class String_StripInvalidFlowNameChars {

 @InvocableMethod
    public static List <Result> execute(List<Request> requestList) {
        List<Result> responses = new List<Result>();

        for (Request curRequest: requestList ){
            Result curResult = new Result();
            String inputStr = curRequest.inputStr;
            Result curResponse = new Result();
            Pattern nonAlphanumeric = Pattern.compile('[^a-zA-Z0-9_]');
            Matcher matcher = nonAlphanumeric.matcher(inputStr);
            
            curResult.outputStr = matcher.replaceAll('');
            System.debug ('input is: ' + inputStr + ' and output is ' + curResult.outputStr);
            responses.add(curResult);    
        }
    

            return responses;
        
        }
        

    public class Request {
        @invocableVariable
        public String inputStr;



    }

    public class Result {
        @invocableVariable
        public String outputStr;

    }
}
