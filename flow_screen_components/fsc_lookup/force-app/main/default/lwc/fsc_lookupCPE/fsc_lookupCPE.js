import {LightningElement, api, track} from 'lwc';

const DATA_TYPE = {
    STRING: 'String',
    BOOLEAN: 'Boolean',
    NUMBER: 'Number',
    INTEGER: 'Integer'
};

const FLOW_EVENT_TYPE = {
    DELETE: 'configuration_editor_input_value_deleted',
    CHANGE: 'configuration_editor_input_value_changed'
}

const VALIDATEABLE_INPUTS = ['objectName', 'fieldsToDisplay'];


export default class Fsc_lookupCPE extends LightningElement {
    typeValue;
    _builderContext = {};
    _values = [];
    _typeMappings = [];

    showChildInputs = false;
    isMultiSelect = false;

    @track inputValues = {
        objectName: {value: null, valueDataType: null, isCollection: false, label: 'Lookup which Object?', required: true, errorMessage: 'Please select an object'},
        label: {value: 'Select Record', valueDataType: null, isCollection: false, label: 'Label'},
        fieldsToDisplay: {value: null, valueDataType: null, isCollection: true, label: 'Fields to Display', serialized: true, required: true, errorMessage: 'Please select at least one field to display'},
        fieldsToSearch: {value: null, valueDataType: null, isCollection: true, label: 'Fields to Search', serialized: true},
        whereClause: {value: null, valueDataType: null, isCollection: false, label: 'Where Clause'},
        defaultValueInput: {value: null, valueDataType: null, isCollection: false, label: 'Default Value Input'},
        required: {value: null, valueDataType: null, isCollection: false, label: 'Required'},
        messageWhenValueMissing: {value: 'Please select a record', valueDataType: null, isCollection: false, label: 'Message When Value Missing'},
        showNewRecordAction: {value: null, valueDataType: null, isCollection: false, label: 'Show New Record Action'},
        iconName: {value: null, valueDataType: null, isCollection: false, label: 'Icon Name'},
        leftIconName: {value: 'utility:search', valueDataType: null, isCollection: false, label: 'Left Icon Name'},
        rightIconName: {value: 'utility:down', valueDataType: null, isCollection: false, label: 'Right Icon Name'},
        allowMultiselect: {value: false, valueDataType: null, isCollection: false, label: 'Allow Multiselect'},
        fieldLevelHelp: {value: null, valueDataType: null, isCollection: false, label: 'Field Level Help'},
        noMatchString: {value: 'No matches found', valueDataType: null, isCollection: false, label: 'No Match String'},
        placeholder: {value: null, valueDataType: null, isCollection: false, label: 'Placeholder'},
        disabled: {value: null, valueDataType: null, isCollection: false, label: 'Disabled'},
        minimumNumberOfSelectedRecords: {value: null, valueDataType: null, isCollection: false, label: 'Minimum Number of Selected Records'},
        maximumNumberOfSelectedRecords: {value: null, valueDataType: null, isCollection: false, label: 'Maximum Number of Selected Records'},
        parentOrChildLookup: {value: 'Parent', valueDataType: null, isCollection: false, label: 'Parent or Child Lookup'},
        parentComponentApiName: {value: null, valueDataType: null, isCollection: false, label: 'Parent Component API Name'},
        childRelationshipApiName: {value: null, valueDataType: null, isCollection: false, label: 'Child Relationship API Name'},
        componentName: {value: 'parentComponent', valueDataType: null, isCollection: false, label: 'Component Name'}
    }

    @api get builderContext() {
        return this._builderContext;
    }

    set builderContext(value) {
        this._builderContext = value;
    }

    @api get inputVariables() {
        return this._values;
    }

    set inputVariables(value) {
        this._values = value;
        this.initializeValues();
    }

    @api get genericTypeMappings() {
        return this._genericTypeMappings;
    }
    set genericTypeMappings(value) {
        this._typeMappings = value;
        this.initializeTypeMappings();
    }

    get parentOrChildLookupOptions() {
        return [
            {label: 'Parent', value: 'Parent'},
            {label: 'Child', value: 'Child'}
        ];
    }

    @api validate() {
        console.log('in validate: ' + JSON.stringify(VALIDATEABLE_INPUTS));
        const validity = [];
        VALIDATEABLE_INPUTS.forEach((input) => {
            console.log('in validate: ' + input + ' = ' + this.inputValues[input].value + ' required: ' + this.inputValues[input].required)
            if ( this.inputValues[input].value.toString().length == 0 && this.inputValues[input].required) {
                console.log('in validate: ' + input + ' is required');
                let cmp = '';
                if(input == 'fieldsToDisplay'){
                    cmp = 'c-fsc_field-selector-3'
                } else if (input == 'objectName'){
                    cmp = 'c-fsc_object-selector-3'
                }
                const allValid = [...this.template.querySelectorAll(cmp)]
                .reduce((validSoFar, inputCmp) => {
                            inputCmp?.reportValidity();
                            return validSoFar;
                }, true);
                validity.push({
                    key: 'Field Required: ' + this.inputValues[input].label,
                    errorString: this.inputValues[input].errorMessage
                });
            }
        });

        return validity;
    }


