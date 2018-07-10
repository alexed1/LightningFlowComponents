/*
 * Copyright (c) 2018, salesforce.com, inc.
 * All rights reserved.
 * Licensed under the BSD 3-Clause license.
 * For full license text, see LICENSE.txt file in the repo root  or https://opensource.org/licenses/BSD-3-Clause
 */
 ({
    afterRender: function (cmp, helper) {
        this.superAfterRender();
        if (!cmp.get("v._priv_usedInLocalAction")) {
            var audioPlayer = cmp.find("audioPlayer");
            if (!$A.util.isUndefinedOrNull(audioPlayer)) {
                audioPlayer.getElement().play();
            }
        }
    }
})
