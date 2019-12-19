({
    init: function (cmp, event, helper) {
        
        // Maximum Row Selection
        if(cmp.get('v.singleSelection') == '1') {
            cmp.set('v.maxRowSelection','1')
        }
        
        // Hide Checkbox Column
        if(cmp.get('v.hideShow').toLowerCase() == 'hide') {
            cmp.set('v.hideCheckboxColumn', true)
        }

        // Column Settings
        var cols = new Array();
        for (var i=101; i < 111; i++) {
            var varIcon = ''            
            if(cmp.get('v.column'+i.toString().substring(1)+'_fieldName')) {
                if (i.toString().substring(1) === '01') {
                    varIcon = cmp.get('v.column'+i.toString().substring(1)+'_icon')
                }
				console.log(i);  
				var cellClass =  
					cmp.get('v.column'+i.toString().substring(1)+'_type').toLowerCase() == 'number' ||
					cmp.get('v.column'+i.toString().substring(1)+'_type').toLowerCase() == 'currency'
					? 
                	{
                		fieldName : cmp.get('v.column'+i.toString().substring(1)+'_fieldName') + 'class'
                	}
            		:
                    {};
                    
                var vEditable = (cmp.get('v.column'+i.toString().substring(1)+'_editable') == true);
            	                             
                cols.push({
                    iconName: varIcon,
                    label: cmp.get('v.column'+i.toString().substring(1)+'_label'), 
                    fieldName: cmp.get('v.column'+i.toString().substring(1)+'_fieldName'), 
                    type: cmp.get('v.column'+i.toString().substring(1)+'_type'), 
                    sortable: true, 
                    initialWidth: cmp.get('v.column'+i.toString().substring(1)+'_width'), 
                    cellAttributes: {
                        alignment: cmp.get('v.column'+i.toString().substring(1)+'_align'),
                        class: cellClass                        	
                    },
                    editable: vEditable
                });                                   
            }
        }

        cmp.set('v.mycolumns', cols);

        // Object Selection
        if(cmp.get('v.mydata_standard1') && cmp.get('v.mydata_standard1').length > 0){
            cmp.set('v.mydata', cmp.get('v.mydata_standard1'));
            cmp.set('v.obj', 'standard1');
            cmp.set('v.preSelection', cmp.get('v.selectedRows_standard1'));
        }
        if(cmp.get('v.mydata_standard2') && cmp.get('v.mydata_standard2').length > 0){
            cmp.set('v.mydata', cmp.get('v.mydata_standard2'));
            cmp.set('v.obj', 'standard2');
            cmp.set('v.preSelection', cmp.get('v.selectedRows_standard2'));
        }
        if(cmp.get('v.mydata_standard3') && cmp.get('v.mydata_standard3').length > 0){
            cmp.set('v.mydata', cmp.get('v.mydata_standard3'));
            cmp.set('v.obj', 'standard3');
            cmp.set('v.preSelection', cmp.get('v.selectedRows_standard3'));
        }
        if(cmp.get('v.mydata_standard4') && cmp.get('v.mydata_standard4').length > 0){
            cmp.set('v.mydata', cmp.get('v.mydata_standard4'));
            cmp.set('v.obj', 'standard4');
            cmp.set('v.preSelection', cmp.get('v.selectedRows_standard4'));
        }
        if(cmp.get('v.mydata_standard5') && cmp.get('v.mydata_standard5').length > 0){
            cmp.set('v.mydata', cmp.get('v.mydata_standard5'));
            cmp.set('v.obj', 'standard5');
            cmp.set('v.preSelection', cmp.get('v.selectedRows_standard5'));
        }
        if(cmp.get('v.mydata_standard6') && cmp.get('v.mydata_standard6').length > 0){
            cmp.set('v.mydata', cmp.get('v.mydata_standard6'));
            cmp.set('v.obj', 'standard6');
            cmp.set('v.preSelection', cmp.get('v.selectedRows_standard6'));
        }
//        if(cmp.get('v.mydata_custom1') && cmp.get('v.mydata_custom1').length > 0){
//            cmp.set('v.mydata', cmp.get('v.mydata_custom1'));
//            cmp.set('v.obj', 'custom1');
//            cmp.set('v.preSelection', cmp.get('v.selectedRows_custom1'));
//        }
//        if(cmp.get('v.mydata_custom2') && cmp.get('v.mydata_custom2').length > 0){
//            cmp.set('v.mydata', cmp.get('v.mydata_custom2'));
//            cmp.set('v.obj', 'custom2');
//            cmp.set('v.preSelection', cmp.get('v.selectedRows_custom2'));
//        }
        console.log(cmp.get('v.mydata'));
     	
        // Pre-selected Rows
        var rows = cmp.get('v.preSelection');
        var list = [];
        for (var i=0, len = rows.length; i < len; i++) {
            list.push(rows[i].Id);
        }
        cmp.set('v.preSelectedIds', list);

        // Save pre-edit data
        cmp.set('v.saveMydata', cmp.get('v.mydata'));
    },

    // Return Selected Table Rows
    getSelectedName: function (cmp, event) {
        //save the selected rows into a flow-accessible attribute
        var selectedRows = event.getParam('selectedRows');
        var obj = cmp.get('v.obj');
        if(obj == 'standard1'){
            cmp.set("v.selectedRows_standard1", selectedRows);    
        }
        else if(obj == 'standard2'){
            cmp.set("v.selectedRows_standard2", selectedRows);       
        }
        else if(obj == 'standard3'){
            cmp.set("v.selectedRows_standard3", selectedRows);         
        }
        else if(obj == 'standard4'){
            cmp.set("v.selectedRows_standard4", selectedRows);        
        }
        else if(obj == 'standard5'){
            cmp.set("v.selectedRows_standard5", selectedRows);   
        }
        else if(obj == 'standard6'){
            cmp.set("v.selectedRows_standard6", selectedRows);   
        }        
//        else if(obj == 'custom1'){
//            cmp.set("v.selectedRows_custom1", selectedRows);
//        }        
//        else if(obj == 'custom2'){
//            cmp.set("v.selectedRows_custom2", selectedRows);   
//        }        

    },

    // Client-side controller called by the onsort event handler
    updateColumnSorting: function (cmp, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        // assign the latest attribute with the sorted column fieldName and sorted direction
        cmp.set("v.sortedBy", fieldName);
        cmp.set("v.sortedDirection", sortDirection);
        helper.sortData(cmp, fieldName, sortDirection);
    },

    handleSave: function(cmp, event, helper) {
        helper.updateEditedValues(cmp, event);
        if(cmp.get('v.showButtons')) {
            // Clear Buttons from the Table
            cmp.find('flowTable').set('v.draftValues', null);
            // Save current table data values
            cmp.set('v.saveMydata', cmp.get('v.mydata'));
        }
    },

    cancelChanges: function (cmp, event, helper) {
        // Clear Buttons from the Table
        cmp.find('flowTable').set('v.draftValues', null);
        // Replace current table data values with the saved values
        cmp.set('v.mydata', cmp.get('v.saveMydata'));
    },    
    
})
