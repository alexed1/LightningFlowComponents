({
    handleClick : function(component, event, helper) {
        var destUrl = component.get("v.destinationURl");
        
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
          "url": destUrl
        });
        urlEvent.fire();
    }
})
