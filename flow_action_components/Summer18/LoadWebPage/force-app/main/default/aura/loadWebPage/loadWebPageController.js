/*
 * Copyright (c) 2018, salesforce.com, inc.
 * All rights reserved.
 * Licensed under the BSD 3-Clause license.
 * For full license text, see LICENSE.txt file in the repo root  or https://opensource.org/licenses/BSD-3-Clause
 */
 ({

	invoke : function(component, event, helper) {

		var args = event.getParam("arguments");
		var destUrl = component.get("v.url");
	    var pattern = new RegExp('^(http|https):\/\/[^ "]+$');
	    if (!pattern.test(destUrl)) {
	    		destUrl = 'http://' + destUrl;
	    }

	    var urlEvent = $A.get("e.force:navigateToURL");
	    	urlEvent.setParams({
	    		"url": destUrl
	    });
		urlEvent.fire();
	}
})
