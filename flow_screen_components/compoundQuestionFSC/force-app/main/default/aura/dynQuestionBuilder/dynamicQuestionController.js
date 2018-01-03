({
    
    init: function(cmp,evt, helper){
        helper.initRadioOptions(cmp,evt);
        helper.initChildControls(cmp,evt);
    },
    
    test:function(cmp,evt, helper){
        console.log ("received update that i just fired");
    },
    
    setEventRoot: function(component, event, helper) {
   	 event.stopPropagation();
  	},

        
    //when a parent control is clicked, we check how each child control has been set in the flow to respond
    //depending on that passed in status value, we update the visibility of the child control
    onParentClick: function(cmp, evt) {
     	console.log('in onParentClick');
       
        var parentValue = cmp.get('v.parentQuestion_value');
        
        var childControlsList = cmp.get('v.availableChildCheckboxControls')
        	.concat(cmp.get('v.availableChildRadioControls'))
        	.concat(cmp.get('v.availableChildTextFieldControls'));
        
        childControlsList.forEach(function(element) {
    		var statusAttributeName = element + '_conditionalRelationship';
            var conditionalRelationship = cmp.get(statusAttributeName);
            
            //if the parent value matches the conditional relationship passed in from the flow, show this child control
            var childComponentVisibilityAttributeName = element + '_nowVisible';
            var newVisibility = "";
            
            if ((parentValue == "true" && conditionalRelationship == "Show if True") ||
                (parentValue == "false" && conditionalRelationship == "Show if False")) {             	
                	newVisibility = "true";
            } else {
                    newVisibility = "false";
            };
            
            
            cmp.set(childComponentVisibilityAttributeName, newVisibility);
            
            
            //the stuff below isn't working because the child controls aren't receiving the event fired here
            //if the parent value matches the conditionrelationship passed in from the flow, fire an event 
            // aimed at that particular child control, including the value of visibility
             var updateEvent = cmp.getEvent("childControlVisibilityUpdateEvent");
            //var updateEvent = $A.get("e.c:ChildControlVisibilityUpdateEvent")
            updateEvent.setParams({"childControlName" : childComponentVisibilityAttributeName});
            updateEvent.setParams({"childControlVisbility" : newVisibility});
            updateEvent.fire();

			var updateEvent = cmp.getEvent("myEvent");
            updateEvent.fire();
        });
        
 	},
    
    handleChildControlClickedEvent: function(cmp,evt, helper) {
       //var childControlName =  evt.getParam("childControlName");
      
       
       var clickedControl = evt.getSource();
       console.log("back in handle, childControlName is:" + clickedControl.get("v.name"));
       console.log("back in handle, childControlStorages is:" + clickedControl.get("v.storage"));
       helper.updateStorage(cmp, clickedControl);
       
    },
    
    onChildControlClick: function(cmp, evt, helper) {
         //get the  control that fired this event
         var clickedControl = evt.getSource();
         
         helper.updateStorage(cmp, clickedControl);
           
     },
    
    saveStuff: function(cmp, evt, helper, value) {
        console.log("insavestuff");
        console.log("the cmp we're dealing with here is:" + cmp.get("v.name"));
        
    },
    
    	
         
     
})