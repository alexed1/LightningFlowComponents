({
	doInit : function(component, event, helper) {
		//button will change from brand style to neutral style once pressed
		component.set("v.buttonStyle", 'slds-button_brand');
	
		//set field values for each possible field type        
		var fieldValue = component.get("v.fieldValue");
		component.set("v.newFieldValue_Boolean", fieldValue.toLowerCase() == 'true');     
		component.set("v.newFieldValue_String", fieldValue);
		component.set("v.newFieldValue_Date", fieldValue);
		component.set("v.newFieldValue_Datetime", fieldValue);
		component.set("v.newFieldValue_Time", fieldValue);
		component.set("v.newFieldValue_Integer", fieldValue);
		component.set("v.newFieldValue_Long", fieldValue);
		component.set("v.newFieldValue_Decimal", fieldValue);
		component.set("v.newFieldValue_Double", fieldValue);
	},
	
	handleSaveRecord : function(component, event, helper) {
	
		//Field Update
		var fieldName = component.get("v.fieldName");
		var simpleRecord = component.get("v.simpleRecord");        
		var newFieldValueName = 'v.newFieldValue_' + component.get("v.fieldType");      
		var fieldValue = component.get(newFieldValueName);
		simpleRecord [ fieldName ] = fieldValue;
		component.set("v.simpleRecord", simpleRecord);
	
		//Standard way to save a record template using Lightning Data Service
		component.find("recordEditor").saveRecord($A.getCallback(function(saveResult){
			if(saveResult.state === "SUCCESS" || saveResult.state === "DRAFT"){
				console.log("Save completed successfully.");
				// Change button Style
				component.set("v.buttonStyle", 'slds-button_neutral');          
				$A.get("e.force:closeQuickAction").fire();
				// Show Success Message
				$A.enqueueAction(component.get('c.showToast')); 
			}else if(saveResult.state === "INCOMPLETE"){
				console.log("User is offline, device doesn't support drafts.");
			}else if(saveResult.state === "ERROR"){
				console.log("Problem saving record, error: " + JSON.stringify(saveResult.error));
			}else{
				console.log("Unknown problem, state: " + saveResult.state + ", error: " + JSON.stringify(saveResult.error));
			}
		}));
	},
	
	handleCancel : function(component, event, helper){
		$A.get("e.force:closeQuickAction").fire();
	},    
	
	showToast : function(component, event, helper) {
				var toastEvent = $A.get("e.force:showToast");
				var toastMessage = component.get("v.successMessage");   
				toastEvent.setParams({
					"message": toastMessage,
					"type": "success"
				});
				if (toastMessage.length > 0) {
					toastEvent.fire();
				}                   
	},    
	
	})
	