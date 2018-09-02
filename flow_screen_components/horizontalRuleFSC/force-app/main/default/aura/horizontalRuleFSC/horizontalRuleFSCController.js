({
    init : function(component, event, helper) {
        
        var margin = component.get("v.verticalMarginPixels");
        var styleText = "margin: "+ margin + "px 0 " + margin + "px 0;";
        styleText = styleText + "margin-right: " + component.get("v.rightMarginSizePercent") + ";";
        styleText = styleText + "border-width: " + component.get("v.thicknessPixels") + "px;";
        styleText = styleText + "border-color: " + component.get("v.color") + ";";
		component.set("v.styleText", styleText);
	}
})
