/*
 * Copyright (c) 2018, salesforce.com, inc.
 * All rights reserved.
 * Licensed under the BSD 3-Clause license.
 * For full license text, see LICENSE.txt file in the repo root  or https://opensource.org/licenses/BSD-3-Clause
 */
 ({
    //Standard Show Toast Event
    showToast : function(type, title, message, duration, mode, key) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": type,
            "duration": duration,
            "mode": mode,
            "key": key
        });
        toastEvent.fire();
    },

    //Show Toast Event updated to include a message that contains a link
    showToastUrl : function(type, title, messageUrl, urlLink, urlLabel, duration, mode, key) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": messageUrl,
            "messageTemplate": messageUrl,
            "messageTemplateData": ['Salesforce', {
                url: urlLink,
                label: urlLabel,
            }],
            "type": type,
            "duration": duration,
            "mode": mode,
            "key": key
        });
        toastEvent.fire();
    }
})
