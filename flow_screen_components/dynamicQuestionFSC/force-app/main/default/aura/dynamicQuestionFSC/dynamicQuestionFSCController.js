({
    
    init: function(cmp,evt, helper){
        
        //in the flow, the user is expected to enter the child questions as space delimited strings
        //here we convert them to more useful Lists
        //REFACTOR: should probably do all the lookup and name transformation one time here at init
        var childCompsLinkedToYes = cmp.get("v.childComponentsLinkedToYes");
        if ((childCompsLinkedToYes) && (childCompsLinkedToYes != "none")) {
           cmp.set("v.childComponentsArrayLinkedToYes", childCompsLinkedToYes.split(" ")); 
        };
        
        var childCompsLinkedToNo = cmp.get("v.childComponentsLinkedToNo");
        if ((childCompsLinkedToNo) && (childCompsLinkedToNo != "none")) {
            cmp.set("v.childComponentsArrayLinkedToNo", childCompsLinkedToNo.split(" "));
        };
                    	
        helper.initRadioOptions(cmp,evt);
        helper.initListboxOptions(cmp,evt);
        
        var defaultValue= cmp.get("v.parentQuestion_defaultValue");
        cmp.set("v.parentQuestion_value", defaultValue);

        helper.initChildControls(cmp,evt);
        
        /*//first init the child controls....
        var promise = new Promise($A.getCallback(function(resolve, reject) {
          // do a thing, possibly async, then…
          helper.initChildControls(cmp,evt);

          if (true) {
            resolve("Stuff worked!");
          }
          else {
            reject(Error("It broke"));
          }
        }));

        promise.then($A.getCallback(function(){
            return helper.updateChildControls(cmp, helper);
        }))*/


    },
    
    stopPropagation: function(component, event, helper) {
    	event.stopPropagation();
        console.log("stopping propagation");
	},
    
    //when a parent control is clicked, we check how each child control has been set in the flow to respond
    //depending on that passed in status value, we fire an event to tell the appropriate child controls to update their nowVisible settings
    onParentClick: function(cmp, evt, helper) {
        console.log ("entering parent click for component label: " + cmp.get('v.parentQuestionLabel'));
        helper.updateChildControls(cmp, helper);
 	},
    
    //when a child control value changes, we need to update the storage attribute here in the parent for use by the flow downstream
    handleChildControlClickedEvent: function(cmp,evt, helper) {        
       var clickedControl = evt.getSource();
       helper.updateStorage(cmp, clickedControl);   
    }
    
    
    	
         
     
})