import {LightningElement, api, track, wire} from "lwc";
import {FlowAttributeChangeEvent, FlowNavigationNextEvent} from "lightning/flowSupport";
import {getPicklistValues} from "lightning/uiObjectInfoApi";
import Quickchoice_Images from '@salesforce/resourceUrl/fsc_Quickchoice_Images';	//Static Resource containing images for Visual Cards

/* eslint-disable no-alert */
/* eslint-disable no-console */

export default class QuickChoiceFSC extends LightningElement {

    @api
    availableActions = [];

    @api masterLabel;
    @api choiceLabels;
    @api choiceValues; //string collection

    @api displayMode; //Picklist, Radio, Card (3 different selection types) - Visual is equivalent to Card

    @api numberOfColumns; //for Visual Pickers only, 1(default) or 2

    //-------------For inputMode = Picklist
    @api allowNoneToBeChosen; //For picklist field only
    @api recordTypeId; //used for picklist fields
    @api objectName; //used for picklist fields
    @api fieldName; //used for picklist fields
    @api sortList; //used for picklist fields

    //-------------For inputMode = Visual Text Box (Card)
    @api choiceIcons;
    @api includeIcons;
    @api iconSize;
    @api navOnSelect;
    @api isResponsive;

    //-------------For displayMode = Picklist or Radio
    @api style_width = 320;


    masterRecordTypeId = "012000000000000AAA"; //if a recordTypeId is not provided, use this one
    @api inputMode;
    @api required;
    picklistOptionsStorage;

    @track selectedValue;
    @track _selectedLabel;
    @track _allValues = [];
    @track _allLabels = [];
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
    @track dualColumns = false;


    @api get value() {
        return this.selectedValue;
    }

    set value(value) {
        this.selectedValue = value;
        this.setSelectedLabel();
    }

    @api get selectedLabel() {
        return this._selectedLabel;
    }

    set selectedLabel(value) {
        this._selectedLabel = value;
    }

    @api get allValues() {
        return this._allValues;
    }

    set allValues(value) {
        this._allValues = value;
    }

    @api get allLabels() {
        return this._allLabels;
    }

    set allLabels(value) {
        this._allLabels = value;
    }

    @api get radioGroup() {
        return "RG-" + this.masterLabel + "_RG";
    }

    set radioGroup(value) {
        this.radioGroup = value;
    }
    
    //possibility master record type only works if there aren't other record types?
    @wire(getPicklistValues, {
        recordTypeId: "$recordTypeId",
        fieldApiName: "$calculatedObjectAndFieldName"
    })
    picklistValues({error, data}) {
        if (data) {
            console.log("gtPicklistValues returned data");

            let picklistOptions = [];
            this._allValues = [];
            this._allLabels = [];
            if (this.allowNoneToBeChosen)
                picklistOptions.push({label: "--None--", value: "None"});

            // Picklist values
            data.values.forEach(key => {
                picklistOptions.push({
                    label: key.label,
                    value: key.value
                });
                this._allLabels.push(key.label);
                this._allValues.push(key.value);
            });

            // Sort Picklist Values
            this.picklistOptionsStorage = this.doSort(picklistOptions, this.sortList);

            console.log("displayMode is" + this.displayMode);

            if (this.inputMode === "Picklist Field") {
                this.setPicklistOptions();
            }
            if (this._allValues && this._allValues.length) {
                this.dispatchFlowAttributeChangedEvent('allValues', this._allValues);
                this.dispatchFlowAttributeChangedEvent('allLabels', this._allLabels);
            }
        } else if (error) {
            this.error = JSON.stringify(error);
            console.log("getPicklistValues wire service returned error: " + this.error);

        }
    }

    get calculatedObjectAndFieldName() {
        console.log('in getter: objectApiName is: ' + this.objectName);
        console.log('in getter: fieldApiName is: ' + this.fieldName);

        if ((this.objectName) && (this.fieldName)) {
            console.log('satisfied calculatedObjectAndFieldName test');
            return `${this.objectName}.${this.fieldName}`;
        }
        return undefined;
    }

    get gridClass() {
        return this.dualColumns ? 'slds-form-element__control slds-grid slds-gutters_medium slds-wrap slds-grid_vertical-align-center' : 'slds-form-element__control';
    }

    get gridStyle() {
        return this.dualColumns ? 'width:52rem' : '';
    }

