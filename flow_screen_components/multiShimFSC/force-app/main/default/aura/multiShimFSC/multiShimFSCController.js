({
   init : function(component, event, helper) {
		var spacerLines= component.get("v.lineCount");
        var spacerMarkup="";
        var i;
        for ( i = 0; i < spacerLines; i++) {
            spacerMarkup = spacerMarkup + "<br>"
        }
        component.set("v.linebreakHTML", spacerMarkup);
	}
})
