({
    //for most controls a click means we should update the value attribute
    //it's a little more complex for text fields so there are two handlers
    //also was having trouble with lighting:input onchange
    //so this is a two phase process. manipulating the controls causes onChildControlValueChange to fire,
    //which updates the value attribute.
    //any change to the value attribute causes handleValueChange to get called, which in turn fires
    //the component event that will be seen by the parent.
    //REFACTOR:messy.
	onChildControlValueChange : function(cmp, evt, helper) {
		var clickedControl = evt.getSource();
        
        var value = clickedControl.get("v.value");
        
        //this is a hack to fix a bug in the radio control
        //if you already have the radio button selected and select a different one, you end up with both values captured, separated by a comma
        //to treat this: if it's a radio button group, then if it has a comma, then strip off the old value, which isn't getting taken off in time for the event to fire
        var controlID = clickedControl.getLocalId();   
        if (controlID == 'radio') {
            var commaPosition = value.indexOf(",");
            if (commaPosition != -1) {
                //strip off the old value and the comma
                value = value.slice(commaPosition+1);
            }
        }
        
        cmp.set("v.value",value);
        var compEvent = cmp.getEvent("ChildControlClicked");      
        compEvent.fire();
	},
    
    //when this control's value changes, fire an event so the parent finds out about it
    //REFACTOR: rename the event to something about value.
    handleValueChange : function(cmp, evt, helper) {      
       // var compEvent = cmp.getEvent("ChildControlClicked");      
       // compEvent.fire();
    },
    
    //when something happens on the parent control that should toggle this control's visibility, this handler will get called
    handleVisibilityUpdate : function(cmp, evt) {
        
        var thisControlParentLabel = cmp.get("v.parentLabel");
        var eventParentLabel = evt.getParam("parentLabel");
        
        if (thisControlParentLabel == eventParentLabel) {
             if (evt.getParam("childControlName") == ("v." + cmp.get("v.name") + "_nowVisible")) {
            //this control is affected by the parent change   
            //toggle visibility
            if (cmp.get("v.nowVisible") == "true"){
                cmp.set("v.nowVisible", "false");
            } else {
                cmp.set("v.nowVisible", "true");
            }
        	 
   		 }
        }
        
       
    }
})