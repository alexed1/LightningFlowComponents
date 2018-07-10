({
	validateFlowNavigationInputs : function(cmp) {
		//get all the inputs.
        //check and see if there's either zero (no navigation upon click) or one input
        
        console.log("starting validation of input...");
        var inputs = [];
        inputs[1]=cmp.get("v.destinationRecordId");
        inputs[2]=cmp.get("v.destinationObjectName");
        inputs[3]=cmp.get("v.destinationPageName");
        //inputs[4]=cmp.get("v.destinationTabName");
        inputs[5]=cmp.get("v.destinationWebUrl");
        inputs[6]=cmp.get("v.destinationFlowTransition");

        const checker = (accumulator, currentValue) => {
            var impact = 0;
            console.log("currentValue is: " + currentValue);
            if (currentValue != "" & !(currentValue === undefined)) {
            	console.log("accumulator is:" + accumulator);	
            	impact++;
            	console.log("impact is:" + impact);
        	}	
            return accumulator + impact;
        	
        }
        
        var totalInputs = inputs.reduce(checker, 0);
        if (totalInputs > 1) {
            alert("The destination code in this component requires you to specify no  more than one destination in your inputs. You didn't do that, and now bad things will happen. ");
        }
        if (totalInputs == 0) {
            console.log("no destination inputs provided. this image will be static");
            cmp.set("v.staticImageFlag", true);
        }
	},
            	
    navigateFlow : function(cmp, helper) {
        var self=helper;
        var navService = cmp.find("navService");
        //var destType =cmp.get("v.destinationType"); 
        var destName = "";
        var args = {};
        var state = {};

        var destRecordId = cmp.get("v.destinationRecordId");
        if (destRecordId != "" && destRecordId) {
            console.log("dstRecordId is not blank");
            args["recordId"] = destRecordId;
            var action = cmp.get("v.actionName");
            //use view if nothing is specfied. that's mostly what people want.
            args["actionName"] = (action != 'view' && action) ? action : "view";
            destName = "standard__recordPage";
        }    
           
        var objectApiName = cmp.get("v.destinationObjectName");
        if ((objectApiName != "") && objectApiName) {  
            //console.log("objectApiName is not blank:" + objectApiName);
            args["objectApiName"] = objectApiName;
            var action = cmp.get("v.actionName");
            //use list if nothing is specfied.
            args["actionName"] = (action != 'list' && action) ? action : "list";
            destName = "standard__objectPage";    
            
            //allows a view name to be provided.
            var viewName = cmp.get("v.destinationObjectView");
            state["filterName"] = (viewName != 'recent' && viewName) ? viewName : "recent";
		}
        
        var pageName = cmp.get("v.destinationPageName");
        if ((pageName != "") && pageName) {  
            //console.log("objectApiName is not blank:" + objectApiName);
            args["pageName"] = pageName;
            destName = "standard__namedPage";    
		}
        
       
        //var tabName = cmp.get("v.destinationTabName");
        //if ((tabName != "") && tabName) {  
        //    args["apiName"] = tabName;
        //    destName = "standard__navItemPage";    
        //}
        var flowTransition = cmp.get("v.destinationFlowTransition");
        if ((flowTransition != "") && flowTransition) {
            var navigate = cmp.get("v.navigateFlow");
            navigate(flowTransition.toUpperCase());
        } else {
             var targetUrl = cmp.get("v.destinationWebUrl");
             if ((targetUrl != "") && targetUrl) {  
                self.navigateToUrl(cmp, targetUrl);   
             }
             else {
                var pageReference = {
                    "type": destName,
                    "attributes": args, 
                    "state": state
                };
                console.log(JSON.stringify(pageReference, null, 4));
                navService.navigate(pageReference);
             }
            
          }
        
    },
    
    navigateToUrl : function(cmp, destUrl) {  
		
	    var pattern = new RegExp('^(http|https):\/\/[^ "]+$');
	    if (!pattern.test(destUrl)) {
	    		destUrl = 'http://' + destUrl;
        }
        else {
            alert("invalid URL provided to imageButton component in flow");
        }

	    var urlEvent = $A.get("e.force:navigateToURL");
	    	urlEvent.setParams({
	    		"url": destUrl
	    });
		urlEvent.fire();
	}
    
    
           
})