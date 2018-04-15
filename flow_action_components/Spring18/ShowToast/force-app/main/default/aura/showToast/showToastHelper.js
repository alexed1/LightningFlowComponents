/*
 * Copyright (c) 2018, salesforce.com, inc.
 * All rights reserved.
 * Licensed under the BSD 3-Clause license.
 * For full license text, see LICENSE.txt file in the repo root  or https://opensource.org/licenses/BSD-3-Clause
 */
 ({
    showToast : function(type, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "message": message,
            "type": type,
            "duration": 10000,
            "mode": "dismissible",
        });
        toastEvent.fire();
    }
})
