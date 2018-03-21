({
   invoke : function(component, event, helper) {
        var args = event.getParam("arguments");
        var callback = args.callback;

 
        var url = component.get("v.url");
        var urlEvent = $A.get("e.force:navigateToURL");
    
    	urlEvent.setParams({
	      "url": url
	    });
	    urlEvent.fire();

        callback("SUCCESS");
    }
})
