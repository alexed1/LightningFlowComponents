public with sharing class NotifyOrchestrationViaEvent {
    
    @invocableMethod(label='Notify Orchestration via Event' description='Used by Orchestrator to wake up an orchestration and pass it any outputs provided by the flow that dispatches this event. Note that this will become automatic starting in Summer 21')
    public static List<Response> execute(List<Request> requests) {
        
        List<Response> result = new List<Response>();

        for (Request curRequest : requests) {
            
            Response curResponse = new Response();
            
            // create event info                          
            ConnectApi.OrchestrationEventInfo eventInfo = new ConnectApi.OrchestrationEventInfo();
            // set parameters
            eventInfo.orchestrationInstanceId = curRequest.orchestrationInstanceId;
            eventInfo.workStatus = ConnectApi.OrchestrationWorkStatus.FlowCompleted;
            eventInfo.stageStepInstanceId = curRequest.orchestrationStepInstanceId;
            eventInfo.workAssignmentId = curRequest.orchestrationWorkItemId;
            // publish event
            ConnectApi.OrchestrationEvent event =
            ConnectApi.Orchestrator.publishOrchestrationEvent(eventInfo);

      
            

            curResponse.workStatus = event.workStatus.name();
            result.add(curResponse);
    
        }
        return result;
        }
    
         
        
        /* Input parameters for the Apex action */
        public class Request{
            @InvocableVariable(label='Orchestration Instance Id: this is passed into Step Flows with the label "appProcessInstanceId" ' required = true )
            public string orchestrationInstanceId; 
            
            @InvocableVariable(label='Orchestration Step Id. This is the step that will be marked completed by this event' required = true )
            public string orchestrationStepInstanceId;
            
            //if this is needed, will have to pass it in via the work guide, as the process type doesn't currently hand it over
            @InvocableVariable(label='Orchestration WorkId' required = true)
            public string orchestrationWorkItemId;
            
             
        }
        
        /* Output parameters of the Apex action */
        public class Response{
            @InvocableVariable(label='Confirms that work has been marked completed')
            public String workStatus; 
            
            
        }
    
        public class InvocableActionException extends Exception{}
        
    }