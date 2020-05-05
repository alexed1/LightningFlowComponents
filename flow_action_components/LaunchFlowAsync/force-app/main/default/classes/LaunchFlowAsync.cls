public with sharing class LaunchFlowAsync {
  

        @invocableMethod(label = 'Launch Flow Asynchronously' )
        public static List<Response> mainLaunch(List<Request> requests) {
    
            Response response = new Response();
            List<Response> responseWrapper = new List<Response>();
            
            for (Request req : requests) {
                String flowName = req.flowName;
                 
                futureLaunch(flowName);

                responseWrapper.add(response);
            }
            return responseWrapper;
        }


        @future(callout=true)
        public static void futureLaunch(String flowName) {
            Map<String, Object> inputs = new Map<String, Object>();
            Flow.Interview myFlow = Flow.Interview.createInterview( flowName, inputs);
            myFlow.start();
        }

        public class Request {
            @invocableVariable
            public String flowName;
    
    
        }
    
        public class Response {
            @invocableVariable
            public Boolean isSuccess;
    
            @invocableVariable
            public String errors;
    
        }
    
        public class InvocableActionException extends Exception {
        }
    
    
    }