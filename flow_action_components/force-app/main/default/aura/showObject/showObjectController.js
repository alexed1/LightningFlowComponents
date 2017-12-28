({
 invoke : function(component, event, helper) {
       	var args = event.getParam("arguments");
       	var callback = args.callback;
       
		var address = component.get("v.objId");

		var urlEvent = $A.get("e.force:navigateToSObject");
	    urlEvent.setParams({
	     "recordId": address
	    });
	    urlEvent.fire();


	    callback("SUCCESS");
    }
})