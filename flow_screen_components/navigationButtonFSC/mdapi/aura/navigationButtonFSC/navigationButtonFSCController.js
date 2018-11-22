({
    handleClick : function(component, event, helper) {
        var destUrl = component.get("v.destinationURL");
        var navigationGoal = component.get("v.navigationType");
        
        component.set("v.fire", true);

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
    },
    
	navigateout: function (component, event) {
              	var destType = component.get("v.destinationType");
              	if (destType == 'url') { 
                    var urlEvent = $A.get("e.force:navigateToURL");
             		console.log('destination is url');
    				var destUrl = component.get("v.destinationURL");
             		console.log('url is '+destUrl)	
          			if( (typeof sforce != 'undefined') && (sforce.one != null) ) {
						//handle lightning experience on desktop
						console.log("running navigation for lightning desktop");
                		urlEvent.setParams({
            				"url": destUrl
        	 			});      
                        console.log("Firing urlEvent: "+urlEvent)
                    //appears to be broken
            		urlEvent.fire();
        			}
    				else {
            			var device = $A.get("$Browser.formFactor");
            			if (device=="DESKTOP") {
             		   		console.log("running navigation for classic desktop");
            		    	window.location = destUrl;
           				}
					}
                }
            	else {
                   	if (destType == 'record') {
                        var urlEvent = $A.get("e.force:navigateToSObject");
                       	console.log('destination is record');
           				var destObject = component.get("v.targetRecordId");
           				console.log('recordId is:' +destObject)
           				urlEvent.setParams({
             				"recordId": destObject,
              				"slideDevName": "related",
            				"isredirect": true
                	    });
            			console.log("running urlEvent for Record ID")
          				if( (typeof sforce != 'undefined') && (sforce.one != null) ) {
							//handle lightning experience on desktop
							console.log("running navigation for lightning desktop");
                            //appears to be broken
                            urlEvent.fire();
                        	}
                        else {
                            console.log("running navigation for classic")
                            window.location = '/'+destObject; 
                        }
                    }
            	}
    }  
})
