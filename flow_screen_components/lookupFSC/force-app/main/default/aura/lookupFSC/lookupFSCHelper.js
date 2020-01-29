({
    hlpCheckValidity: function (component, event) {
        component.set("v.validate", function () {
            var selectedValue = component.get("v.selectedValue");
            var required = component.get("v.required");
            var label = component.get("v.label");

            if (!required || (selectedValue && !$A.util.isEmpty(selectedValue))) {
                return {
                    isValid: true
                };
            } else {
                return {
                    isValid: false,
                    errorMessage: "A selection is required for: " + label
                };
            }
        });
    }
});