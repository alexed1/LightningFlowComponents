({
  init: function (component, event, helper) {
    let type = component.get("v.type")
    component.set("v.type", type.toLowerCase())
  }
})