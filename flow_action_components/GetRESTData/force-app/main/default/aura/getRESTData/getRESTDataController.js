({
	invoke : function(component, event, helper) {
	       var args = event.getParam("arguments");
	       var callback = args.callback;

	       var xhttp = new XMLHttpRequest();
	       xhttp.onreadystatechange = $A.getCallback(function() {
	    	   if (this.readyState === 4) { // DONE
	    	        if (this.status >= 200 && this.status < 300) {
	    	        	var response = JSON.parse(xhttp.responseText);
	    	 	       	component.set("v.churnVal", response);
	    	 	       	callback("SUCCESS");
	    	        } else {
	    	        	var errorText = "";
	    	        	if (this.status === 0) {
	    	        		errorText = 'Request has been terminated\nPossible causes: the network is offline, Origin is not allowed by Access-Control-Allow-Origin, the page is being unloaded, etc.';
	    	        	} else {
							errorText = this.statusText;
	    	        	}
	    	 	       	callback("ERROR", errorText);
	    	        }
	    	    }
	       });
	       var customerId = component.get("v.customerId");
	       xhttp.open("GET", "https://upp57qbj5b.execute-api.us-west-1.amazonaws.com/production/customer/"+customerId+"/churn", true);
	       xhttp.send(null);
	}
})
