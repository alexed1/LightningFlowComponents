import {LightningElement, api, track} from 'lwc';

export default class LookupCpe extends LightningElement {

    _builderContext;
    _values;

    settings = {
        attributeObjectName: 'objectName',
        attributeDisplayWhichFieldName: 'displayWhichField',
        attributeOutputWhichValueName: 'outputWhichValue',
        attributeMasterLabel: 'fieldLabel',
        attributeSelectedValue: 'selectedValue',
        flowDataTypeString: 'String',
        flowDataTypeBoolean: 'Boolean',
        inputAttributePrefix: 'select_'
    }

    @track inputValues = {
        objectName: {value: null, valueDataType: null, isCollection: false, label: 'Lookup which Object?'},
        displayWhichField: {value: null, valueDataType: null, isCollection: false, label: 'Display which Field?'},
        outputWhichValue: {value: null, valueDataType: null, isCollection: false, label: 'Output which Field?'},
        fieldLabel: {value: null, valueDataType: null, isCollection: false, label: 'Label'},
        placeholderText: {value: null, valueDataType: null, isCollection: false, label: 'Placeholder Text'},
        showAddNewRecord: {value: null, valueDataType: null, isCollection: false, label: 'Show Add New Record '}
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

    initializeValues(value) {
        if (this._values && this._values.length) {
            this._values.forEach(curInputParam => {
                if (curInputParam.name && this.inputValues[curInputParam.name]) {
                    this.inputValues[curInputParam.name].value = curInputParam.value;
                    this.inputValues[curInputParam.name].valueDataType = curInputParam.valueDataType;
                }
            });
        }
    }

    handleDisplayFieldSelected(event) {
        this.dispatchFlowValueChangeEvent(this.settings.attributeObjectName, event.detail.objectType, this.settings.flowDataTypeString);
        this.dispatchFlowValueChangeEvent(this.settings.attributeDisplayWhichFieldName, event.detail.fieldName, this.settings.flowDataTypeString);
    }

    handleOutputFieldSelected(event) {
        this.dispatchFlowValueChangeEvent(this.settings.attributeOutputWhichValueName, event.detail.fieldName, this.settings.flowDataTypeString);
    }

    handleAttributeChange(event) {
        let curAttributeName = event.target.name ? event.target.name.replace(this.settings.inputAttributePrefix, '') : null;
        if (curAttributeName) {
            this.dispatchFlowValueChangeEvent(curAttributeName, event.currentTarget.value, this.settings.flowDataTypeString);
        }
    }

    handleBooleanAttributeChange(event) {
        let curAttributeName = event.target.name ? event.target.name.replace(this.settings.inputAttributePrefix, '') : null;
        if (curAttributeName) {
            this.dispatchFlowValueChangeEvent(curAttributeName, event.target.checked, this.settings.flowDataTypeBoolean);
        }
    }

    dispatchFlowValueChangeEvent(id, newValue, newValueDataType) {
        const valueChangedEvent = new CustomEvent('configuration_editor_input_value_changed', {
            bubbles: true,
            cancelable: false,
            composed: true,
            detail: {
                name: id,
                newValue: newValue ? newValue : null,
                newValueDataType: newValueDataType
            }
        });
        this.dispatchEvent(valueChangedEvent);
    }
}