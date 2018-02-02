({
    doInit: function(component, event, helper) {
        helper.fetchPickListVal(component, component.get("v.targetObject"), component.get("v.parentLookupField"), 'parentSelect');
    },

    onParentPicklistChange: function(component, event, helper) {
        var parentSelectValue = event.getSource().get("v.value")
        alert(parentSelectValue);
        //compare the value to the various choice inputs and if one is found, set the dependent lookup field value
        //else set an error
        switch (parentSelectValue) {
        	case (component.get("v.choice1_parentName")):
        		component.set("v.dependentLookupFieldName", component.get("v.choice1_dependentFieldName"));
        	break;
			case (component.get("v.choice2_parentName")):
        		component.set("v.dependentLookupFieldName", component.get("v.choice2_dependentFieldName"));
        	break;
        	case (component.get("v.choice3_parentName")):
        		component.set("v.dependentLookupFieldName", component.get("v.choice3_dependentFieldName"));
        	break;
        	case (component.get("v.choice4_parentName")):
        		component.set("v.dependentLookupFieldName", component.get("v.choice4_dependentFieldName"));
        	break;
        	case (component.get("v.choice5_parentName")):
        		component.set("v.dependentLookupFieldName", component.get("v.choice5_dependentFieldName"));
        	break;
        	default:
        		component.set("v.dependentLookupFieldName", "No dependent list found for parent value: " +parentSelectValue);

        } 

    },

    onChildPicklistChange: function(component, event, helper) {
        alert(event.getSource().get("v.value"));
    },
    
	dependentLookupFieldValueChanged: function(component, event, helper) {

       helper.fetchPickListVal(component, component.get("v.targetObject"), component.get("v.dependentLookupFieldName"), 'dependentSelect');
    },


})
