({
    hlpCheckValidity : function(component, event){                
        component.set('v.validate', function() {         
        var selectedValue = component.get("v.selectedValue");
        var required = component.get("v.required"); 
        if(!required || (selectedValue && !$A.util.isEmpty(selectedValue))) { 
            return { isValid: true }; 
        } 
        else {                 
            return { 
                isValid: false, 
                errorMessage: 'Please select a choice.' 
            }; 
        }
        })    
    }
})
