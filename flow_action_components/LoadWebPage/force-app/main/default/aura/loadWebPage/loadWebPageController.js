({
	invoke : function(component, event, helper) {
	       var args = event.getParam("arguments");
	       var callback = args.callback;
	       var destUrl = component.get("v.url");

	       var urlEvent = $A.get("e.force:navigateToURL");
	       urlEvent.setParams({
	    	         "url": destUrl
	    	   });
		   urlEvent.fire();
	       
		   callback("SUCCESS");
	}
})
