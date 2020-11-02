({
    doInit : function(component, event, helper) {
        var actionType = component.get("v.actionType");

        if (actionType == 'sendMessage')
            helper.sendMessage(component, event);
        if (actionType == 'loadMessage')
            helper.loadMessage(component, event);
        if (actionType == 'endChat')
            helper.endChat(component, event);
        if (actionType == 'requestFile')
            helper.requestFile(component, event);
    },
})
