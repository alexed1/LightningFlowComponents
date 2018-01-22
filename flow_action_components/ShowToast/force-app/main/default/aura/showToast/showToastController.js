({
    invoke : function(component, event, helper) {
        var args = event.getParam("arguments");
        var callback = args.callback;
        
        var message = component.get("v.message");
        var type = component.get("v.type");
        helper.showToast(type, message);
        
        callback("SUCCESS");
    }
})