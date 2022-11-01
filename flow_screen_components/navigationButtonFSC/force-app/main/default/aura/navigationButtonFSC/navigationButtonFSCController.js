({
doInit : function(component, event, helper) {
    if(component.get("v.rightJustify"))
        component.set("v.justification", "slds-float_right");
    console.log('Label 1: [' + component.get("v.label") + ']');
    console.log('Label 2: [' + component.get("v.label2") + ']');
    if(component.get("v.label2"))
        component.set("v.Buttons2", true);
    console.log('Label 3: [' + component.get("v.label3") + ']');
    if(component.get("v.label3"))
        component.set("v.Buttons3", true);
    console.log('Label 4: [' + component.get("v.label4") + ']');
    if(component.get("v.label4"))
        component.set("v.Buttons4", true);
    console.log('Label 5: [' + component.get("v.label5") + ']');
    if(component.get("v.label5"))
        component.set("v.Buttons5", true);

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
    component.set("v.h_targetRecordId", component.get("v.targetRecordId"));
    component.set("v.h_navigationType", component.get("v.navigationType"));
    component.set("v.fire", true);
    helper.handleClick(component, event, helper);
},

handleClick2 : function(component, event, helper) {
    component.set("v.h_destinationURL", component.get("v.destinationURL2"));
    component.set("v.h_destinationType", component.get("v.destinationType2"));
    component.set("v.h_targetRecordId", component.get("v.targetRecordId2"));
    component.set("v.h_navigationType", component.get("v.navigationType2"));
    component.set("v.fire2", true);
    helper.handleClick(component, event, helper);       
},

handleClick3 : function(component, event, helper) {
    component.set("v.h_destinationURL", component.get("v.destinationURL3"));
    component.set("v.h_destinationType", component.get("v.destinationType3"));
    component.set("v.h_targetRecordId", component.get("v.targetRecordId3"));
    component.set("v.h_navigationType", component.get("v.navigationType3"));
    component.set("v.fire3", true); 
    helper.handleClick(component, event, helper);       
},

handleClick4 : function(component, event, helper) {
    component.set("v.h_destinationURL", component.get("v.destinationURL4"));
    component.set("v.h_destinationType", component.get("v.destinationType4"));
    component.set("v.h_targetRecordId", component.get("v.targetRecordId4"));
    component.set("v.h_navigationType", component.get("v.navigationType4"));
    component.set("v.fire4", true);        
    helper.handleClick(component, event, helper);
},

handleClick5 : function(component, event, helper) {
    component.set("v.h_destinationURL", component.get("v.destinationURL5"));
    component.set("v.h_destinationType", component.get("v.destinationType5"));
    component.set("v.h_targetRecordId", component.get("v.targetRecordId5"));
    component.set("v.h_navigationType", component.get("v.navigationType5"));
    component.set("v.fire5", true);
    helper.handleClick(component, event, helper);        
},

})
