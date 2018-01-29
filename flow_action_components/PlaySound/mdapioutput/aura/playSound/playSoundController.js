({
    invoke : function(cmp, event, helper) {
        cmp.set("v._priv_usedInLocalAction", "true");
        cmp.set("v.showUI", "false");
        var args = event.getParam("arguments");
        var callback = args.callback;
        setTimeout(function () {
            helper.playSound(cmp, event, helper, callback);
        });
    },
    
    toggleSound: function (cmp, event, helper) {
        helper.toggleSound(cmp, event, helper);
    }
})