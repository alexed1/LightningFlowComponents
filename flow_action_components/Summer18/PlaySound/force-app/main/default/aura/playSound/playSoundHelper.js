/*
 * Copyright (c) 2018, salesforce.com, inc.
 * All rights reserved.
 * Licensed under the BSD 3-Clause license.
 * For full license text, see LICENSE.txt file in the repo root  or https://opensource.org/licenses/BSD-3-Clause
 */
 ({
    playSound: function(cmp, event, helper, callback) {
        var audioPlayer = cmp.find("audioPlayer");
        if (!$A.util.isUndefinedOrNull(audioPlayer)) {
            var audioElement = audioPlayer.getElement();
            audioElement.muted = false;
            audioElement.loop = false;
            audioElement.addEventListener("ended", function() {
                
            });
            audioElement.play();
        }

    },

    toggleSound: function (cmp, event, helper) {
        cmp.set("v.muted", !cmp.get("v.muted"));
    }
})
