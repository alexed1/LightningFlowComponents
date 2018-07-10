({
  init: function (component, event, helper) {
    helper.component = component
    let options = component.get("v.options")
    let object = component.get("v.object")
    let field = component.get("v.field")
    if (options.length === 0) {
      helper.fireApex("c.getPicklistValues", { fld: field, obj: object }, "v.options");
    }
  },
})
