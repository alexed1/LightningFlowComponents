({
    sendMessage: function(component, event, sessionIdShort) {
        var conversationKit = component.find("conversationKit");
        
        if (sessionIdShort != null && sessionIdShort != '') {
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
    
    loadMessage : function(component, event, sessionIdShort) {
        var conversationKit = component.find("conversationKit");
        
        if (sessionIdShort != null && sessionIdShort != '') {
            conversationKit.setAgentInput({
                recordId: sessionIdShort,
                message: {
                    text: component.get("v.message")
                }
            })
            .then(function(result){
                if (result) {
                    console.log("Successfully loadMessage, message: " + component.get("v.message"));
                } else {
                    console.log("Failed to loadMessage, message: " + component.get("v.message"));
                }
            });
        }
    },
    
    endChat : function(component, event, sessionIdShort) {
        var conversationKit = component.find("conversationKit");
        
        if (sessionIdShort != null && sessionIdShort != '') {
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
    
    requestFile : function(component, event, sessionIdShort, recordIdShort) {
        var conversationKit = component.find("conversationKit");
        
        if (sessionIdShort != null && sessionIdShort != '' && recordIdShort != null && recordIdShort != '') {
            console.log("requestFile on sessionId: " + sessionIdShort + ", recordId: " + recordIdShort);
            conversationKit.initFileTransfer({
                recordId: sessionIdShort,
                attachmentRecordId : recordIdShort
            });
        }
    }
})
