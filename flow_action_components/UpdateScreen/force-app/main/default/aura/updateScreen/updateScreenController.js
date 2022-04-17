/*
 * Copyright (c) 2018, salesforce.com, inc.
 * All rights reserved.
 * Licensed under the BSD 3-Clause license.
 * For full license text, see LICENSE.txt file in the repo root  or https://opensource.org/licenses/BSD-3-Clause
 */
({
    invoke : function(component, event, helper) {        
        return new Promise(function(resolve, reject) {
            component.find("recordLoader").reloadRecord(true, $A.getCallback(function() {
                // ignore errors, we don't want to stop the flow if we cannot refresh the record
                resolve();
            }));
        });
    }
})