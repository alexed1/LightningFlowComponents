({
    doInit : function(component, event, helper) {
        console.log('Label 2: [' + component.get("v.label2") + ']');
        if(component.get("v.label2"))
            component.set("v.Buttons2", true);
        
        var action = component.get("c.getUIThemeDescription");
        action.setCallback(this, function(a) {
            component.set("v.Theme", a.getReturnValue());
            if(a.getReturnValue()=='Salesforce Classic'){
                component.set("v.isLEX",false);
            }else if(a.getReturnValue()=='Lightning Experience'){
                component.set("v.isLEX",true);
            }else if(a.getReturnValue()=='Salesforce1 Mobile'){
                component.set("v.isLEX",false);
            }
        });
        $A.enqueueAction(action);
    },
    
    handleClick : function(component, event, helper) {
        component.set("v.h_destinationURL", component.get("v.destinationURL"));
        component.set("v.h_destinationType", component.get("v.destinationType"));
        component.set("v.h_targetRecordId", component.get("v.destinationType"));
        component.set("v.h_navigationType", component.get("v.navigationType"));
        helper.handleClick(component, event, helper);
        component.set("v.fire", true);
    },
    
    handleClick2 : function(component, event, helper) {
        component.set("v.h_destinationURL", component.get("v.destinationURL2"));
        component.set("v.h_destinationType", component.get("v.destinationType2"));
        component.set("v.h_targetRecordId", component.get("v.destinationType2"));
        component.set("v.h_navigationType", component.get("v.navigationType2"));
        helper.handleClick(component, event, helper);
        component.set("v.fire2", true);        
    },
    
})
