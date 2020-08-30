({
    recordUpdated: function(component, event, helper) {
        var eventParams = event.getParams();
        if(eventParams.changeType === "CHANGED") {
            // get the fields that are changed for this record
            var changedFields = eventParams.changedFields;
            console.log('Fields that are changed: ' + JSON.stringify(changedFields));
            // record is changed so refresh the component (or other component logic)
          //  var resultsToast = $A.get("e.force:showToast");
         //   resultsToast.setParams({
         //       "title": "Saved",
          //      "message": "The record was updated."
         //   });
         //   resultsToast.fire();
            //var flowname = component.get("v.flowName");
           // console.log('flowname is: ' + flowname);
            //window.open("https://fun-page-5690-dev-ed.lightning.force.com/flow/flow1");
            var workspaceAPI = component.find("workspace");
            workspaceAPI.isConsoleNavigation().then(function(response) {
                console.log('current workspace is console? : ' + response);
                if (response) {
                    //we are in console mode
                    workspaceAPI.getFocusedTabInfo()
                    .then(function(response) {
                        var targetUrl = '/flow/' + component.get("v.flowName");
                        console.log('targetURL is: ' + targetUrl);
                        workspaceAPI.openSubtab({
                            parentTabId: response.tabId,
                            url:  targetUrl,
                            focus: true
                        })
        
                    })
                    .catch(function(error) {
                        console.log(error);
                    });
                } else {
                    console.log('need to launch flow a different way');
                    var targetUrl = '/flow/' + component.get("v.flowName");
                    console.log('targetURL is: ' + targetUrl);
                    window.open(targetUrl);
                }
            })
           
            

        }   
        else if(eventParams.changeType === "LOADED") {
            console.log("Record is loaded successfully.");
        } else if(eventParams.changeType === "REMOVED") {
            var resultsToast = $A.get("e.force:showToast");
            resultsToast.setParams({
                "title": "Deleted",
                "message": "The record was deleted."
            });
            resultsToast.fire();
        } else if(eventParams.changeType === "ERROR") {
            console.log(eventParams);
            console.log('Update event received Error: ' + component.get("v.error"));
        }
    }
})
