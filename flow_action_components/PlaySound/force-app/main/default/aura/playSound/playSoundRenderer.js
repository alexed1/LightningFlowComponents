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