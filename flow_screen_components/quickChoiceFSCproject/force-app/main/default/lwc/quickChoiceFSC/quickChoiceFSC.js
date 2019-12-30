import { LightningElement, api, track, wire } from "lwc";
import { FlowAttributeChangeEvent } from "lightning/flowSupport";
import { getPicklistValues } from "lightning/uiObjectInfoApi";
import TYPE_FIELD from "@salesforce/schema/Account.Type";

/* eslint-disable no-alert */
/* eslint-disable no-console */

export default class SmartChoiceFSC extends LightningElement {
	@api value;
	@api masterLabel;
	@api choiceLabels;
	@api choiceValues; //string collection
	@api choiceIcons; 
	@api showIcons;
	@api iconSize;
	@api displayMode; //Picklist, Radio, Visual (3 different selection types)
	@api allowNoneToBeChosen;

	@api recordTypeId; //used for picklist fields

	@api objectName; //used for picklist fields
	@api fieldName; //used for picklist fields
	masterRecordTypeId = "012000000000000AAA"; //if a recordTypeId is not provided, use this one
	@api objectAndFieldName;

	@api inputMode;
	@api required;
	picklistOptionsStorage;

	@track selectedValue;
	@track showRadio = true;
	@track showVisual = false;
	@track legitInputModes = [
		"Picklist Field",
		"Single String Collection",
		"Dual String Collections",
		"Visual Text Box"
	];
	@track options = [];
	@track items = [];

	//possibility master record type only works if there aren't other record types?
	@wire(getPicklistValues, {
		recordTypeId: "$recordTypeId",
		fieldApiName: "$objectAndFieldName"
	})
	picklistValues({ error, data }) {
		if (data) {
			console.log("inside picklist wiring");

			let picklistOptions = [];
			if (this.allowNoneToBeChosen) 
				picklistOptions.push({ label: "--None--", value: "None" });

			// Picklist values
			data.values.forEach(key => {
				picklistOptions.push({
					label: key.label,
					value: key.value
				});
			});

			this.picklistOptionsStorage = picklistOptions;
			console.log("displayMode is" + this.displayMode);

/* 			Redundant - removed v1.14 - Eric Smith
			// Visual Picker Selection
			if (this.displayMode === "Visual") {
				this.showVisual = true;
				this.showRadio = false;
			}

			if (this.displayMode === "Picklist") {
				this.showRadio = false;
			} */

			if (this.inputMode === "Picklist Field") {
				this.setPicklistOptions();
			}
		} else if (error) {
			this.error = JSON.stringify(error);
			console.log("getPicklistValues wire service returned error: " + this.error);
			console.log("object and field " + this.objectAndFieldName);
			if (!this.objectAndFieldName)
				throw new Error("objectAndFieldName is undefined. Needs a value like Account.Rating");
		}
	}

	setPicklistOptions() {
		this.options = this.picklistOptionsStorage;
	}

	connectedCallback() {
		console.log("initializing smartchoice");
		console.log("recordtypeId is: " + this.recordTypeId);
		console.log("objectFieldName is: " + this.objectAndFieldName);
		if (!this.recordTypeId) this.recordTypeId = this.masterRecordTypeId;

		// Visual Picker Selection
		if (this.displayMode === "Visual") {
			this.showVisual = true;
			console.log("showIcons is: " + this.showIcons);
			console.log("choiceIcons is: " + this.choiceIcons);
			if (!this.showIcons || !this.choiceIcons) {
				console.log("icons not needed");
				this.choiceIcons = this.choiceLabels;
			}
		}

		if (this.displayMode === "Picklist") {
			console.log("setting Picklist on");
			this.showRadio = false;
		}

		console.log("initializing smartChoice. inputMode is: " + this.inputMode);
		let options = [];
		let items = [];	//parameters for visual text box selection
		let index = 0;
		if (this.legitInputModes.includes(this.inputMode)) {
			switch (this.inputMode) {
				//User can simply pass in a collection of strings as choiceValues. The same text is used for both label and value
				case "Single String Collection":
					console.log("entering input mode String Collection");
					console.log("choiceValues is: " + this.choiceValues);
					//console.log ('splitting choice values would be: ' + this.choiceValues.split(','));
					//let values = this.choiceValues.split(';');

					this.choiceValues.forEach(value => {
						console.log("value is: " + value);
						options.push({ label: value, value: value });
						console.log("options is: " + options);
					});
					break;

				//User can  pass in one collection of strings for visible labels and another for the underlying values (such as recordIds)
				case "Dual String Collections":
					console.log("entering input mode Dual String Collections");
					console.log("choiceValues is: " + this.choiceValues);
					//console.log ('splitting choice values would be: ' + this.choiceValues.split(','));
					//let values = this.choiceValues.split(';');

					this.choiceLabels.forEach(label => {
						console.log("label is: " + label);
						console.log("value is: " + this.choiceValues[index]);
						options.push({ label: label, value: this.choiceValues[index] });
						console.log("options is: " + options);
						index += 1;
					});
					break;
				
				//User passes in Label collection of string for box header and Value collection of strings for box description
				case "Visual Text Box":
					console.log("entering input mode Visual Text Box");
					console.log("choiceLabels is: " + this.choiceLabels);
					this.choiceLabels.forEach(label => {
						items.push({ name: label, description: this.choiceValues[index], icon: this.choiceIcons[index] });
						console.log("items is: " + items);
						index +=1;
					});
					break;

				default:
			}
			this.options = options;
			this.items = items;
		} else {
			console.log("SmartChoiceFSC: Need a valid Input Mode value. Didn't get one");
			throw new Error("SmartChoiceFSC: Need a valid Input Mode value. Didn't get one");
		}
	}

	@api
	validate() {
		//If the component is invalid, return the isValid parameter as false and return an error message.
		console.log("entering validate: required=" + this.required + " value=" + this.value);
		let errorMessage = "You must make a selection in: " + this.masterLabel + " to continue";

		if (this.required === true && !this.value) {
			return {
				isValid: false,
				errorMessage: errorMessage
			};
		}

		return { isValid: true };
	}

	handleChange(event) {
		this.selectedValue = (this.showVisual) ? event.target.value : event.detail.value;
		console.log("selected value is: " + this.selectedValue);
		const attributeChangeEvent = new FlowAttributeChangeEvent(
			"value",
			this.selectedValue
		);
		this.dispatchEvent(attributeChangeEvent);
	}

}
