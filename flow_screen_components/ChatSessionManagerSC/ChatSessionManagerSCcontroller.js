({
    doInit : function(component, event, helper) {
        var actionType = component.get("v.actionType");
        var sessionId = component.get("v.sessionId");
        var sessionIdShort = (sessionId.length > 15 ? sessionId.substring(0, 15) : sessionId);

        if (actionType == 'sendMessage')
            helper.sendMessage(component, event, sessionIdShort);
        if (actionType == 'loadMessage')
            helper.loadMessage(component, event, sessionIdShort);
        if (actionType == 'endChat')
            helper.endChat(component, event, sessionIdShort);
        if (actionType == 'requestFile' && recordId != null && recordId != '') {
            var recordId = component.get("v.recordId");
            var recordIdShort = (recordId.length > 15 ? recordId.substring(0, 15) : recordId);
            
            helper.requestFile(component, event, sessionIdShort, recordIdShort);
        }
    },
})
