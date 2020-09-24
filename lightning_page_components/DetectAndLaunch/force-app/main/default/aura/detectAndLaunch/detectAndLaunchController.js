({

    openModal : function(component, event, helper) {
		component.set('v.openModal',true);
	},
 
	closeModal : function(component, event, helper) {
		component.set('v.openModal',false);
	},
 


    flowStatusChange : function( component, event, helper ) {
        if ( event.getParam( "status" ).indexOf( "FINISHED" ) !== -1 ) {
            component.set( "v.openModal", false );
            
        }
    },
    
    recordUpdated: function(component, event, helper) {
        console.log('entering recordUpdate');
        var eventParams = event.getParams();

        if(eventParams.changeType === "CHANGED") {
            component.set("v.targetFlowName", component.get("v.editFlowName"));
        } else if(eventParams.changeType === "REMOVED") {
            component.set("v.targetFlowName", component.get("v.deleteFlowName"));
        }
        if(eventParams.changeType === "CHANGED" || eventParams.changeType === "REMOVED") {
            helper.processChangeEvent(component, eventParams);
        }   
        else if(eventParams.changeType === "ERROR") {
            console.log(eventParams);
            console.log('Update event received Error: ' + component.get("v.error"));
        }
    }


    

            
})
