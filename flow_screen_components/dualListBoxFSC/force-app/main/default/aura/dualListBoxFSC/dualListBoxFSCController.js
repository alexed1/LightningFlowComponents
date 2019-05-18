({     
    init : function(component, event, helper) {
        console.log('Entering DualListBox');
        var selectedItemsCSV = component.get('v.SelectedItemsCSV');
        var fullItemsCSV = component.get('v.FullItemSet');
        
        var selectedList = [];
        if (selectedItemsCSV) {
            selectedList = selectedItemsCSV.split(';');
        }
        
        helper.setOptionsArray(fullItemsCSV.split(';'), "v.options", component);
        component.set('v.values', selectedList);
                    
     },

    handleChange : function(component, event, helper){     
        //Convert the values returned from the dualListBox base component to CSV format and store in the attribute
        var selectedValuesArray = event.getParam("value");
        helper.setCSVString(selectedValuesArray, 'v.SelectedItemsCSV', component);
           
    }
})