({
    handleClick : function(component, event, helper) {
        var destUrl = component.get("v.destinationURL");
        var urlEvent = $A.get("e.force:navigateToURL");
        var navigationGoal = component.get("v.navigationType");
        
        var destType = component.get("v.destinationType");
        if (destType == 'url') {           
        	 urlEvent.setParams({
            	 "url": destUrl
        	 });      	
        }
        if (destType == 'record') {
            console.log('in record');
            var destObject = component.get("v.targetRecordId");
            console.log('recordId is:' +destObject)
            urlEvent = $A.get("e.force:navigateToSObject");
            urlEvent.setParams({
              "recordId": destObject,
              "slideDevName": "related"
            });
        }
        urlEvent.fire();
        var navigate = component.get('v.navigateFlow');
        
        if (navigationGoal == 'finish') {
          navigate("FINISH");  
        }
        
		if (navigationGoal == 'next') {
          navigate("NEXT");  
        }  
        if (navigationGoal == 'back') {
            navigate("BACK");  
        }  
    }
})