import {LightningElement, api, wire, track} from 'lwc';

export default class updateFieldConfigurator extends LightningElement {

    @api supportedSystemTypes;

    @track _value;
    @track _objectType;
    @track _fieldName;
    @track selectedField;
    @track textOption;
    @track formulaEditorVisible = false;
    @track formulaEditorMessage = 'Show Formula Editor';
    @track errorStrings;

    labels = {
        fieldTypeNotSupported: 'Selected field type is not supported',
        fieldValueLabel: 'Set Field Value',
        fieldNotUpdatable: 'Select field can not be updated'
    };

    customReferenceTypes = ['User'];

    @api get objectType() {
        return this._objectType;
    }

    set objectType(value) {
        this._objectType = value;
    }

    @api get fieldName() {
        return this._fieldName;
    }

    set fieldName(value) {
        this._fieldName = value;
    }

    @api get value() {
        return this._value;
    }

    set value(value) {
        this._value = value;
    }

    get textOptions() {
        let resultTextOptions = [];
        if (this.fieldProperties && !this.fieldProperties.isRequired) {
            resultTextOptions.push({label: 'A blank value (null)', value: 'null'});
        }
        resultTextOptions.push({label: 'Use a formula to set the new value', value: 'formula_builder'});
        return resultTextOptions;
    }

    get checkboxOptions() {
        return [
            {label: 'True', value: 'true'},
            {label: 'False', value: 'false'}];
    }

    handleFieldChange(event) {
        this.selectedField = JSON.parse(JSON.stringify(event.detail));
        if (this._objectType !== this.selectedField.objectType) {
            this._objectType = this.selectedField.objectType;
        }
        if (this._fieldName !== this.selectedField.fieldName) {
            this._fieldName = this.selectedField.fieldName;
        }
        if (!this.selectedField.isInit) {
            this._value = null;
        }
    }

    handleValueChange(event) {
        this._value = event.detail.value;
    }

    handleOwnerChange(event) {
        this._value = event.detail.memberId;
        // event.detail.notifyAssignee;
    }

    handleTextOptionValueChange(event) {
        this.textOption = event.detail.value;
    }

    handleSave(event) {

    }

    toggleFormulaEditor() {
        this.formulaEditorVisible = !this.formulaEditorVisible;
        if (this.formulaEditorVisible) {
            this.formulaEditorMessage = 'Hide Formula Editor';
        } else {
            this.formulaEditorMessage = 'Show Formula Editor'
        }
    }

    get showFormulaBuilderOption() {
        return this.textOption === 'formula_builder';
    }

    /* @api validate() {
        const validity = [];
        if (true) {
            this.errorStrings = 'Validation error: Test Message';
            validity.push({
                key: 'testValidityErrorKey',
                errorString: 'Test validity message',
            });
        }
    return validity;
    } */

    get fieldProperties() {
        if (this.selectedField && this.selectedField.fieldName) {
            return {
                ...this.selectedField, ...{
                    isTextField: this.selectedField.dataType === 'String' || (this.selectedField.dataType === 'Reference' && !this.customReferenceTypes.some(refType => this.selectedField.referenceTo.includes(refType))),
                    isUserReferenceField: this.selectedField.referenceTo.includes('User'),
                    isBoolean: this.selectedField.dataType === 'Boolean',
                    isPicklist: this.selectedField.dataType === 'Picklist',
                    isDateTime: this.selectedField.dataType === 'DateTime',
                    isDate: this.selectedField.dataType === 'Date',
                    isCurrency: this.selectedField.dataType === 'Currency',
                    isAddress: this.selectedField.dataType === 'Address',
                    isDouble: this.selectedField.dataType === 'Double' || this.selectedField.dataType === 'Int',
                    isTextArea: this.selectedField.dataType === 'TextArea',
                    isPhone: this.selectedField.dataType === 'Phone',
                    isUrl: this.selectedField.dataType === 'Url',
                    isDisabled: this.selectedField.updateable !== true,
                    isRequired: this.selectedField.required === true
                }
            }
        }
        return null;
    }
}