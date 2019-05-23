({
	init : function(component, event, helper) {
               
        	var action = component.get("c.getFlowNamesApex");
   
            var showActivesOnlyFlag = false;       
            if (component.get("v.showActiveFlowsOnly")) {
                showActivesOnlyFlag = true;
            }
        
			action.setParams({
                showActivesOnly : showActivesOnlyFlag });
        
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {    
                    console.log('response is: ' + response.getReturnValue());
                  	helper.processResponse(response.getReturnValue(), component, helper);
                }
                else {
                    console.log("Failed with state: " + state);
                }
        	});
        
        
            $A.enqueueAction(action);
    },
    
    
    handleChange : function(component, event, helper) {
        component.set('v.selectedFlowApiName', event.getParam("value"));
    }
 
})