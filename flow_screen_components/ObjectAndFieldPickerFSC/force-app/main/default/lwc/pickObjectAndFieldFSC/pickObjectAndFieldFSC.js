import {LightningElement, api, track, wire} from 'lwc';
import {FlowAttributeChangeEvent} from 'lightning/flowSupport';
import {getObjectInfo} from 'lightning/uiObjectInfoApi';
import getObjects from '@salesforce/apex/FieldPickerController.getObjects';

import NonePicklistValueLabel from '@salesforce/label/c.NonePicklistValueLabel';
import FieldIsNotSupportedMessage from '@salesforce/label/c.FieldIsNotSupportedMessage';

import {standardObjectOptions} from 'c/pickObjectAndFieldUtils';
import {flowComboboxDefaults, formattedValue, getDataType, isReference} from 'c/flowComboboxUtils';

export default class pickObjectAndFieldFSC extends LightningElement {
    @api name;
    @api masterLabel;
    @api objectLabel = 'Object';
    @api fieldLabel = 'Field';
    @api disableMergefieldSelection = false;
    @api builderContext;
    @api availableObjectTypes;
    @api availableFields;

    @api disableObjectPicklist = false;
    @api hideObjectPicklist = false;
    @api hideFieldPicklist = false;
    @api displayFieldType = false;


    @track _objectType;
    @track _field;
    @track objectTypes = standardObjectOptions;
    @track fields;
    @track errors = [];
    @track isLoadFinished = false;
    fieldDataType;
    showCollections = false;

    labels = {
        none: NonePicklistValueLabel,
        fieldNotSupported: FieldIsNotSupportedMessage
    };

    @api get objectType() {
        return this._objectType;
    }

    set objectType(value) {
        this._objectType = value;
    }

    @api get field() {
        return this._objectType;
    }

    set field(value) {
        this._field = value;
        this.fieldDataType = getDataType(value);
    }

    @wire(getObjects, {availableObjectTypes: '$availableObjectTypesList'})
    _getObjects({error, data}) {
        if (error) {
            this.errors.push(error.body.message);
        } else if (data) {
            this.isLoadFinished = true;
            this.objectTypes = data;
        }
    }

    @wire(getObjectInfo, {objectApiName: '$_objectType'})
    _getObjectInfo({error, data}) {
        if (error) {
            this.errors.push(error.body[0].message);
        } else if (data) {
            let fields = data.fields;
            let fieldResults = [];
            for (let field in this.fields = fields) {
                if (Object.prototype.hasOwnProperty.call(fields, field)) {
                    if (this.isTypeSupported(fields[field])) {
                        fieldResults.push({
                            label: fields[field].label,
                            value: fields[field].apiName,
                            dataType: fields[field].dataType,
                            required: fields[field].required,
                            updateable: fields[field].updateable,
                            referenceTo: (fields[field].referenceToInfos.length > 0 ? fields[field].referenceToInfos.map(curRef => {
                                return curRef.apiName
                            }) : [])
                        });
                    }
                }
                if (this._field && !isReference(this._field) && !Object.prototype.hasOwnProperty.call(fields, this._field)) {
                    this.errors.push(this.labels.fieldNotSupported + this._field);
                    this._field = null;
                }
            }
            this.fields = fieldResults;
            if (this.fields) {
                this.dispatchDataChangedEvent({...this.fields.find(curField => curField.value == this._field), ...{isInit: true}});
            }
        }
    }

    handleFlowComboboxValueChange(event) {
        if (event.detail.newValueDataType === flowComboboxDefaults.referenceDataType) {
            this._field = formattedValue(event.detail.newValue, event.detail.newValueDataType);
        } else {
            this._field = event.detail.newValue;
        }

        this.dispatchDataChangedEvent(event.detail);
    }

    get isFieldTypeVisible() {
        return (this.fieldType && this.displayFieldType);
    }

    isTypeSupported(field) {
        let result = false;
        if (!this.availableFields) {
            result = true;
        }
        if (!result && field.referenceToInfos.length > 0) {
            field.referenceToInfos.forEach(curRef => {
                if (this.availableFields.toLowerCase().includes(curRef.apiName.toLowerCase())) {
                    result = true;
                }
            });
        }
        return result;
    }

    get availableObjectTypesList() {
        if (this.availableObjectTypes) {
            return this.splitValues(this.availableObjectTypes.toLowerCase());
        } else {
            return [];
        }
    }

    get isError() {
        return this.errors.length > 0;
    }

    get errorMessage() {
        return this.errors.join('; ');
    }

    get isFieldDisabled() {
        return this._objectType == null || this.isError;
    }

    get isObjectDisabled() {
        return this.disableObjectPicklist || this.isError;
        // return !this.isLoadFinished || this.disableObjectPicklist || this.isError;
    }

    get fieldType() {
        if (this.fields && this._field) {
            let foundField = this.fields.find(e => e.value == this._field);
            return foundField ? foundField.dataType : null
        } else {
            return null;
        }
    }

    handleObjectChange(event) {
        this._objectType = event.detail.value;
        this._field = null;
        this.dispatchDataChangedEvent({});
        const attributeChangeEvent = new FlowAttributeChangeEvent('objectType', this._objectType);
        this.dispatchEvent(attributeChangeEvent);
        this.errors = [];
    }

    handleFieldChange(event) {
        this._field = event.detail.value;
        this.dispatchDataChangedEvent(this.fields.find(curField => curField.value == this._field));
        const attributeChangeEvent = new FlowAttributeChangeEvent('field', this._field);
        this.dispatchEvent(attributeChangeEvent);
    }

    dispatchDataChangedEvent(detail) {
        const memberRefreshedEvt = new CustomEvent('fieldselected', {
            bubbles: true,
            detail: {
                ...detail, ...{
                    name: this.name,
                    objectType: this._objectType,
                    fieldName: this._field
                }
            }
        });
        this.dispatchEvent(memberRefreshedEvt);
    }

    splitValues(originalString) {
        if (originalString) {
            return originalString.replace(/ /g, '').split(',');
        } else {
            return [];
        }
    };

    get renderFlowCombobox() {
        return this.builderContext && !this.disableMergefieldSelection && this.builderContext;
    }

    @api
    reportValidity() {
        let flowCombobox = this.template.querySelector('c-flow-combobox');
        if (flowCombobox) {
            if (!flowCombobox.reportValidity()) {
                return false;
            }
        }
        return true;
    }
}