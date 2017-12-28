({
	init : function(component, event, helper) {
        component.set("v.scriptLoaded", helper.defer());
    },
    scriptsLoaded : function(component, event, helper) {
        component.get("v.scriptLoaded").resolve(true);
    },
    invoke : function(component, event, helper) {
        
    	var args = event.getParam("arguments");
        var callback = args.callback;

        helper.showToast(component, event, helper);
        
        callback("SUCCESS");
    }
})