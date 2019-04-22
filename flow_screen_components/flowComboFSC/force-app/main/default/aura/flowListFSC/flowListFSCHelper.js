({
    processResponse : function(responseString, cmp, helper) {
		var flowSet = JSON.parse(responseString).records;
        console.log('flowSet is: ');
        console.log(flowSet);
        
        helper.generateComboBoxOptionsObject(flowSet, cmp, helper);
        
	},
    
    generateComboBoxOptionsObject : function(flowSet, cmp, helper) {
        var optionList = [];
        while (flowSet.length > 0) {
            var curFlow = flowSet.shift();
            
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