    initializeValues(value) {
        if (this._values && this._values.length) {
            this._values.forEach(curInputParam => {
                if (curInputParam.name && this.inputValues[curInputParam.name]) {
                    console.log('in initializeValues: ' + curInputParam.name + ' = ' + curInputParam.value);
                    // console.log('in initializeValues: '+ JSON.stringify(curInputParam));
                    if (this.inputValues[curInputParam.name].serialized) {
                        this.inputValues[curInputParam.name].value = JSON.parse(curInputParam.value);
                    } else {
                        this.inputValues[curInputParam.name].value = curInputParam.value;
                    }
                    this.inputValues[curInputParam.name].valueDataType = curInputParam.valueDataType;
                }
            });
        }
    }

    initializeTypeMappings() {
        this._typeMappings.forEach((typeMapping) => {
            // console.log(JSON.stringify(typeMapping));
            if (typeMapping.name && typeMapping.value) {
                this.typeValue = typeMapping.value;
            }
        });
    }

    handleValueChange(event) {
        console.log('in handleValueChange: ' + JSON.stringify(event));
        if (event.detail && event.currentTarget.name) {
            let dataType = DATA_TYPE.STRING;
            if (event.currentTarget.type == 'checkbox') dataType = DATA_TYPE.BOOLEAN;
            if (event.currentTarget.type == 'number') dataType = DATA_TYPE.NUMBER;
            if (event.currentTarget.type == 'integer') dataType = DATA_TYPE.INTEGER;

            let newValue = event.currentTarget.type === 'checkbox' ? event.currentTarget.checked : event.detail.value;
            console.log('in handleValueChange: ' + event.currentTarget.name + ' = ' + newValue);
            this.dispatchFlowValueChangeEvent(event.currentTarget.name, newValue, dataType);

            // If event.currentTarget.name is parentOrChildLookup and value is 'Child' then showChildInputs is true
            console.log("event.currentTarget.name == 'parentOrChildLookup' " + (event.currentTarget.name == 'parentOrChildLookup'))
            console.log("event.currentTarget.name == 'allowMultiselect' " + (event.currentTarget.name == 'allowMultiselect'))
            if (event.currentTarget.name == 'parentOrChildLookup') {
                if (newValue === 'Child') {
                    this.showChildInputs = true;
                } else {
                    this.showChildInputs = false;
                }
                console.log('this.showChildInputs: ' + this.showChildInputs);
            }

            // If event.currentTarget.name is allowMultiselect and value is true then isMultiSelect is true
            if (event.currentTarget.name == 'allowMultiselect') {
                if (newValue) {
                    this.isMultiSelect = true;
                } else {
                    this.isMultiSelect = false;
                }
            }
        }
    }

    handleIconChange(event) {
        this.dispatchFlowValueChangeEvent('iconName', event.detail);
    }

    handleLeftIconChange(event) {
        this.dispatchFlowValueChangeEvent('leftIconName', event.detail);
    }

    handleRightIconChange(event) {
        this.dispatchFlowValueChangeEvent('rightIconName', event.detail);
    }

    handleObjectChange(event) {
        console.log('in handleObjectChange: ' + JSON.stringify(event));
        console.log('in handleObjectChange: ' + JSON.stringify(event.detail.objectType));
        console.log('in handleObjectChange: ' + JSON.stringify(event.currentTarget.name));
        this.dispatchFlowValueChangeEvent('objectName', event.detail.objectType, DATA_TYPE.STRING);
    }

    dispatchFlowValueChangeEvent(id, newValue, dataType = DATA_TYPE.STRING) {
        console.log('in dispatchFlowValueChangeEvent: ' + id, newValue, dataType);
        if (this.inputValues[id] && this.inputValues[id].serialized) {
            console.log('serializing value');
            newValue = JSON.stringify(newValue);
        }
        const valueChangedEvent = new CustomEvent(FLOW_EVENT_TYPE.CHANGE, {
            bubbles: true,
            cancelable: false,
            composed: true,
            detail: {
                name: id,
                newValue: newValue ? newValue : null,
                newValueDataType: dataType
            }
        });
        this.dispatchEvent(valueChangedEvent);
    }
}