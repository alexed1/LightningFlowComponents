import {LightningElement, api, track, wire} from "lwc";
import {FlowAttributeChangeEvent, FlowNavigationNextEvent} from "lightning/flowSupport";
import {getPicklistValues} from "lightning/uiObjectInfoApi";
import Quickchoice_Images from '@salesforce/resourceUrl/fsc_Quickchoice_Images';	//Static Resource containing images for Visual Cards

/* eslint-disable no-alert */
/* eslint-disable no-console */

const CB_TRUE = 'CB_TRUE';

export default class QuickChoiceFSC extends LightningElement {

    bottomPadding = 'slds-p-bottom_x-small';

    @api
    availableActions = [];

    @api masterLabel;

    @api helpText;
    get showHelpText() {
        return (this.helpText?.length > 0) ? "slds-show" : "slds-hide";
    }

    @api choiceLabels = [];
    @api choiceValues = []; //string collection

    @api displayMode; //Picklist, Radio, Card (3 different selection types) - Visual is equivalent to Card

    @api numberOfColumns; //for Visual Pickers only, 1(default) or 2

    @api richTextFlagString; //Show Visual Card descriptions as RichText if value = RICHTEXT
    get showAsRichText() {
        return this.richTextFlagString == 'RICHTEXT';
    }

    //-------------For inputMode = Picklist
    @api allowNoneToBeChosen; //For picklist field only
    @api recordTypeId; //used for picklist fields
    @api objectName; //used for picklist fields
    @api fieldName; //used for picklist fields
    @api sortList; //used for picklist fields

    _controllingPicklistValue;
    _controllingCheckboxValue;
    controllingValue;
    priorControllingValue = null;
    picklistFieldDetails;
    isControlledByCheckbox = false;

    @api
    get dependentPicklist() {
        return (this.cb_dependentPicklist == CB_TRUE) ? true : false;
    }
    @api cb_dependentPicklist;

    @api
    get controllingCheckboxValue() {
        return this._controllingCheckboxValue;
    }

    set controllingCheckboxValue(value) {
        this._controllingCheckboxValue = value;
        this.controllingValue = value;
        if (value != this.priorControllingValue) {
            this.priorControllingValue = value;
            this.setPicklistSelections(this.picklistFieldDetails);
        }
    }

    @api
    get controllingPicklistValue() {
        return this._controllingPicklistValue;
    }

    set controllingPicklistValue(value) {
        this._controllingPicklistValue = value;
        this.controllingValue = value;
        if (value != this.priorControllingValue) {
            this.priorControllingValue = value;
            this.setPicklistSelections(this.picklistFieldDetails);
        }
    }

    //-------------For inputMode = Visual Text Box (Card)
    @api choiceIcons = [];
    @api includeIcons;
    @api iconSize;
    @api navOnSelect;
    @api isResponsive;
    @api isSameHeight;

    //-------------For displayMode = Picklist or Radio
    @api style_width = 320;

    @api
    get staticChoicesString() {
        return this._staticChoicesString;
    }
    set staticChoicesString(jsonString) {
        this._staticChoicesString = jsonString;
        this.staticChoices = JSON.parse(jsonString);
    }
    _staticChoicesString;

    @api
    get staticChoices() {
        return this._staticChoices || [];
    }
    set staticChoices(choices) {
        console.log(this.masterLabel + ": ", 'setting staticChoices to '+ JSON.stringify(choices));
        this._staticChoices = choices;
        this.choiceValues = [];
        this.choiceLabels = [];
        for (let choice of choices) {
            this.choiceValues.push(choice.value);
            this.choiceLabels.push(choice.label);        
        }
    }
    @track _staticChoices = [];


    masterRecordTypeId = "012000000000000AAA"; //if a recordTypeId is not provided, use this one
    @api inputMode;
    @api required;
    picklistOptionsStorage;

    // @track selectedValue;
    _selectedValue = null;
    @api 
    get selectedValue() {
        return this._selectedValue;
    }
    set selectedValue(value) {
        this._selectedValue = value;
    }

    @track _selectedLabel;
    @track _allValues = [];
    @track _allLabels = [];
    @track showRadio = true;
    @track showVisual = false;
    @track legitInputModes = [
        "Picklist Field",
        "Single String Collection",
        "Dual String Collections",
        "Visual Text Box",
        "Static Choices"
    ];
    @track options = [];
    @track items = [];
    @track dualColumns = false;
    _picklistOptions = [];
    _showPicklist = true;
    _isControlled = false;

    @api
    get picklistOptions() {
        return this._picklistOptions;
    }

    set picklistOptions(data) {
        this._picklistOptions = data;
    }

