({
    
    
    
   invoke : function(component, event, helper) {
    	var args = event.getParam("arguments");
        var callback = args.callback;

  		component.find("recordLoader").reloadRecord(true, $A.getCallback(function() {
			// ignore errors, we don't want to stop the flow if we cannot refresh the record
			callback("SUCCESS");
		}));
   },
        
    
    handleRecordUpdated: function(component, event, helper) {
        var eventParams = event.getParams();
        if(eventParams.changeType === "LOADED") {
           // record is loaded (render other component which needs record data value)
            console.log("Record is loaded successfully.");
        } else if(eventParams.changeType === "CHANGED") {
            // record is changed
        } else if(eventParams.changeType === "REMOVED") {
            // record is deleted
        } else if(eventParams.changeType === "ERROR") {
            // there’s an error while loading, saving, or deleting the record
        }
    }
})