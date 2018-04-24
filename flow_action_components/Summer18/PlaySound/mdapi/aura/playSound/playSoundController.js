/*
 * Copyright (c) 2018, salesforce.com, inc.
 * All rights reserved.
 * Licensed under the BSD 3-Clause license.
 * For full license text, see LICENSE.txt file in the repo root  or https://opensource.org/licenses/BSD-3-Clause
 */
 ({
    invoke : function(cmp, event, helper) {
        cmp.set("v._priv_usedInLocalAction", "true");
        cmp.set("v.showUI", "false");
        var args = event.getParam("arguments");
        setTimeout(function () {
            helper.playSound(cmp, event, helper);
        });
    },

    toggleSound: function (cmp, event, helper) {
        helper.toggleSound(cmp, event, helper);
    }
})
