({
    afterScriptsLoaded : function(component, event, helper) {
        var domEl = component.find("ratingArea").getElement();
        var currentRating = component.get('v.value');
        var readOnly = component.get('v.readOnly');
        var maxRating = component.get('v.maxValue');
        var callback = function(rating) {
            component.set('v.value',rating);
        }
        component.ratingObj = rating(domEl,currentRating,maxRating,callback,readOnly);
    },

    onValueChange: function(component,event,helper) {
        if (component.ratingObj) {
            var Value = component.get('v.value');
            component.ratingObj.setRating(Value,false);
        }
    }
})
