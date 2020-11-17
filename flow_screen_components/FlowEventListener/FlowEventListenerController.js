({
   doInit: function(component, event, helper) {
       // Get the empApi component.
       const empApi = component.find("empApi");
       // Get the channel from the input box.
       
       var channel = "/event/" + component.get("v.eventAPIName");
       const replayId = -1;
      
       // Callback function to be passed in the subscribe call.
       // After an event is received, this callback prints the event
       // payload to the console.
       const callback = function (message) {
           var cmpId = component.get("v.id");
           console.log("Event Received : " + JSON.stringify(message));
           var jsonRes = JSON.parse(JSON.stringify(message));
           var eventId = jsonRes.data.payload.id__c;
           console.log("Component Id : " + cmpId + ", Event Id : " + eventId);
           if (cmpId == eventId) {
               var flowNavigationRequest = jsonRes.data.payload.flowNavigationRequest__c;
               
               helper.unsubscribe(component, event);
               //Get the information from the platform event and store them in the component
               component.set("v.value1", jsonRes.data.payload.value1__c);
               component.set("v.value2", jsonRes.data.payload.value2__c);
               component.set("v.value3", jsonRes.data.payload.value3__c);
               component.set("v.value4", jsonRes.data.payload.value4__c);
               component.set("v.value5", jsonRes.data.payload.value5__c);
               if (flowNavigationRequest != null && flowNavigationRequest != '') {
                   component.set("v.flowNavigationRequest", flowNavigationRequest);
                   console.log("flowNavigationRequest from platform event: " + flowNavigationRequest);
               }
               helper.flowNavigate(component, event);
           }
       };
      
       // Subscribe to the channel and save the returned subscription object.
       empApi.subscribe(channel, replayId, callback).then(function(newSubscription) {
           console.log("Subscribed to channel " + channel);
           component.set("v.subscription", newSubscription);
       });
   }
})
