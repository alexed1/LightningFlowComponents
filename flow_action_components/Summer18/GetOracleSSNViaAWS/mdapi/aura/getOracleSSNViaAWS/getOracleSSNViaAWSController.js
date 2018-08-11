/*
 * Copyright (c) 2018, salesforce.com, inc.
 * All rights reserved.
 * Licensed under the BSD 3-Clause license.
 * For full license text, see LICENSE.txt file in the repo root  or https://opensource.org/licenses/BSD-3-Clause
 */
({
	invoke : function(component, event, helper) {
    		var userId = component.get("v.userId"),
      			cancelToken = event.getParam("arguments").cancelToken;
    		return helper.fetchSSN(userId, cancelToken).then($A.getCallback(function(result) {
        		component.set("v.ssn", result);
      		}));
	}
})
