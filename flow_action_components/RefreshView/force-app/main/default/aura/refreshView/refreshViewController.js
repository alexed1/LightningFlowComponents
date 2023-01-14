// Modelled after 
// https://developer.salesforce.com/docs/component-library/bundle/force:refreshView/documentation

({
    invoke : function(component, event, helper) {        
        return new Promise(function(resolve, reject) {
            $A.get("e.force:refreshView").fire();
            resolve();
        });
    }
})