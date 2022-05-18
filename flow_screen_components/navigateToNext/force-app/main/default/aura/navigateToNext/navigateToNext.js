// Modelled after
// https://developer.salesforce.com/docs/atlas.en-us.lightning.meta/lightning/components_config_for_flow_screens_navigate_custom.htm

({
  doInit: function (component, event, helper) {
    // Close the action panel
    var navigate = component.get("v.navigateFlow");
    navigate("NEXT");
  },
});
