/*
 * Copyright (c) 2018, salesforce.com, inc.
 * All rights reserved.
 * Licensed under the BSD 3-Clause license.
 * For full license text, see LICENSE.txt file in the repo root  or https://opensource.org/licenses/BSD-3-Clause
 */
 ({
	invoke : function(component, event, helper) {
	       var args = event.getParam("arguments");
	       var callback = args.callback;
	       var xhttp = new XMLHttpRequest();
	       xhttp.onreadystatechange = $A.getCallback(function() {
	    	   if (this.readyState === 4) { // DONE
	    	        if (this.status >= 200 && this.status < 300) {
	    	        	var response = JSON.parse(xhttp.responseText);
	    	 	       	component.set("v.ssn", response);
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
	       var userId = component.get("v.userId");
	       xhttp.open("GET", "https://e45sfxhtub.execute-api.eu-west-1.amazonaws.com/demo/ssn?userid="+userId, true);
	       xhttp.send(null);
	}
})
