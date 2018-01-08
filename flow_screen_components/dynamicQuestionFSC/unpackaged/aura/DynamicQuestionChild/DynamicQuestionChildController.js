({
    //because the child controls are dynamically injected, we need to here fire an event to let
    // the main component know that the value has changed, so the main storage attribute can be updated
    
    init : function(cmp, evt, helper) {
        console.log("child control initing");
       
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
        
        //console.log("name: " + cmp.get("v.name"));
        //console.log(cmp.get("v.nowVisible"));
        //console.log(evt.getParam("childControlVisibilityChanged"));
        
       
        if (evt.getParam("childControlName") == ("v." + cmp.get("v.name") + "_nowVisible")) {
            //this control is affected by the parent change   
            console.log("Changing visibility for control: " + cmp.get("v.name") ) ;      
            //toggle visibility
            if (cmp.get("v.nowVisible") == "true"){
                cmp.set("v.nowVisible", "false");
            } else {
                cmp.set("v.nowVisible", "true");
            }
        	 
   		 }
        console.log( "visibility of: " + cmp.get("v.name") + "is " + cmp.get("v.nowVisible") );
    }
})