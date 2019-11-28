({
	setOptionsArray : function(itemList,targetAttribute, component ) {
        	var itemList;
            //split the list of available items and form it into the optionsArray structure that the 
            //dualListBox base component expects

            var optionsArray = [];
            for (var i = 0; i < itemList.length; i++) {
                optionsArray.push({label:itemList[i],value:itemList[i],});
            }
            component.set(targetAttribute,optionsArray);
       		
	},
    
    setCSVString : function(curStringArray, targetAttribute, component) {
        var selectedValuesCSV= "";
        for(var i=0; i< curStringArray.length; i++){
                if(selectedValuesCSV.length <=0){
                   selectedValuesCSV = curStringArray[i];
                }else{
                     selectedValuesCSV = selectedValuesCSV + "," + curStringArray[i];
                }
         }
        		
         component.set(targetAttribute ,selectedValuesCSV);
    },
    
  
    
    //the user can pass in either a csv string of the items or a string array (from a flow collection of strings)
    //determine which one is in use and set the appropriate attribute to pass to the dualListBoxt base class
    setFullStringAttribute: function(csvString, stringList, targetAttribute, component) {
        var selectedList = [];
        
        //Assemble a list of the selected items. 
        if ((csvString && stringList.length>0) || (!csvString && !stringList.length>0 && (targetAttribute == 'v.options')))  {
        	component.set('v.errorMessage', 'Error in DualListBox Flow Screen Component: You need to pass in either a comma-separated list of items or a Flow String Collection resource. You cannot pass in both or neither.');
            component.set('v.errorState', true);
            console.log('error detected');
		 } 
        else {        
            if (csvString) {
                selectedList = csvString.split(',');
            }
            if (stringList.length>0) {
                selectedList = stringList;
            }   
        }
        console.log('selectedList is: ' + selectedList);
        component.set(targetAttribute, selectedList);
    },
    
    
    //the user can pass in either a csv string of the items or a string array (from a flow collection of strings)
    //determine which one is in use and set the appropriate attribute to pass to the dualListBoxt base class
    setSelectedStringAttribute: function(csvString, stringList, targetAttribute, component) {
        var selectedList = [];
        
        //Assemble a list of the selected items. 
        if ((csvString && stringList.length>0) || (!csvString && !stringList.length>0 && (targetAttribute == 'v.options')))  {
        	component.set('v.errorMessage', 'Error in DualListBox Flow Screen Component: You need to pass in either a comma-separated list of items or a Flow String Collection resource. You cannot pass in both or neither.');
            component.set('v.errorState', true);
            console.log('error detected');
		 } 
        else {        
            if (csvString) {
                selectedList = csvString.split(',');
            }
            if (stringList.length>0) {
                selectedList = stringList;
            }   
        }
        console.log('selectedList is: ' + selectedList);
        component.set(targetAttribute, selectedList);
        
        component.set('v.values', selectedList);
    },
    
    //Set the function and error message for the validate attribute
    setValidation: function(component) {
        component.set('v.validate', function() {
            if (!component.get('v.required') || component.get('v.values').length>0) {
                return { isValid: true };
            }
            else {
                return {
                    isValid: false,
                    errorMessage: 'Please enter some valid input. Input is not optional.'
                };
            }
        });
    }

})