    get columnClass() {
        return this.dualColumns ? 'slds-visual-picker slds-visual-picker_vertical slds-col slds-size_1-of-2' : 'slds-visual-picker slds-visual-picker_vertical';
    }

    get cardSize() {
        return (this.dualColumns || !this.isResponsive) ? 'width:25rem' : 'min-height: var(--lwc-sizeXxSmall,6rem) !important; height: auto !important; width: inherit !important;';
    }

    get responsiveSize() {
        return (this.dualColumns || !this.isResponsive) ? '' : 'max-width: var(--lwc-sizeLarge,25rem); width: auto !important;';
    }

    setPicklistOptions() {
        this.options = this.picklistOptionsStorage;
        if (this.selectedValue) {
            this.setSelectedLabel();
        }
    }

    doSort(value, sortFlag) {
        if (!value) {
            return;
        }
        if (!sortFlag) {
            return value;
        }
        let fieldValue = row => row['label'] || '';
        return [...value.sort(
            (a,b)=>(a=fieldValue(a).toUpperCase(),b=fieldValue(b).toUpperCase(),((a>b)-(b>a)))
        )];                
    }

    connectedCallback() {
        console.log("Entering Connected Callback for smartchoice");
        console.log("recordtypeId is: " + this.recordTypeId);
        if (!this.recordTypeId) this.recordTypeId = this.masterRecordTypeId;

        // Visual Card Selection
        let items = [];	//parameters for visual picker selection
		let index = 0;
        if (this.displayMode === "Card" || this.displayMode === "Visual") {
            this.showVisual = true;
            console.log("includeIcons is: " + this.includeIcons);
            console.log("choiceIcons is: " + this.choiceIcons);
            if (!this.includeIcons || !this.choiceIcons) {
                console.log("icons not needed");
                this.choiceIcons = this.choiceLabels;
            }
            if (this.numberOfColumns === "2") {
                this.dualColumns = true;
            }

            //User passes in Label collection of string for box header and Value collection of strings for box description
            console.log("entering input mode Visual Text Box");
            console.log("choiceLabels is: " + this.choiceLabels);
            this.choiceLabels.forEach(label => {
                //Add the correct path to custom images
                if (this.choiceIcons[index].includes(':')) {
                    items.push({name: label, description: this.choiceValues[index], icon: this.choiceIcons[index]});
                } else {
                    items.push({
                        name: label,
                        description: this.choiceValues[index],
                        icon: Quickchoice_Images + '/' + this.choiceIcons[index]
                    });
                }
                console.log("items is: " + items);
                index += 1;
            });

        }

        if (this.displayMode === "Picklist") {
            console.log("setting Picklist on");
            this.showRadio = false;
        }

        //console.log("initializing smartChoice. inputMode is: " + this.inputMode);
        let options = [];
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
                        options.push({label: value, value: value});
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
                        options.push({label: label, value: this.choiceValues[index]});
                        console.log("options is: " + options);
                        index += 1;
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

    //show default visual card as selected
    renderedCallback() {
        if (this.showVisual && this.value != null) {
            if (this.template.querySelector('[data-id="' + this.value + '"]') != null) {
                this.template.querySelector('[data-id="' + this.value + '"]').checked = true;
            }
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
        console.log('EVENT', event);
        this.selectedValue = (this.showVisual) ? event.target.value : event.detail.value;
        console.log("selected value is: " + this.selectedValue);
        this.dispatchFlowAttributeChangedEvent('value', this.selectedValue);
        if (this.navOnSelect && this.availableActions.find(action => action === 'NEXT')) {
            const navigateNextEvent = new FlowNavigationNextEvent();
            this.dispatchEvent(navigateNextEvent);
        }
    }

    setSelectedLabel() {
        if (this.options && this.options.length) {
            let selectedOption = this.options.find(curOption => curOption.value === this.selectedValue);
            if (selectedOption && selectedOption.label) {
                this._selectedLabel = selectedOption.label;
                this.dispatchFlowAttributeChangedEvent('selectedLabel', this._selectedLabel)
            }
        }
    }

    dispatchFlowAttributeChangedEvent(attributeName, attributeValue) {
        const attributeChangeEvent = new FlowAttributeChangeEvent(
            attributeName,
            attributeValue
        );
        this.dispatchEvent(attributeChangeEvent);
    }

    get inputStyle() {
        if (this.style_width) {
            return 'max-width: ' + this.style_width + 'px';
        }
        return ''

    }

}
