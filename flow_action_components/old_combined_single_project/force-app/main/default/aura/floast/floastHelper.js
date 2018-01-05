({
	showToast : function(component, event, helper) {
        
        var curMessage = component.get("v.message");
        
        var toastEvent = $A.get("e.force:showToast");
        console.log("toastEvent:" + toastEvent);
        
        toastEvent.setParams({
            "title": "Success!",
            "message": curMessage
        });
        toastEvent.fire();
	}
})