({
    doInit: function(component, event, helper) {
        helper.fetchPickListVal(component, component.get("v.parentObjectName"), component.get("v.parentFieldName"), 'v.parentOptions');
    },

    onParentValueChange: function(component, event, helper) {
        var parentSelectValue = event.getSource().get("v.value")
        component.set("v.parentValue",parentSelectValue);


        if (parentSelectValue == "none")    {
            component.set("v.showDependentSelect", false);
        } else {
            component.set("v.showDependentSelect", true);
            //compare the value to the various choice inputs and if one is found, set the dependent lookup field value
            //else set an error
            switch (parentSelectValue) {
                case (component.get("v.choice1_parentValue")):
                    component.set("v.dependentParentFieldValue", component.get("v.choice1_dependentFieldName"));
                break;
                case (component.get("v.choice2_parentValue")):
                    component.set("v.dependentParentFieldValue", component.get("v.choice2_dependentFieldName"));
                break;
                case (component.get("v.choice3_parentValue")):
                    component.set("v.dependentParentFieldValue", component.get("v.choice3_dependentFieldName"));
                break;
                case (component.get("v.choice4_parentValue")):
                    component.set("v.dependentParentFieldValue", component.get("v.choice4_dependentFieldName"));
                break;
                case (component.get("v.choice5_parentValue")):
                    component.set("v.dependentParentFieldValue", component.get("v.choice5_dependentFieldName"));
                break;
                case (component.get("v.choice6_parentValue")):
                    component.set("v.dependentParentFieldValue", component.get("v.choice6_dependentFieldName"));
                break;
                case (component.get("v.choice7_parentValue")):
                    component.set("v.dependentParentFieldValue", component.get("v.choice7_dependentFieldName"));
                break;
                case (component.get("v.choice8_parentValue")):
                    component.set("v.dependentParentFieldValue", component.get("v.choice8_dependentFieldName"));
                break;
                case (component.get("v.choice9_parentValue")):
                    component.set("v.dependentParentFieldValue", component.get("v.choice9_dependentFieldName"));
                break;
                case (component.get("v.choice10_parentValue")):
                    component.set("v.dependentParentFieldValue", component.get("v.choice10_dependentFieldName"));
                break;
                default:
                    alert( "No dependent list found for parent value: " + parentSelectValue + ". This probably means that the Dependent Picklist component in this Flow screen is not configured correctly or that the underlying picklist values were changed. Contact your salesforce adminstrator and make sure to tip the error message guy.");
            } 
        }
        

    },

    onDependentValueChange: function(component, event, helper) {
        component.set("v.dependentValue",event.getSource().get("v.value"));
    },
    
    //when the parent select changes to a new value, fetch an updated set of dependent picklist values
	handleDependentParentFieldValueChanged: function(component, event, helper) {
        var targetFieldName = "";
        var targetObjectName = "";

        //if the provided dependentParentFieldValue includes an object, then extract that and override the parentObjectName
        //if targetFieldString has a period in it, assume the text to the left of the period is the object name    
        var targetFieldString =  component.get("v.dependentParentFieldValue");
        if (targetFieldString.includes(".")) {
            var names = targetFieldString.split(".");
            targetObjectName = names[0];
            targetFieldName=names[1];
        } else {
            targetObjectName = component.get("v.parentObjectName");
            targetFieldName = targetFieldString;
        }

        helper.fetchPickListVal(component, targetObjectName, targetFieldName, 'v.dependentOptions');
    },




})
