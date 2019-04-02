({
    init: function (cmp, event, helper) {
        
        // Column Settings
        var cols = new Array();

        if(cmp.get('v.column01_fieldName')){
            cols.push({
                iconName: cmp.get('v.column01_icon'),
                label: cmp.get('v.column01_label'), 
                fieldName: cmp.get('v.column01_fieldName'), 
                type: cmp.get('v.column01_type'), 
                sortable: true, 
                initialWidth: cmp.get('v.column01_width'), 
                cellAttributes: {
                    alignment: cmp.get('v.column01_align')
                }
            })
        }

        if(cmp.get('v.column02_fieldName')){
            cols.push({
                label: cmp.get('v.column02_label'), 
                fieldName: cmp.get('v.column02_fieldName'), 
                type: cmp.get('v.column02_type'), 
                sortable: true, 
                initialWidth: cmp.get('v.column02_width'), 
                cellAttributes: {
                    alignment: cmp.get('v.column02_align')
                }
            })
        }

        if(cmp.get('v.column03_fieldName')){
            cols.push({
                label: cmp.get('v.column03_label'), 
                fieldName: cmp.get('v.column03_fieldName'), 
                type: cmp.get('v.column03_type'), 
                sortable: true, 
                initialWidth: cmp.get('v.column03_width'), 
                cellAttributes: {
                    alignment: cmp.get('v.column03_align')
                }
            })
        }

        if(cmp.get('v.column04_fieldName')){
            cols.push({
                label: cmp.get('v.column04_label'), 
                fieldName: cmp.get('v.column04_fieldName'), 
                type: cmp.get('v.column04_type'), 
                sortable: true, 
                initialWidth: cmp.get('v.column04_width'), 
                cellAttributes: {
                    alignment: cmp.get('v.column04_align')
                }
            })
        }

        if(cmp.get('v.column05_fieldName')){
            cols.push({
                label: cmp.get('v.column05_label'), 
                fieldName: cmp.get('v.column05_fieldName'), 
                type: cmp.get('v.column05_type'), 
                sortable: true, 
                initialWidth: cmp.get('v.column05_width'), 
                cellAttributes: {
                    alignment: cmp.get('v.column05_align')
                }
            })
        }

        if(cmp.get('v.column06_fieldName')){
            cols.push({
                label: cmp.get('v.column06_label'), 
                fieldName: cmp.get('v.column06_fieldName'), 
                type: cmp.get('v.column06_type'), 
                sortable: true, 
                initialWidth: cmp.get('v.column06_width'), 
                cellAttributes: {
                    alignment: cmp.get('v.column06_align')
                }
            })
        }

        if(cmp.get('v.column07_fieldName')){
            cols.push({
                label: cmp.get('v.column07_label'), 
                fieldName: cmp.get('v.column07_fieldName'), 
                type: cmp.get('v.column07_type'), 
                sortable: true, 
                initialWidth: cmp.get('v.column07_width'), 
                cellAttributes: {
                    alignment: cmp.get('v.column07_align')
                }
            })
        }

        if(cmp.get('v.column08_fieldName')){
            cols.push({
                label: cmp.get('v.column08_label'), 
                fieldName: cmp.get('v.column08_fieldName'), 
                type: cmp.get('v.column08_type'), 
                sortable: true, 
                initialWidth: cmp.get('v.column08_width'), 
                cellAttributes: {
                    alignment: cmp.get('v.column08_align')
                }
            })
        }      

        if(cmp.get('v.column09_fieldName')){
            cols.push({
                label: cmp.get('v.column09_label'), 
                fieldName: cmp.get('v.column09_fieldName'), 
                type: cmp.get('v.column09_type'), 
                sortable: true, 
                initialWidth: cmp.get('v.column09_width'), 
                cellAttributes: {
                    alignment: cmp.get('v.column09_align')
                }
            })
        }  

        if(cmp.get('v.column10_fieldName')){
            cols.push({
                label: cmp.get('v.column10_label'), 
                fieldName: cmp.get('v.column10_fieldName'), 
                type: cmp.get('v.column10_type'), 
                sortable: true, 
                initialWidth: cmp.get('v.column10_width'), 
                cellAttributes: {
                    alignment: cmp.get('v.column10_align')
                }
            })
        }

        cmp.set('v.mycolumns', cols);

        // Object Selection
        if(cmp.get('v.mydata_standard1').length > 0){
            cmp.set('v.mydata', cmp.get('v.mydata_standard1'));
            cmp.set('v.obj', 'standard1');
        }
        if(cmp.get('v.mydata_standard2').length > 0){
            cmp.set('v.mydata', cmp.get('v.mydata_standard2'));
            cmp.set('v.obj', 'standard2');
        }
        if(cmp.get('v.mydata_standard3').length > 0){
            cmp.set('v.mydata', cmp.get('v.mydata_standard3'));
            cmp.set('v.obj', 'standard3');
        }
        if(cmp.get('v.mydata_standard4').length > 0){
            cmp.set('v.mydata', cmp.get('v.mydata_standard4'));
            cmp.set('v.obj', 'standard4');
        }
        if(cmp.get('v.mydata_standard5').length > 0){
            cmp.set('v.mydata', cmp.get('v.mydata_standard5'));
            cmp.set('v.obj', 'standard5');
        }
        if(cmp.get('v.mydata_standard6').length > 0){
            cmp.set('v.mydata', cmp.get('v.mydata_standard6'));
            cmp.set('v.obj', 'standard6');
        }
        if(cmp.get('v.mydata_custom1').length > 0){
            cmp.set('v.mydata', cmp.get('v.mydata_custom1'));
            cmp.set('v.obj', 'custom1');
        }
        if(cmp.get('v.mydata_custom2').length > 0){
            cmp.set('v.mydata', cmp.get('v.mydata_custom2'));
            cmp.set('v.obj', 'custom2');
        }
        console.log(cmp.get('v.mydata'));
     
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
        else if(obj == 'custom1'){
            cmp.set("v.selectedRows_custom1", selectedRows);   
        }        
        else if(obj == 'custom2'){
            cmp.set("v.selectedRows_custom2", selectedRows);   
        }        

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
    
})
