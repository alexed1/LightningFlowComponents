({
    playSound: function(cmp, event, helper, callback) {
        var audioPlayer = cmp.find("audioPlayer");
        if (!$A.util.isUndefinedOrNull(audioPlayer)) {
            var audioElement = audioPlayer.getElement();
            audioElement.muted = false;
            audioElement.loop = false;
            audioElement.addEventListener("ended", function() {
                callback("SUCCESS");
            });
            audioElement.play();   
        }    
        
    },
    
    toggleSound: function (cmp, event, helper) {
        cmp.set("v.muted", !cmp.get("v.muted"));
    }
})