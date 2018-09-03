({

    dispatchTabs: function(workspaceAPI, tabs, closedPinned) {
      return tabs.map(tab => {
        if (tab.closeable && (!tab.pinned || closedPinned)) {
          return this.closeTab(workspaceAPI, tab.tabId);
        }
      });
    },
  
    closeTab: function(workspaceAPI, tabId) {
      return workspaceAPI.closeTab({tabId}).catch(()=>false);
    },
  
    focusTab: function(workspaceAPI, tabId) {
      return workspaceAPI.focusTab({tabId}).catch(()=>false);
    },
  
    refreshTab: function(workspaceAPI, tabId) {
      return workspaceAPI.refreshTab({tabId}).catch(()=>false);
    },
  
  })
  