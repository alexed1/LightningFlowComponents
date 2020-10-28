({
    doInit : function(component, event, helper) {
        var actionType = component.get("v.actionType");

        if (actionType == 'sendMessage')
            helper.sendMessage(component, event);
        if (actionType == 'setAgentInput')
            helper.setAgentInput(component, event);
        if (actionType == 'endChat')
            helper.endChat(component, event);
        if (actionType == 'initFileTransfer')
            helper.initFileTransfer(component, event);
    }
})
