({
    sendMessage: function(component, event) {
        var conversationKit = component.find("conversationKit");
        var sessionId = component.get("v.sessionId");
        
        if (sessionId != null && sessionId != '') {
            var sessionIdShort = (sessionId.length > 15 ? sessionId.substring(0, 15) : sessionId);
            conversationKit.sendMessage({
                recordId: sessionIdShort,
                message: {
                    text: component.get("v.message")
                }
            })
            .then(function(result){
                if (result) {
                    console.log("Successfully sent message: " + component.get("v.message"));
                } else {
                    console.log("Failed to send message: " + component.get("v.message"));
                }
            });
        }
    },
    
    setAgentInput : function(component, event) {
        var conversationKit = component.find("conversationKit");
        var sessionId = component.get("v.sessionId");
        
        if (sessionId != null && sessionId != '') {
            var sessionIdShort = (sessionId.length > 15 ? sessionId.substring(0, 15) : sessionId);
            conversationKit.setAgentInput({
                recordId: sessionIdShort,
                message: {
                    text: component.get("v.message")
                }
            })
            .then(function(result){
                if (result) {
                    console.log("Successfully setAgentInput, message: " + component.get("v.message"));
                } else {
                    console.log("Failed to setAgentInput, message: " + component.get("v.message"));
                }
            });
        }
    },
    
    endChat : function(component, event) {
        var conversationKit = component.find("conversationKit");
        var sessionId = component.get("v.sessionId");
        
        if (sessionId != null && sessionId != '') {
            var sessionIdShort = (sessionId.length > 15 ? sessionId.substring(0, 15) : sessionId);
            conversationKit.endChat({
                recordId: sessionIdShort
            })
            .then(function(result){
                if (result) {
                    console.log("Successfully endChat");
                } else {
                    console.log("Failed to endChat");
                }
            });
        }
    },
    
    initFileTransfer : function(component, event) {
        var conversationKit = component.find("conversationKit");
        var sessionId = component.get("v.sessionId");
        var recordId = component.get("v.recordId");
        
        if (sessionId != null && sessionId != '' && recordId != null && recordId != '') {
            var sessionIdShort = (sessionId.length > 15 ? sessionId.substring(0, 15) : sessionId);
            var recordIdShort = (recordId.length > 15 ? recordId.substring(0, 15) : recordId);
            console.log("AutoSendChatMessage starting conversationKit initFileTransfer on sessionId: " + sessionIdShort + ", recordId: " + recordIdShort);
            conversationKit.initFileTransfer({
                recordId: sessionIdShort,
                attachmentRecordId : recordIdShort
            });
        }
    }
})
