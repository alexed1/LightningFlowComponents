import { LightningElement, api, track } from 'lwc';
import { DISPLAY_TYPE_OPTIONS, AVAILABLE_OBJECT_OPTIONS, FIELD_TYPES, LAYOUT_OPTIONS, transformConstantObject } from 'c/fsc_objectFieldSelectorUtils';

const VALIDATEABLE_COMPONENTS = ['c-fsc_combobox', 'c-fsc_field-selector2', 'c-fsc_object-selector', 'input', 'radio', 'selected', 'lightning-input', 'lightning-combobox', 'lightning-checkbox', 'lightning-dual-listbox', 'lightning-radio-group', 'lightning-slider'];

// const FIELD_TYPES = [
//     { label: 'Reference (Lookup/Master-Detail)', value: 'Reference', icon: 'utility:record_lookup' },
//     { label: 'Checkbox', value: 'Boolean', icon: 'utility:check' },
//     { label: 'Currency', value: 'Currency', icon: 'utility:currency' },
//     { label: 'Date', value: 'Date', icon: 'utility:date_input' },
//     { label: 'Date/Time', value: 'DateTime', icon: 'utility:date_time' },
//     { label: 'Email', value: 'Email', icon: 'utility:email' },
//     { label: 'Geolocation', value: 'Location', icon: 'utility:location' },
//     { label: 'Number', value: 'Integer,Double', icon: 'utility:number_input' },
//     { label: 'Percent', value: 'Percent', icon: 'utility:percent' },
//     { label: 'Phone Number', value: 'Phone', icon: 'utility:phone_portrait' },
//     { label: 'Picklist', value: 'Picklist,ComboBox', icon: 'utility:picklist_type' },
//     { label: 'Picklist (Multi-Select)', value: 'MultiPicklist', icon: 'utility:multi_picklist' },
//     { label: 'Text', value: 'String', icon: 'utility:text' },
//     { label: 'Text Area', value: 'TextArea', icon: 'utility:textbox' },
//     { label: 'Text (Encrypted)', value: 'EncryptedString', icon: 'utility:hide' },
//     { label: 'Time', value: 'Time', icon: 'utility:clock' },
//     { label: 'URL', value: 'URL', icon: 'utility:link' },
// ];

export default class Fsc_objectFieldSelectorCpe extends LightningElement {
    @api builderContext;
    @api automaticOutputVariables;
    @api get inputVariables() {
        return this._values;
    }
    set inputVariables(value) {
        this._values = value;
        this.initializeValues();
    }

    @track _values;
    displayTypes = transformConstantObject(DISPLAY_TYPE_OPTIONS);
    availableObjectOptions = transformConstantObject(AVAILABLE_OBJECT_OPTIONS);
    fieldTypeOptions = transformConstantObject(FIELD_TYPES);
    layoutOptions = transformConstantObject(LAYOUT_OPTIONS);
    // availableObjectOptions = {options:[{label:'Hi', value:'hi'}, {label: 'Bye', value: 'bye'}]};
    // multiselectOptions = this.transformConstantObject(SELECT_TYPE_OTIONS);
    multiselectOptions = [ 
        { label: 'Single-Select', value: '' },
        { label: 'Multi-Select', value: 'true' },
    ];
    yesNoOptions = [ 
        { label: 'Yes', value: 'true' },
        { label: 'No', value: '' },
    ];

    // displayType = this.types.default?.value;
    // availableObjectSelection = this.availableObjectOptions.default?.value;
    // objectNames = [];
    // fieldSelectType = this.selectTypes.default?.value;
    // objectSelectType = this.selectTypes.default?.value;

    // fieldAllowMultiselect = false;
    // objectAllowMultiselect = false;
    // lockDefaultOption = '';
    // required = '';

    @track inputValues = {
        masterLabel: { value: null, label: 'Overall Component Label' },
        displayType: { value: this.displayTypes.default?.value, label: 'Display which selections to the the user?', fieldLevelHelp: '"Both" displays both object and field dropdowns, but you can lock the object dropdown so the user can only modify the field selections. Selecting "Object" enables the ability to multi-select objects. When selecting "Field", you must still specify which object to display fields from, but the object dropdown will not be displayed to the user.' },        
        required: { value: '', label: 'Required' },
        objectLabel: { value: 'Select Object', label: 'Object Label', fieldLevelHelp: 'Label for the object selection dropdown' },
        availableObjectSelection: { value: this.availableObjectOptions.default?.value, label: 'Which objects should be available?', fieldLevelHelp: '"ALL" objects includes various auxiliary objects like Feed, ChangeEvent, History, and Tag. This will impact loading times, select only if necessary.' },
        availableObjects: { value: null, label: 'Select Available Objects' },
        // objectNames: { value: null, label: 'Set Default Object' },
        objectValue: { value: null, label: 'Set Default Object' },
        fieldValue: { value: null, label: 'Set Default Field' },
        lockDefaultObject: { value: '', label: 'Lock default object?' },
        objectAllowMultiselect: { value: '', label: 'Single- or multi-select?', fieldLevelHelp: 'Determines if the user can select only a single object or multiple objects' },
        fieldLabel: { value: 'Select Field', label: 'Field Label', fieldLevelHelp: 'Label for the field selection dropdown' },
        fieldAllowMultiselect: { value: '', label: 'Single- or multi-select?', fieldLevelHelp: 'Determines if the user can select only a single field or multiple fields' },
        availableFieldTypes: { value: null, label: 'Restrict to specific field types?', fieldLevelHelp: 'Display only the selected field types in the field selection dropdown. If none are selected, all field types will be available.' },
        availableReferenceTypes: { value: null, label: 'Restrict lookups to specific objects?', /*serialized: true,*/ fieldLevelHelp: 'Restricts the available lookup fields to only those referencing the selected objects. If none are selected, lookups to all objects will be available.' },
        layout: { value: this.layoutOptions.default?.value, label: 'Layout Style' }
    };

