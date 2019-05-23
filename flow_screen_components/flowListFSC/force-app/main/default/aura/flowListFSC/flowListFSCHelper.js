({
	processResponse : function(responseArray, cmp, helper) {
		//var flowSet = JSON.parse(responseString).records;
        console.log('responseArray is: ' + responseArray);
        
        helper.generateComboBoxOptionsObject(responseArray, cmp, helper);
        
	},
    
    generateComboBoxOptionsObject : function(responseArray, cmp, helper) {
        var optionList = [];
        while (responseArray.length > 0) {
            var curFlow = responseArray.shift();
            
            //configure an option as expected by the comboBox (https://developer.salesforce.com/docs/component-library/bundle/lightning:combobox/example):
            //var optionString =  {'label': 'New', 'value': 'new'}
            var optionItem = {};
            optionItem['value'] = curFlow.ApiName;
            optionItem['label'] = curFlow.Label;
            optionList.push(optionItem);
        }
        console.log('final option List: ');
        console.log(optionList);
        cmp.set('v.comboBoxOptionObject', optionList);
	}
})