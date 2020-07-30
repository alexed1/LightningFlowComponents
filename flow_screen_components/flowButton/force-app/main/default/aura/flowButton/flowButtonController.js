({

    init: function(component, event, helper) {

        var buttonLabel = component.get("v.buttonLabel");
        var launchFlowOnInit = component.get("v.launchFlowOnInit");
        console.log('RC_FlowButtonController > init - buttonLabel: ' + buttonLabel + ', launchFlowOnInit: ' + launchFlowOnInit);

        if (launchFlowOnInit) {
            var showFlowInModal = component.get("v.showFlowInModal");

            if (showFlowInModal) {
                helper.openModal(component);
            } else {                
                // show flow inline
                component.set("v.showFlow", true);
                helper.showFlow(component, 'flowComponent');
            }
        } else {
            // show button
            component.set("v.showButton", true);
        }

    }, // end init
	    
    handleNavigation : function(component, event, helper) {
        
        var buttonLabel = component.get("v.buttonLabel");
        var flowToLaunch = component.get("v.flowToLaunch");
        var showFlowInModal = component.get("v.showFlowInModal");
        var buttonFlowAction = component.get("v.buttonFlowAction");
        
        // button clicked
        component.set("v.buttonClicked", true)
                
        if (flowToLaunch) {

            console.log('RC_FlowButtonController > handleNavigation - button clicked: ' + buttonLabel 
                        + ', flowToLaunch: ' + flowToLaunch
                        + ', showFlowInModal: ' + showFlowInModal);
            
            // hide button
            component.set("v.showButton", false);
            
            if (showFlowInModal) {
                helper.openModal(component);
            } else {                
                // show flow inline
                component.set("v.showFlow", true);
                helper.showFlow(component, 'flowComponent');
            }
            
        } else if (buttonFlowAction) {
            
            console.log('RC_FlowButtonController > handleNavigation - button clicked: ' + buttonLabel 
                        + ', buttonFlowAction: ' + buttonFlowAction);
            
            // navigate in the flow
            helper.navigateFlow(component);
                        
        } else {
        	console.log('RC_FlowButtonController > handleNavigation - button not configured to do anything');             
        }
            
   	}, // end handleNavigation
    
	handleStatusChange : function (component, event, helper) {
        
        var status = event.getParam("status");
        component.set("v.flowStatus", status);
        console.log('RC_FlowButtonController > handleStatusChange - status: ' + component.get("v.flowStatus"));

        if(status == "FINISHED") {
           
            // hide flow inline
            component.set("v.showFlow", false);
            
            var showFlowInModal = component.get("v.showFlowInModal");
            console.log('RC_FlowButtonController > handleStatusChange - showFlowInModal: ' + showFlowInModal); 
            if (showFlowInModal) {
                helper.closeModal(component);
            }
            
            var doAction = component.get("v.doFlowActionWhenSubflowCompletes");
            console.log('RC_FlowButtonController > handleStatusChange - doFlowActionWhenSubflowCompletes: ' + doAction); 
            
            if (doAction) {
                
                // navigate in the flow
                helper.navigateFlow(component);

            } else {
            
            	// show button
            	component.set("v.showButton", true);
            }
            
            /**
            // Get the output variables of the flow and iterate over them
            var outputVariables = event.getParam("outputVariables");
            var outputVar;
            for(var i = 0; i < outputVariables.length; i++) {
                outputVar = outputVariables[i];
                // Pass the values to the component's attributes
                if(outputVar.name === "accountName") {
                    component.set("v.accountName", outputVar.value);
                } else {
                    component.set("v.numberOfEmployees", outputVar.value);
                }
            }
            **/
        }
        
    }, // end handleNavigation
    
    closeModal: function(component, event, helper) {

        // close modal
        helper.closeModal(component);

        // show button
        component.set("v.showButton", true);

    }, // end closeModal
    
})