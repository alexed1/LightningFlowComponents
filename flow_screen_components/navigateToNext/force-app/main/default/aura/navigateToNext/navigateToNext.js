// Modelled after 
// https://developer.salesforce.com/docs/component-library/bundle/force:closeQuickAction/documentation

({
    doInit: function(component, event, helper) {
        // Close the action panel
        var navigate = component.get("v.navigateFlow");
        navigate("NEXT");
    }

})