    get showField() {
        return this.inputValues.displayType.value === DISPLAY_TYPE_OPTIONS.FIELD.value || this.inputValues.displayType.value === DISPLAY_TYPE_OPTIONS.BOTH.value;
    }

    get showObject() {
        return this.inputValues.displayType.value === DISPLAY_TYPE_OPTIONS.OBJECT.value || this.inputValues.displayType.value === DISPLAY_TYPE_OPTIONS.BOTH.value;
    }

    get showSpecificObjects() {
        return this.inputValues.availableObjectSelection.value === AVAILABLE_OBJECT_OPTIONS.SPECIFIC.value;
    }

    get disableLockDefaultObject() {
        return !this.inputValues.objectValue.value?.length;
    }

    get showAvailableReferenceTypes() {
        return this.inputValues.availableFieldTypes.value?.includes(FIELD_TYPES.REFERENCE.value)
    }

    get showLayoutOptions() {
        return this.inputValues.displayType.value === DISPLAY_TYPE_OPTIONS.BOTH.value;
    }

    @api validate() {
        const validity = [];
        let inputElements = this.template.querySelectorAll(VALIDATEABLE_COMPONENTS.join(','));
        inputElements.forEach(input => {
            let inputValidity = input.reportValidity();
            if (!inputValidity) {
                validity.push({
                    key: 'Required Field',
                    errorString: 'Required field missing',
                });
            }
        })
        return validity;
    }

    connectedCallback() {
        this.dispatchDefaultValues();
    }

    initializeValues() {
        // console.log('in initialize values');
        console.log(JSON.stringify(this._values));
        if (this._values?.length) {
            this._values.forEach(curInputParam => {
                if (curInputParam.name && this.inputValues[curInputParam.name]) {
                    this.inputValues[curInputParam.name].value = curInputParam.value;
                    this.inputValues[curInputParam.name].valueDataType = curInputParam.valueDataType;
                    if (this.inputValues[curInputParam.name].serialized) {
                        this.inputValues[curInputParam.name].value = JSON.parse(curInputParam.value);
                    }
                }
            });
        }
    }

    dispatchDefaultValues() {
        // console.log('dispatching default values');
        for (let [attributeName, attributeValue] of Object.entries(this.inputValues)) {
            if (attributeValue.value?.length) {
                this.dispatchFlowValueChangeEvent(attributeName, attributeValue.value, attributeValue.valueDataType);
            }
        }
    }

    handleValueChange(event) {
        if (event.target) {
            console.log('in handleValueChange', event.target.name);
            let curAttributeName = event.target.name;
            let curAttributeValue = event.detail?.value || event.target.value;
            let curAttributeType = 'String';
            if (event.target.type === 'checkbox') {
                curAttributeType = 'Boolean';
                curAttributeValue = event.detail.checked;
            } else if (event.target.type === 'number') {
                curAttributeType = 'Number';
            }
            if (event.target.allowMultiselect && this.inputValues[curAttributeName].isCollection) {                
                curAttributeValue = event.detail.values;
            }
            console.log('new value = '+ JSON.stringify(curAttributeValue));
            this.dispatchFlowValueChangeEvent(curAttributeName, curAttributeValue, curAttributeType);
        
            if (event.target.name === 'displayType') {
                this.inputValues.objectValue.value = null;
                this.dispatchFlowValueChangeEvent('objectValue', null);            
                this.inputValues.fieldAllowMultiselect.value = '';
                this.dispatchFlowValueChangeEvent('fieldAllowMultiselect', '');
                this.inputValues.objectAllowMultiselect.value = '';
                this.dispatchFlowValueChangeEvent('objectAllowMultiselect', '');
            }
        } else {
            console.log('in handleValueChange, event.target is empty');
        }
    }

    dispatchFlowValueChangeEvent(id, newValue = null, newValueDataType = 'String') {
        // console.log('in dispatchFlowValueChangeEvent: ', id, JSON.stringify(newValue), newValueDataType);
        if (this.inputValues[id] && this.inputValues[id].serialized) {
            // console.log('serializing value');
            newValue = JSON.stringify(newValue);
        }
        const valueChangedEvent = new CustomEvent('configuration_editor_input_value_changed', {
            bubbles: true,
            cancelable: false,
            composed: true,
            detail: {
                name: id,
                newValue: newValue,
                newValueDataType: newValueDataType
            }
        });
        this.dispatchEvent(valueChangedEvent);
    }

    // transformConstantObject(constant) {
    //     return {
    //         list: constant,
    //         get options() { return Object.values(this.list); },
    //         get default() { return this.options.find(option => option.default); },
    //         findFromValue: function (value) {
    //             let entry = this.options.find(option => option.value == value);
    //             return entry || this.default;
    //         },
    //         findFromLabel: function (label) {
    //             let entry = this.options.find(option => option.label == label);
    //             return entry || this.default;
    //         }
    //     }
    // }
}