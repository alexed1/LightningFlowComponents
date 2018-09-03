({
    
    closeTabs : function(component, event, helper) {
        
        /* Check to see if in Console App */
        var workspaceAPI = component.find("workspace");
        workspaceAPI.isConsoleNavigation().then(function(response) {
            var isConsole = response;           
            console.log("IsConsole: ", isConsole);
            
            /* Only Process if in a Console App */
            if (isConsole) {
                
                /* Get all of the Tab details */
                workspaceAPI.getAllTabInfo().then(function(response) {
                    var allTabs = response;
                    console.log("All Tabs Info: ", allTabs);                
                    
                    /* Save first Tab info for focus when done */
                    var firstTab = allTabs[0];
                    
                    /* Get value of Closed Pinned? parameter */
                    var closedPinned = component.get('v.closePinned');
                    
                    /* Loop through each Tab */
                    for (var t = 0, len = allTabs.length; t < len; t++) {
                        
                        /* Should I close this Tab? */
                        if (allTabs[t].closeable && (!allTabs[t].pinned || closedPinned)) {
                            
                            /* Save Tab info */
                            var closeTabId = allTabs[t].tabId;
                            var closeTitle = allTabs[t].title;
                            
                            /* Close the Tab */
                            workspaceAPI.closeTab({
                                tabId: closeTabId
                            }).then(function(response) {
                                console.log("Closed: ", closeTitle);                      
                            })
                            .catch(function(error) {
                                console.log(error);
                            });
                            
                            /* This Tab was left open */    
                        } else {
                            console.log("Left Open: ", allTabs[t].title);
                        }
                    }
                    
                    /* Put focus on first Tab */
                    workspaceAPI.focusTab({
                        tabId: firstTab.tabId
                    }).then(function(response) {
                        console.log("Focus: ", firstTab.title);
                        
                        /* Refresh first Tab */
                        workspaceAPI.refreshTab({
                            tabId: firstTab.tabId
                        }).then(function(response) {
                            console.log("Refresh: ", firstTab.title);
                        })
                        .catch(function(error) {
                            console.log(error);
                        }); 
                    })
                    .catch(function(error) {
                        console.log(error);
                    }); 
                    
                })
                .catch(function(error) {
                    console.log(error);
                });
            }
            
        })
        .catch(function(error) {
            console.log(error);
        });   
        
    },
    
})
