({
    invoke : function(component, event, helper) {
        
        var navEvt = $A.get("e.force:navigateToRelatedList");
        navEvt.setParams({
            "parentRecordId": component.get("v.parentRecordId"),
            "relatedListId": component.get("v.relatedListName")
          });
          navEvt.fire();
    }
})
