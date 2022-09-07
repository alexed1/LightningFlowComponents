({
    doInit: function(component, event, helper) {
        component.set("v.fieldNameList", component.get("v.fieldChange").split(","));
        component.set("v.fieldCompare", component.get("v.fieldNameList")[1]);
        console.log('fieldSet', component.get("v.fieldNameList"));
        console.log('fieldCompare', component.get("v.fieldCompare"));
    },

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

        // If both Field Change and Field Value are not null then set to isChangedRecord to true
        // This will then populate the users field value within the fields list
        if(component.get("v.fieldChange") != null && component.get("v.fieldValue") != null ){
            component.set("v.isChangedRecord", true);
            //console.log('fieldChange',component.get("v.fieldChange"));
            //console.log('fieldValue',component.get("v.fieldValue"));
            // Make sure there was an edited field and we just edited a record
            if ( eventParams.changedFields && eventParams.changeType === "CHANGED") {
                console.log('eventParams.changedFields', eventParams.changedFields);
                var changed = JSON.parse(JSON.stringify(eventParams.changedFields));
                //console.log('changed', changed);
                //console.log('changed.dynamic', changed[component.get("v.fieldCompare")]);
                if (changed[component.get("v.fieldCompare")]) {
                    //console.log('changed.dynamic.value', changed[component.get("v.fieldCompare")].value);
                    if ( changed[component.get("v.fieldCompare")].value === component.get("v.fieldValue") ) {
                        //console.log('hit');
                        component.set("v.targetFlowName", component.get("v.editFlowName"));
                        helper.processChangeEvent(component, eventParams);
                    }
                }
            }
        } else {
            // Get Flow To Use
            if(eventParams.changeType === "CHANGED") {
                component.set("v.targetFlowName", component.get("v.editFlowName"));
            } else if(eventParams.changeType === "REMOVED") {
                component.set("v.targetFlowName", component.get("v.deleteFlowName"));
            } else if(eventParams.changeType === "LOADED") {
                component.set("v.targetFlowName", component.get("v.loadFlowName"));
            }


            // Launch Flow
            if(eventParams.changeType === "CHANGED" || eventParams.changeType === "REMOVED") {
                helper.processChangeEvent(component, eventParams);
            } else if( eventParams.changeType === "LOAD" && changedFields !== null)  {
                //console.log('changedFields ', changedFields);
                helper.processChangeEvent(component, eventParams);
            } else if(eventParams.changeType === "ERROR") {
                console.log(eventParams);
                console.log('Update event received Error: ' + component.get("v.error"));
            }
        }
    }
            
})
