({
    invoke : function(component, event, helper) {
       	var args = event.getParam("arguments");
       	var callback = args.callback;
       
		var address = component.get("v.destination");

		var urlEvent = $A.get("e.force:navigateToURL");
	    urlEvent.setParams({
	      "url": 'https://www.google.com/maps/place/' + address
	    });
	    urlEvent.fire();


	    callback("SUCCESS");
    }
})