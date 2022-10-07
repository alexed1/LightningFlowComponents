global with sharing class ModifyFlowMetadata {

    @InvocableMethod
    global static List <Result> execute(List<Request> requestList) {
     
    
    List<Result> responses = new List<Result>();
    for (Request curRequest: requestList ){
        Result curResult = new Result();
        //call MetadataUtils to get the FlowMetadata
        //apply the change list
        responses.add(curResult);
    }
            
      
    return responses;
    }
    


    

    global class Request {
      

        @InvocableVariable(required=true)
        global String flowName;

        @InvocableVariable(required=true)
        global String entityPath1;

        @InvocableVariable(required=true)
        global String value1;

        @InvocableVariable
        global String entityPath2;

        @InvocableVariable
        global String value2;

        @InvocableVariable
        global String entityPath3;

        @InvocableVariable
        global String value3;

        @InvocableVariable
        global String entityPath4;

        @InvocableVariable
        global String value4;

        @InvocableVariable
        global String entityPath5;

        @InvocableVariable
        global String value5;

        @InvocableVariable
        global String action; //expects enum values 'clone', 'overwrite' or 'none' default is 'clone'

        @InvocableVariable
        global String newFlowName; //expects enum values 'clone', 'overwrite' or 'none' default is 'clone'

    }

    global class Result {


        @InvocableVariable
        global usf3.MetadataService.Flow modifiedFlowMetadata;

        @InvocableVariable
        global String errors;



    }
    public class InvocableActionException extends Exception{}
}
