({
  invoke : function(component, event, helper) {
	       
		var args = event.getParam("arguments");
		var callback = args.callback;


		var currentUrl = window.location;
		console.log("currentURL is: "+ currentUrl);

    	var locations = windowlocation.split('/');

    	var temprecordid = currentUrl.split('/')[length - 2];

    	console.log("temprecordid is " + temprecordid);
    	component.set("v.recordId", temprecordid);
	       
		callback("SUCCESS");
	}
})
