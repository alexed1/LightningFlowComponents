({
	fireApexHelper: function(ApexFunctionName, params, resolve, attributeName) {
		let component = this.component
		let helper = this
		let action = component.get(ApexFunctionName)
		action.setParams(params)
		action.setCallback(this, function(a) {
			if (a.getState() === 'ERROR') {
				console.log('There was an error:')
				console.log(a.getError())
			} else if (a.getState() === 'SUCCESS') {
				if (attributeName) component.set(attributeName, a.getReturnValue())
				resolve(a.getReturnValue())
				console.log(a.getReturnValue())
			}
		})
		$A.enqueueAction(action)
	},

	fireApex: function(ApexFunctionName, params, attributeName) {
		let component = this.component
		let helper = this
		let p = new Promise(resolve => {
			helper.fireApexHelper(ApexFunctionName, params, resolve, attributeName)
		})
		return p
	}
})
