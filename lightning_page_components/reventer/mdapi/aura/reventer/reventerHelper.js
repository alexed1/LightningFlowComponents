({
	connectCometd : function(component) {
    var helper = this;

    // Configure CometD
    var cometdUrl = window.location.protocol+'//'+window.location.hostname+'/cometd/40.0/';
    var cometd = component.get('v.cometd');
    cometd.configure({
      url: cometdUrl,
      requestHeaders: { Authorization: 'OAuth '+ component.get('v.sessionId')},
      appendMessageTypeToURL : false
    });
    cometd.websocketEnabled = false;

    // Establish CometD connection
    console.log('Connecting to CometD: '+ cometdUrl);
    cometd.handshake(function(handshakeReply) {
      if (handshakeReply.successful) {
        console.log('Connected to CometD.');
        // Subscribe to platform event
        var newSubscription = cometd.subscribe('/event/NBARefreshRequest__e',
          function(platformEvent) {
            console.log('Platform event received: '+ JSON.stringify(platformEvent));
            helper.onReceiveNotification(component, platformEvent);
          }
        );

        // Save subscription for later
        var subscriptions = component.get('v.cometdSubscriptions');
        subscriptions.push(newSubscription);


        component.set('v.cometdSubscriptions', subscriptions);
      }
      else
        console.error('Failed to connected to CometD.');
    });
  },

  disconnectCometd : function(component) {
  	var helper = this;
    var cometd = component.get('v.cometd');

    // Unsuscribe all CometD subscriptions
    cometd.batch(function() {
      var subscriptions = component.get('v.cometdSubscriptions');
      subscriptions.forEach(function (subscription) {
        cometd.unsubscribe(subscription);
      });
    });
    component.set('v.cometdSubscriptions', []);

    // Disconnect CometD
    cometd.disconnect();
    console.log('CometD disconnected.');
    //helper.connectCometd(component);
  },

  onReceiveNotification : function(component, platformEvent) {
    var helper = this;
    helper.fireNBARefresher(component);
    },
    
  fireNBARefresher : function(component) {
     var appEvt = $A.get("e.lightning:nextBestActionsRefresh");
      if (!$A.util.isEmpty(component.get("v.recordId"))) {
            appEvt.setParam("recordId", component.get("v.recordId"));
      }
      appEvt.fire();
        
    },

  displayToast : function(component, type, message) {
    var toastEvent = $A.get('e.force:showToast');
    toastEvent.setParams({
      type: type,
      message: message
    });
    toastEvent.fire();
  }
})