({
	init: function (component, event, helper) {
      console.log('initializing reventer');
      component.set('v.cometdSubscriptions', []);

	  // Disconnect CometD when leaving page
	  window.addEventListener('unload', function(event) {
	    helper.disconnectCometd(component);
	  });
        
	  // Retrieve session id
	  var action = component.get('c.getSessionId');
	  action.setCallback(this, function(response) {
	    if (component.isValid() && response.getState() === 'SUCCESS') {
	      component.set('v.sessionId', response.getReturnValue());
	      if (component.get('v.cometd') != null)
	        helper.connectCometd(component);
	    }
	    else
	      console.error(response);
	  });
	  $A.enqueueAction(action);

    },

    onCometdLoaded : function(component, event, helper) {
      console.log('inside onCometdLoaded');
	  var cometd = new org.cometd.CometD();
	  component.set('v.cometd', cometd);
	  if (component.get('v.sessionId') != null)
	    helper.connectCometd(component);
	},
    
    handleClick : function(component, event, helper) {
      console.log('refresh button clicked');
	
     helper.fireNBARefresher(component);

        
        
        
        
	}

	
    
    


})
