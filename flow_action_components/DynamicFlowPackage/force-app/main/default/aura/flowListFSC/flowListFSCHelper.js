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
            optionItem['data'] = curFlow;
            optionList.push(optionItem);
        }
        console.log('final option List: ');
        console.log(optionList);
        cmp.set('v.comboBoxOptionObject', optionList);
    },

    setComponentAttributes: function (selectedFlowApiName, cmp, helper) {
        var flowData = cmp.get('v.comboBoxOptionObject');
        for (var i = 0; i < flowData.length; i++) {
            if (flowData[i].value === selectedFlowApiName) {
                var fields = Object.keys(flowData[i].data);
                for (var c = 0; c < fields.length; c++) {
                    cmp.set('v.selectedFlow' + fields[c], flowData[i].data[fields[c]]);
                }
            }
        }
	}
})