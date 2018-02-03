({
    doInit: function(component, event, helper) {
        helper.fetchPickListVal(component, component.get("v.parentObjectName"), component.get("v.parentFieldName"), 'v.parentOptions');
    },

    onParentValueChange: function(component, event, helper) {
        var parentSelectValue = event.getSource().get("v.value")
        component.set("v.parentValue",parentSelectValue);
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
        	default:
        		alert( "No dependent list found for parent value: " + parentSelectValue);

        } 

    },

    onDependentValueChange: function(component, event, helper) {
        component.set("v.dependentValue",event.getSource().get("v.value"));
    },
    
    //when the parent select changes to a new value, fetch an updated set of dependent picklist values
	handleDependentParentFieldValueChanged: function(component, event, helper) {
        helper.fetchPickListVal(component, component.get("v.parentObjectName"), component.get("v.dependentParentFieldValue"), 'v.dependentOptions');
    },




})
