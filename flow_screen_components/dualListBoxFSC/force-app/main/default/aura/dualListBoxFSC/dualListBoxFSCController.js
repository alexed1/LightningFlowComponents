({     
    init : function(component, event, helper) {
        console.log('Entering DualListBox');
        
        //convert the inputs into the form expected for the selected list in the base dualListBox
        var selectedItemsCSV = component.get('v.SelectedItemsCSV');
        var selectedItemsStringList = component.get('v.SelectedItemsStringList');
        helper.initializeItemLists(selectedItemsCSV, selectedItemsStringList, 'v.values', component);
        
        //convert the inputs into the form expected for the full list of possible items in the base dualListBox
        var fullItemsCSV = component.get('v.FullItemSetCSV');
        var fullItemsStringList = component.get('v.FullItemSetStringList');
        helper.initializeItemLists(fullItemsCSV, fullItemsStringList, 'v.FullItemSetStringList', component);

        
        
        //TODO: clone the above code for Available Items
        //TODO: support default values
        //TODO: add auraif to display the error message
        
                
        
        helper.setOptionsArray(component.get('v.FullItemSetStringList'), "v.options", component);
        
                    
     },

    handleChange : function(component, event, helper){     
        //Convert the values returned from the dualListBox base component to CSV format and store in the attribute
        var selectedValuesArray = event.getParam("value");
        helper.setCSVString(selectedValuesArray, 'v.SelectedItemsCSV', component);
           
    }
})