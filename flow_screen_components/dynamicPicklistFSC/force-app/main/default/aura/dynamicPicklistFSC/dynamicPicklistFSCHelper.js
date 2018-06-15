({

  goToUrl: function (url) {
    let component = this.component;
    let helper = this;
    var urlEvent = $A.get("e.force:navigateToURL");
    if (urlEvent) {
      urlEvent.setParams({
        "url": url
      });
      urlEvent.fire();
    } else {
      window.location.href = url;
    }

  },

  goToSObject: function (objectId, isredirect) {
    //redirect is optional
    let component = this.component
    let helper = this; isredirect = isredirect || false;
    var navEvt = $A.get("e.force:navigateToSObject");
    if (navEvt) {
      navEvt.setParams({
        "recordId": objectId,
        "isredirect": isredirect
      });
      navEvt.fire();
    } else {
      window.location.href = "/" + objectId;
    }
  },

  toggleClass: function (auraId, className) {
    let component = this.component
    let helper = this;
    let el = component.find(auraId);
    if (el.length) {
      el.forEach(e => $A.util.toggleClass(e, className));
    } else {
      $A.util.toggleClass(el, className);
    }
  },

  addClass: function (auraId, className) {
    let component = this.component;
    let helper = this;
    let el = component.find(auraId);
    if (el.length) {
      el.forEach(e => $A.util.addClass(e, className));
    } else {
      $A.util.addClass(el, className);
    }

  },

  removeClass: function (auraId, className) {
    let component = this.component
    let helper = this;
    let el = component.find(auraId);
    if (el.length) {
      el.forEach(e => $A.util.removeClass(e, className));
    } else {
      $A.util.removeClass(el, className);
    }
  },

  createComponent: function (compName, attributes, location, append) {

    let component = this.component
    let helper = this;
    location = location || "v.body";
    $A.createComponent(
      compName,
      attributes,
      function (newCmp, status, errorMessage) {                //Add the new button to the body array
        if (status === "SUCCESS") {
          if (append) {
            var body = component.get(location);
            body.push(newCmp);
            component.set(location, body);
          } else {
            component.set(location, newCmp);
          }
        }
        else if (status === "INCOMPLETE") {
          console.log("No response from server or client is offline.");
          // Show offline error
        }
        else if (status === "ERROR") {
          console.log("Error: ", errorMessage);
          // Show error message
        }
      }
    );
  },
  appendComponent: function (compName, attributes, location) {
    let component = this.component
    let helper = this;
    helper.createComponent(compName, attributes, location, true);
  },

  fireApexHelper: function (ApexFunctionName, params, resolve, attributeName) {
    let component = this.component
    let helper = this;
    let action = component.get(ApexFunctionName);
    action.setParams(params);
    action.setCallback(this, function (a) {
      if (a.getState() === 'ERROR') {
        console.log("There was an error:");
        console.log(a.getError());
      } else if (a.getState() === 'SUCCESS') {
        if (attributeName) component.set(attributeName, a.getReturnValue());
        resolve(a.getReturnValue());
        console.log(a.getReturnValue());
      }

    });
    $A.enqueueAction(action);
  },

  fireApex: function (ApexFunctionName, params, attributeName) {
    let component = this.component
    let helper = this;
    let p = new Promise((resolve) => { helper.fireApexHelper(ApexFunctionName, params, resolve, attributeName) });
    return p
  },

  fireEvent: function (eventName, params) {
    let component = this.component
    let helper = this;
    var compEvent = component.getEvent(eventName);
    compEvent.setParams(params);
    compEvent.fire();
  },

  addEventHandler: function (eventName, actionName) {
    let component = this.component
    let helper = this;
    component.addHandler(eventName, component, actionName);
  }

})