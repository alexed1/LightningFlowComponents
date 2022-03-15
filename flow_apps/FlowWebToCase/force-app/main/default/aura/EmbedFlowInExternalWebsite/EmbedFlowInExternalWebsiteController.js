({
    init : function (component) {
        var flow = component.find("flowData");
        flow.startFlow(component.get("v.flowName"));
    }
})