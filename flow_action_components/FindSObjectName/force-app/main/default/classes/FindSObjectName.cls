public with sharing class FindSObjectName {


        @InvocableMethod(
            label = 'Find Object Name'
            description = 'Find SObject Name from the Record ID of an Object'
        )
        public static List<Response> execute( List<Request> requests ) {
          
            List<Response> responses = new List<Response>();
          
            for ( Request req : requests ) {
                Id myRecordId = req.recId;
                String sObjName = myRecordId.getSObjectType().getDescribe().getName();
                
                // do something with req.recId
                
                Response res = new Response();
                res.outputValue = sObjName;
              
                responses.add( res );
                    
            }
            
            return responses;
        }
        
        // ---------------------------------------
    
        public class Request {
    
            /*
             * Each @InvocableVariable defined in this class
             * is an input variable you can populate when calling
             * this from Process Builder or Flow.
             */
    
            @InvocableVariable(
                label = 'Record ID'
                description = 'Record ID you want to find its SObject name.'
                required = true
            )
            public ID recId;
    
        }
            
        public class Response {
    
            /*
             * Each @InvocableVariable defined in this class
             * is an output variable whose value you populate
             * in your @InvocableMethod to return back to
             * Process Builder or Flow, although Flow may be
             * the only one that can do something with the response.
             * Process Builder takes more of a "fire and forget" style.
             */
    
            @InvocableVariable(
                label = 'SObject API Name'
                description = 'The SOBject API Name of the Record ID you input.'
            )
            public String outputValue;
    
        }
                
    }