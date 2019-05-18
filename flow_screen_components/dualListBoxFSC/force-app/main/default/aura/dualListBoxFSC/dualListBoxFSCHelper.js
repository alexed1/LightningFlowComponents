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
                     selectedValuesCSV = selectedValuesCSV + ";" + curStringArray[i];
                }
         }
        		
         component.set(targetAttribute ,selectedValuesCSV);
    }
    

})
