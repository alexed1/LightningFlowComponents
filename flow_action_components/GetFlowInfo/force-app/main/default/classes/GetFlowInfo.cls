
global with sharing class GetFlowInfo { 
    
    @invocableMethod
    public static List<Response> executeGetFlowInfo(List<Request> requests ) {
        System.debug('entering getFlowInfo');
        String ApiName = requests[0].FlowApiName;
        String DefinitionId = requests[0].FlowDefinitionId;
        FlowDefinitionView curFlow;

        if ((ApiName != null) && (DefinitionId != null)) {
            curFlow  = [SELECT Id,ApiName,Label, ActiveVersionId,Description,DurableId,LatestVersionId,NamespacePrefix,ProcessType FROM FlowDefinitionView WHERE DurableId = :DefinitionId AND ApiName = :ApiName];
        } else if (ApiName != null){
            curFlow  = [SELECT Id,ApiName,Label, ActiveVersionId,Description,DurableId,LatestVersionId,NamespacePrefix,ProcessType FROM FlowDefinitionView WHERE ApiName = :ApiName];
        } else if (DefinitionId != null) {
            curFlow  = [SELECT Id,ApiName,Label, ActiveVersionId,Description,DurableId,LatestVersionId,NamespacePrefix,ProcessType FROM FlowDefinitionView WHERE DurableId = :DefinitionId];
        } else throw new FlowActionException('When calling the GetFlowInfo Flow Action, at least one of ApiName or DefinitionId must be provided. Currently both are coming through null.'); 
        
        System.debug('curFlows is: ' + curFlow);

        //report back the results
        Response response = new Response();
        response.FlowApiName = curFlow.ApiName;
        response.FlowDefinitionId = curFlow.DurableId;
        response.ActiveVersionId = curFlow.ActiveVersionId;
        response.Description = curFlow.Description;
        response.Label = curFlow.Label;
        response.LatestVersionId = curFlow.LatestVersionId;
        response.NamespacePrefix = curFlow.NamespacePrefix;
        response.FlowType = curFlow.ProcessType;
     
        List<Response> responseList = new List<Response>();
        responseList.add(response);
        return responseList;
    }

    
   

    public class Request {
        @invocableVariable
        public String FlowApiName;

        @invocableVariable
        public String FlowDefinitionId;
 
    }

    public class Response {
        @invocableVariable
        public String FlowApiName;

        @invocableVariable
        public String FlowDefinitionId; 
        
        @invocableVariable
        public String ActiveVersionId; 

        @invocableVariable
        public String Description; 

        @invocableVariable
        public String Label; 

        @invocableVariable
        public String LatestVersionId; 

        @invocableVariable
        public String NamespacePrefix; 

        @invocableVariable
        public String FlowType; 

    }
            
	public class FlowActionException extends Exception {}

    
}
