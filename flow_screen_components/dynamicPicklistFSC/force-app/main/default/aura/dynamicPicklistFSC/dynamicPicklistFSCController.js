({
	init: function(component, event, helper) {
		helper.component = component
		const options = component.get('v.options')
		const object = component.get('v.object')
		const field = component.get('v.field')
		const value = component.get('v.value')
		if (options.length === 0) {
			helper
				.fireApex('c.getPicklistValues', { fld: field, obj: object })
				.then(newOptions => {
					newOptions.forEach(v => {
						v.selected = v.value === value
					})
					component.set('v.options', newOptions)
				})
		}
	}
})
