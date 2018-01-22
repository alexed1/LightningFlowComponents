({
    init: function (cmp, event, helper) {
        
    var column1Label = cmp.get('v.column1_label');
    var column1FieldName = cmp.get('v.column1_fieldName');
    var column1Type = cmp.get('v.column1_type');
        
    var column2Label = cmp.get('v.column2_label');
    var column2FieldName = cmp.get('v.column2_fieldName');
    var column2Type = cmp.get('v.column2_type');
        
    var column3Label = cmp.get('v.column3_label');
    var column3FieldName = cmp.get('v.column3_fieldName');
    var column3Type = cmp.get('v.column3_type');
        
    var column4Label = cmp.get('v.column4_label');
    var column4FieldName = cmp.get('v.column4_fieldName');
    var column4Type = cmp.get('v.column4_type');
        
    var column5Label = cmp.get('v.column5_label');
    var column5FieldName = cmp.get('v.column5_fieldName');
    var column5Type = cmp.get('v.column5_type');
        
    cmp.set('v.mycolumns', [
        {label: column1Label, fieldName: column1FieldName, type: column1Type, sortable: true},
                {label: column2Label, fieldName: column2FieldName, type: column2Type, sortable: true},
                {label: column3Label, fieldName: column3FieldName, type: column3Type, sortable: true},
                {label: column4Label, fieldName: column4FieldName, type: column4Type, sortable: true},
                {label: column5Label, fieldName: column5FieldName, type: column5Type, sortable: true}
            ]);
     
    },
    
    getSelectedName: function (cmp, event) {
        //save the selected rows into a flow-accessible attribute
        var selectedRows = event.getParam('selectedRows');
        cmp.set("v.selectedRows", selectedRows);
        console.log("selectedRows: " + selectedRows);
        
        
        
        // Display that fieldName of the selected rows
        for (var i = 0; i < selectedRows.length; i++){
            //alert("You selected: " + selectedRows[i].opportunityName);
        }
    }
})