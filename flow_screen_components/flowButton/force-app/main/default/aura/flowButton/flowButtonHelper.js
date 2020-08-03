({
	showFlow: function(component, flowComponentID) {
               
        // find the view component (by aura:id) where the flow will be displayed
        var flow = component.find(flowComponentID);
        
        if (flow) {

            var flowToLaunch = component.get("v.flowToLaunch");
        	var recordId = component.get("v.recordId");
            
            // flow inputs
            var inputVariables = [];
            if (recordId) inputVariables[0] = { name : "recordId", type : "String", value: recordId };
            console.log('RC_FlowButtonHelper > showFlow - flowToLaunch: ' + flowToLaunch + ', inputVariables: ' + JSON.stringify(inputVariables));
        
            // start the flow by the flow Unique Name
            flow.startFlow(flowToLaunch, inputVariables);            
        }
        
    }, // end showFlow
    
    openModal: function(component) {

        // open modal
        component.set("v.modalIsOpen", true);
        
        // show flow in modal
        this.showFlow(component, 'modalFlowComponent');
        
    }, // end openModal
    
    closeModal: function(component) {
        console.log('RC_FlowButtonHelper > closeModal'); 

        component.set("v.modalIsOpen", false); 

    }, // end closeModal  

    navigateFlow: function(component) {
        var buttonFlowAction = component.get("v.buttonFlowAction");   

        // navigate in the flow
        // for example, this does the same thing as the "Next" or "Previous" buttons in the standard flow footer 
        var navigate = component.get("v.navigateFlow");
        if (navigate) {
            navigate(buttonFlowAction);
        }  
    }

})