    @api 
    get showPicklist() {
        // Show if not controlled or if controlled that there are available picklist values
        this._controllingPicklistValue
        return (!this._isControlled || this._picklistOptions.length > 0 || this.isControlledByCheckbox);
    }

    set showPicklist(value) {
        this._showPicklist = value;
    }

    @api
    get isControlled() {
        return this._isControlled;
    }

    set isControlled(value) {
        this_isControlled = value;
    }

    @api 
    get value() {
        return this._selectedValue;
    }

    set value(value) {
        this._selectedValue = value;
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
    
    get requiredSymbol() {
        return this.required ? '*' : '';
    }

    //possibility master record type only works if there aren't other record types?
    @wire(getPicklistValues, {
        recordTypeId: "$recordTypeId",
        fieldApiName: "$calculatedObjectAndFieldName"
    })
    picklistValues({error, data}) {
        if (data) {
            console.log(this.masterLabel + ": ", "getPicklistValues returned data", data);
            this.setPicklistSelections(data);
            this.picklistFieldDetails = data;
        } else if (error) {
            this.error = JSON.stringify(error);
            console.log(this.masterLabel + ": ", "getPicklistValues wire service returned error: " + this.error);
        }
    }

    get calculatedObjectAndFieldName() {
        console.log(this.masterLabel + ": ", 'in getter: objectApiName is: ' + this.objectName);
        console.log(this.masterLabel + ": ", 'in getter: fieldApiName is: ' + this.fieldName);

        if ((this.objectName) && (this.fieldName)) {
            console.log(this.masterLabel + ": ", 'satisfied calculatedObjectAndFieldName test');
            return `${this.objectName}.${this.fieldName}`;
        }
        return undefined;
    }

    // Process available selections for the picklist
    setPicklistSelections(data) {

        this._picklistOptions = [];
        this._allValues = [];
        this._allLabels = [];
        if (this.allowNoneToBeChosen) {
            this._picklistOptions.push({label: "--None--", value: "None"});
        }

        // Set isControlled only if a controlling value was provided and there are available controller values
        this._isControlled = false;
        let controllingIndex;
        if (Object.keys(data.controllerValues).length > 0) {
            this._isControlled = true;
            this._showPicklist = true;
            this.isControlledByCheckbox = ((Object.keys(data.controllerValues)[0] === 'false') && (Object.keys(data.controllerValues).length = 2)) ? true : false;
            if ((this.controllingValue == undefined) && this.isControlledByCheckbox) {
                this.controllingValue = 'false';    // Start checkbox controlled picklists with a controlling value of false
            }
            controllingIndex = data.controllerValues[this.controllingValue];
        }

        // Picklist values
        data.values.forEach(key => {
            if (!this._isControlled || key.validFor.includes(controllingIndex)) {
                this._picklistOptions.push({
                    label: key.label,
                    value: key.value
                });
                this._allLabels.push(key.label);
                this._allValues.push(key.value);
            }
        });

        // Sort Picklist Values
        this.picklistOptionsStorage = this.doSort(this._picklistOptions, this.sortList);

        if (this.inputMode === "Picklist Field") {
            this.setPicklistOptions();
        }
        if (this._allValues && this._allValues.length) {
            this.dispatchFlowAttributeChangedEvent('allValues', this._allValues);
            this.dispatchFlowAttributeChangedEvent('allLabels', this._allLabels);
        }

    }

    setPicklistOptions() {
        this.options = this.picklistOptionsStorage;
        if (this._selectedValue) {
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

    get gridClass() {
        return (this.dualColumns ? 'slds-form-element__control slds-grid slds-gutters_medium slds-wrap slds-grid_vertical-align-center slds-grid_vertical-stretch ' : 'slds-form-element__control ') + this.bottomPadding;
    }

    get gridStyle() {
        return this.dualColumns ? 'width: auto;' : '';
    }

    get columnClass() {
        return this.dualColumns ? 'slds-visual-picker slds-visual-picker_vertical slds-col slds-size_1-of-2 paddingFix' : 'slds-visual-picker slds-visual-picker_vertical';
    }

    get cardSize() {
        if (this.isSameHeight && ( this.dualColumns || !this.isResponsive)) {
            return 'min-height: calc(25vh - 8rem); width: auto !important';
        } else if (this.dualColumns || this.isResponsive) {
            return 'height: min-content; width: auto !important';
        } else {
            return 'min-height: var(--lwc-sizeXxSmall,6rem) !important; height: auto !important; width: inherit !important;';
        }

    }

    get responsiveSize() {
        return (this.dualColumns || !this.isResponsive) ? '' : 'max-width: var(--lwc-sizeLarge,25rem); width: auto !important;';
    }

    connectedCallback() {
        console.log(this.masterLabel + ": ", "Entering Connected Callback for QuickChoice");
        console.log(this.masterLabel + ": ", "recordtypeId is: " + this.recordTypeId);
        if (!this.recordTypeId) this.recordTypeId = this.masterRecordTypeId;

        // Visual Card Selection
        let items = [];	//parameters for visual picker selection
		let index = 0;
        if (this.displayMode === "Card" || this.displayMode === "Visual") {
            this.showVisual = true;
            console.log(this.masterLabel + ": ", "includeIcons is: " + this.includeIcons);
            console.log(this.masterLabel + ": ", "choiceIcons is: " + this.choiceIcons);
            if (!this.includeIcons || !this.choiceIcons) {
                console.log(this.masterLabel + ": ", "icons not needed");
                this.choiceIcons = this.choiceLabels;
            }
            if (this.numberOfColumns === "2") {
                this.dualColumns = true;
            }

            //User passes in Label collection of string for box header and Value collection of strings for box description
            console.log(this.masterLabel + ": ", "entering input mode Visual Text Box");
            console.log(this.masterLabel + ": ", "choiceLabels is: " + this.choiceLabels);
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
                console.log(this.masterLabel + ": ", "items is: " + items);
                index += 1;
            });

        }

        if (this.displayMode === "Picklist") {
            console.log(this.masterLabel + ": ", "setting Picklist on");
            this.showRadio = false;
        }

        //console.log("initializing QuickChoice. inputMode is: " + this.inputMode);
        let options = [];
        if (this.legitInputModes.includes(this.inputMode)) {
            switch (this.inputMode) {
                //User can simply pass in a collection of strings as choiceValues. The same text is used for both label and value
                case "Single String Collection":
                    console.log(this.masterLabel + ": ", "entering input mode String Collection");
                    console.log(this.masterLabel + ": ", "choiceValues is: " + this.choiceValues);
                    //console.log ('splitting choice values would be: ' + this.choiceValues.split(','));
                    //let values = this.choiceValues.split(';');

                    this.choiceValues.forEach(value => {
                        console.log(this.masterLabel + ": ", "value is: " + value);
                        options.push({label: value, value: value});
                        console.log(this.masterLabel + ": ", "options is: " + options);
                    });
                    break;

                //User can  pass in one collection of strings for visible labels and another for the underlying values (such as recordIds)
                case "Dual String Collections":
                case "Static Choices":
                    console.log(this.masterLabel + ": ", "entering input mode Dual String Collections");
                    console.log(this.masterLabel + ": ", "choiceValues is: " + this.choiceValues);
                    for (let i=0; i<this.choiceLabels.length; i++) {
                        options.push({label: this.choiceLabels[i], value: this.choiceValues[i]});
                    }
                    break;

                default:
            }
            this.options = options;
            this.items = items;
            this.setSelectedLabel();  

        } else {
            console.log(this.masterLabel + ": ", "QuickChoiceFSC: Need a valid Input Mode value. Didn't get one");
            throw new Error("QuickChoiceFSC: Need a valid Input Mode value. Didn't get one");
        }
    }

    //show default visual card as selected
    renderedCallback() {
        if (this.showVisual && this.value != null) {
            if (this.template.querySelector('[data-id="' + this.value + '"]') != null) {
                this.template.querySelector('[data-id="' + this.value + '"]').checked = true;
            }
        }
        // Output default value for reactivity
        if (this._selectedValue != null) {
            this.dispatchFlowAttributeChangedEvent('value', this._selectedValue);
        }
    }

    @api
    validate() {
    	//If the component is invalid, return the isValid parameter as false and return an error message.
        console.log(this.masterLabel + ": ", "entering validate: required=" + this.required + " value=" + this.value);
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
        console.log(this.masterLabel + ": ", 'EVENT', event);
        this._selectedValue = (this.showVisual) ? event.target.value : event.detail.value;
        this.dispatchFlowAttributeChangedEvent('value', this._selectedValue);
        console.log(this.masterLabel + ": ", "selected value is: " + this._selectedValue);
        if (this.navOnSelect && this.availableActions.find(action => action === 'NEXT')) {
            const navigateNextEvent = new FlowNavigationNextEvent();
            this.dispatchEvent(navigateNextEvent);
        }
    }

    setSelectedLabel() {
        if (this.options && this.options.length) {
            let selectedOption = this.options.find(curOption => curOption.value === this._selectedValue);
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

    get inputClass() {
        return this.bottomPadding;
    }

}
