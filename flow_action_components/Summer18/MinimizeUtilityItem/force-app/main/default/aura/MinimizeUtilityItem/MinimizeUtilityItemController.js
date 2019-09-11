({
	invoke : function(component, event, helper) {        
        var utilityAPI = component.find("utilitybar");
        utilityAPI.getUtilityInfo().then(function(response) {
            if (response.utilityVisible) {
                utilityAPI.minimizeUtility();
            }
        })
        .catch(function(error) {
            console.log(error);
        });
    }
})
