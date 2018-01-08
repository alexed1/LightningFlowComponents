({
    
    init: function(cmp,evt, helper){
        helper.initRadioOptions(cmp,evt);
        helper.initListboxOptions(cmp,evt);
        helper.initChildControls(cmp,evt);
    },
    
    //when a parent control is clicked, we check how each child control has been set in the flow to respond
    //depending on that passed in status value, we update the visibility of the child control
    onParentClick: function(cmp, evt) {
     	console.log('in onParentClick');
       
        var parentValue = cmp.get('v.parentQuestion_value');
        
        var childControlsList = cmp.get('v.availableChildCheckboxControls')
        	.concat(cmp.get('v.availableChildRadioControls'))
        	.concat(cmp.get('v.availableChildTextFieldControls'))
        	.concat(cmp.get('v.availableChildListboxControls'));
        
        childControlsList.forEach(function(element) {
    		var statusAttributeName = element + '_conditionalRelationship';
            var conditionalRelationship = cmp.get(statusAttributeName).toLowerCase();
            
            //if the parent value matches the conditional relationship passed in from the flow, show this child control
            var childComponentVisibilityAttributeName = element + '_nowVisible';
            var newVisibility = "";
            
            //make the input a little more robust
            var allowableYesResponses = ['yes', 'parent answer is yes', 'answer is yes'];
            var allowableNoResponses = ['no', 'parent answer is no', 'answer is no'];
             
            if ((parentValue == "true" && allowableYesResponses.includes(conditionalRelationship)) ||
                (parentValue == "false" && allowableNoResponses.includes(conditionalRelationship)) ) {             	
                	newVisibility = "true";
                	
            } else {
                    newVisibility = "false";
            };
           
            
            //if the visibility has changed (new vis != old vis) fire an event
            if (cmp.get(childComponentVisibilityAttributeName).toString() != newVisibility){
                var updateEvent = $A.get("e.c:ChildControlVisibilityUpdateEvent");
            	updateEvent.setParams({"childControlName" : childComponentVisibilityAttributeName});
         		updateEvent.setParams({"childControlVisibilityChanged" : true});
                updateEvent.fire();
            };
            
            //update the local visibility status of the child component
            cmp.set(childComponentVisibilityAttributeName, newVisibility);
            
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
           
     }
    
    
    
    	
         
     
})