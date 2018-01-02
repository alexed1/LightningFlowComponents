({
    //because the child controls are dynamically injected, we need to here fire an event to let
    // the main component know that the value has changed, so the main storage attribute can be updated
    
    init : function(cmp, evt, helper) {
        console.log("child control initing");
         var updateEvent = cmp.getEvent("childControlVisibilityUpdateEvent");
            //updateEvent.setParams({"childControlName" : childComponentVisibilityAttributeName});
            //updateEvent.setParams({"childControlVisbility" : newVisibility});
            updateEvent.fire();
    },
    
	onChildControlClick : function(cmp, evt, helper) {
        console.log("in onChildControlClick in dyncmp");
		var clickedControl = evt.getSource();
        //we assemble the name of the storage attribute that we'll use to publish the value to the flow
         var attributeName = "v.value";
         cmp.set(attributeName, clickedControl.get("v.value"));
        console.log("setting value of vstorage to: " +clickedControl.get("v.value"));
        console.log("verification. vstorage is: " + cmp.get("v.value"));

       
	},
    
    //when the local storage attribute changes, fire an event so the parent finds out about it
    handleStorageValueChange : function(cmp, evt, helper) {
        
        console.log("in handleStorageValueChange");
        //may not need these params at all
         //compEvent.setParams({"childControlName" : cmp.get("v.name")});
         //compEvent.setParams({"childControlValue" : evt.getParam("value") });
        var compEvent = cmp.getEvent("ChildControlClicked");      
        console.log("childControlName is:" + cmp.get("v.name"));
        console.log("childControlStorages is:" + cmp.get("v.value"));
        compEvent.fire();
    },
    handleMyEvent : function(cmp, evt) {
        console.log("in handleMyEvent");
    },
    
    handleVisibilityUpdate : function(cmp, evt) {
        console.log("in handleVisbilityUpdate");
        console.log(evt.getParam("childControlName"));
        console.log(cmp.get("v.name"));
        console.log(cmp.get("v.nowVisible"));
        console.log(evt.getParam("childControlVisbility"));
        
        if (evt.getParam("childControlName") == cmp.get("v.name")) {
            //this control is affected by the parent change          
        	cpm.set("v.nowVisible", evt.getParam("childControlVisbility"));
   		 }
    }
})