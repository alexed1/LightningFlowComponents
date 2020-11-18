({ 
    flowNavigate : function(component, event) {
        var flowNavigationRequest = component.get("v.flowNavigationRequest");
        var navigate = component.get("v.navigateFlow");
        
        switch(flowNavigationRequest) {
            case "next":
                console.log("FlowEventListener : navigate next");
                navigate("NEXT");
                break;
            case "back":
                console.log("FlowEventListener : navigate back");
                navigate("BACK");
                break;
            case "pause":
                console.log("FlowEventListener : navigate pause");
                navigate("PAUSE");
                break;
            case "end":
                console.log("FlowEventListener : navigate end");
                navigate("FINISH");
                break;
            default:
                console.log("FlowEventListener : navigate none");
        }
    },
  
   // Invokes the unsubscribe method on the empApi component
   unsubscribe : function(component, event) {
       // Get the empApi component
       const empApi = component.find('empApi');
       // Get the subscription that we saved when subscribing
       const subscription = component.get('v.subscription');
      
       // Unsubscribe from event
       empApi.unsubscribe(subscription, $A.getCallback(unsubscribed => {
           // Confirm that we have unsubscribed from the event channel
           console.log('Unsubscribed from channel '+ unsubscribed.subscription);
           component.set('v.subscription', null);
       }));      
   }
})
