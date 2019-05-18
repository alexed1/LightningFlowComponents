({     
    init : function(component, event, helper) {
        console.log('Entering DualListBox');
        
        //handle the full set of possible choices. Make sure the user isn't passing in two different inputs, which might not match
        //convert the inputs into the form expected for the full list of possible items in the base dualListBox
        var fullItemsCSV = component.get('v.FullItemSetCSV');
        var fullItemsStringList = component.get('v.FullItemSetStringList');
        helper.initializeItemLists(fullItemsCSV, fullItemsStringList, 'v.FullItemSetStringList', component);

        var selectedList = [];

        component.set('v.values', selectedList);
    
    
        
        //TODO: support default values
   
        
                
        
        helper.setOptionsArray(component.get('v.FullItemSetStringList'), "v.options", component);
        
                    
     },

    handleChange : function(component, event, helper){     
        //Convert the values returned from the dualListBox base component to CSV format and store in the attribute
        var selectedValuesArray = event.getParam("value");
        helper.setCSVString(selectedValuesArray, 'v.SelectedItemsCSV', component);
        
        //also update this component's representation of the base component's selection
        component.set('v.SelectedItemsStringList', selectedValuesArray);
    }
})