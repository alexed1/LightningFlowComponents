// Eric Smith - 11/30/18 - Added APEX Class to correctly check for Classic vs Lightning
// 
({
    handleClick : function(component, event, helper) {
        console.log('entering handleclick');        
        var destType = component.get("v.h_destinationType");
        var isLightning = component.get("v.isLEX");
        var isClassic = false
        if (component.get("v.Theme") == 'Salesforce Classic')
            isClassic = true;
        console.log('Classic: ' + isClassic);
        console.log('Lightning: '+ isLightning);
        console.log('Theme: ' + component.get("v.Theme"));
        if (destType == 'url') {
            console.log('destType is url');
            var urlEvent = $A.get("e.force:navigateToURL");
            console.log('destination is url');
            var destUrl = component.get("v.h_destinationURL");
            console.log('url is '+destUrl)	
            if( isLightning ) {
                //handle lightning experience on desktop
                console.log("running navigation for lightning desktop");
                urlEvent.setParams({
                    "url": destUrl
                });      
                console.log("Firing urlEvent: "+urlEvent)
                urlEvent.fire();
            }
            else {                 
                if ( isClassic ) {
                    console.log("running navigation for classic desktop");
                    window.location = destUrl;
                }
            }
        }
        else {
            if (destType == 'record') {
                var urlEvent = $A.get("e.force:navigateToSObject");
                console.log('destination is record');
                var destObject = component.get("v.h_targetRecordId");
                console.log('recordId is:' +destObject)
                urlEvent.setParams({
                    "recordId": destObject,
                    "slideDevName": "related",
                    "isredirect": true
                });
                console.log("running urlEvent for Record ID")
                if( isLightning ) {
                    //handle lightning experience on desktop
                    console.log("running navigation for lightning desktop");
                    urlEvent.fire();
                }
                else {
                    console.log("running navigation for classic")
                    window.location = '/'+destObject; 
                }
            }
            
            else {
                if (destType == 'standard') {
                    console.log('entering standard');
                    var navigationGoal = component.get("v.h_navigationType");
                    
                    var navigate = component.get('v.navigateFlow');
                    
                    if (navigationGoal.toLowerCase() == 'finish') {
                        navigate("FINISH");  
                    }
                    
                    if (navigationGoal.toLowerCase() == 'next') {
                        navigate("NEXT");  
                    }  
                    if (navigationGoal.toLowerCase() == 'back') {
                        navigate("BACK");  
                    }  
                }
            }
        }
    } 
})
