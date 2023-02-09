({
    processChangeEvent : function(component, eventParams) {
        console.log('entering processChangeEvent');
        if(eventParams.changeType === "CHANGED") {
            console.log ('changeType is: ' + eventParams.changeType);
            this.callFlow(component, eventParams);
        }  else if(eventParams.changeType === "REMOVED") {
            console.log('record is being deleted');
            //the other launch paths don't work well when the underlying page is deleted
            var targetUrl = '/flow/' + component.get("v.targetFlowName") + '?recordId=' + component.get("v.recordId"); //added input variable
            console.log('targetURL is: ' + targetUrl);
            window.open(targetUrl);
        } else if(eventParams.changeType === "LOADED") {
            console.log ('changeType is: ' + eventParams.changeType);
            this.callFlow(component, eventParams);
        }
    },

    callFlow : function(component, eventParams) {
        console.log('entering callFlow');
        console.log ('changeType is: ' + eventParams.changeType);
        var flowApiName = component.get("v.targetFlowName");
        if (flowApiName == null || flowApiName == undefined) {
            console.log('flowApiName is null or undefined');
        } else {
            if(component.get("v.launchMode") == 'Modal') {
                component.set('v.openModal',true);

                //Set input variable
                var inputVariable = [
                    {
                        name : "recordId",
                        type : "String",
                        value: component.get("v.recordId")
                    }
                ];

                var flow = component.find("flow");
                // Check to see if flow is not null before calling startFlow
                if (flowApiName != null && flowApiName != undefined) {
                    console.log('flow is not null', flowApiName);
                    flow.startFlow(flowApiName, inputVariable); //added input variable
                } else {
                    console.log('flow is null', flow);
                }

            } else {
                //launch modelessly in a tab or browser window
                var workspaceAPI = component.find("workspace");
                workspaceAPI.isConsoleNavigation().then(function(response) {
                    console.log('current workspace is console? : ' + response);
                    if (response) {
                        //we are in console mode
                        workspaceAPI.getFocusedTabInfo()
                        .then(function(response) {
                            var targetUrl = '/flow/' + component.get("v.targetFlowName") + '?recordId=' + component.get("v.recordId"); //added input variable;
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
                        var targetUrl = '/flow/' + component.get("v.targetFlowName") + '?recordId=' + component.get("v.recordId"); //added input variable;
                        console.log('targetURL is: ' + targetUrl);
                        window.open(targetUrl);
                    }
                })
            }
        }
    }
    
})
