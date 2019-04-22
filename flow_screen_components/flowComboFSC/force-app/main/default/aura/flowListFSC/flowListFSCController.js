({
    init : function(component, event, helper) {
        
        //apex controller uses REST to retrieve flow metadata
        var action = component.get("c.getFlowData");

        //lots of room for expansion here if additional use cases are added
        var baseString = '/services/data/v46.0/query/?q=SELECT+Id,ApiName,Label+from+FlowDefinitionView';
        var pathString = baseString;
        if (component.get("v.showActiveFlowsOnly")) {
            pathString=pathString+ '+WHERE+ActiveVersionId+!=+NULL';
        }
    
        action.setParams({
            orgURL : pathString,
            endpoint : component.get("v.endpoint")
        });
    
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {    
                console.log('responseJSON is: ' + response.getReturnValue());
                helper.processResponse(response.getReturnValue(), component, helper);
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
    
        $A.enqueueAction(action);
    },


    onChange : function(component, event, helper) {
        component.set('v.selectedFlowApiName', event.getParam("value"));

    }
})
