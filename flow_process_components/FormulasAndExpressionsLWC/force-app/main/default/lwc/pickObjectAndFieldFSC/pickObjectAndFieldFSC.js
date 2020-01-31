import {LightningElement, api, track, wire} from 'lwc';
import {FlowAttributeChangeEvent} from 'lightning/flowSupport';
import {getObjectInfo} from 'lightning/uiObjectInfoApi';
import getObjects from '@salesforce/apex/FieldPickerController.getObjects';

import NonePicklistValueLabel from '@salesforce/label/c.NonePicklistValueLabel';
import FieldIsNotSupportedMessage from '@salesforce/label/c.FieldIsNotSupportedMessage';

export default class pickObjectAndFieldFSC extends LightningElement {
    @api masterLabel;
    @api objectLabel = 'Object';
    @api fieldLabel = 'Field';
    @api objectType;
    @api field;
    @api availableFields;

    @api disableObjectPicklist = false;
    @api hideObjectPicklist = false;
    @api hideFieldPicklist = false;
    @api displayFieldType = false;
    @api prependObjectNameToFieldLabel = false;

    @track _objectType;
    @track _field;
    @track _availableObjectTypes;
    @track availableObjectTypesList = [];
    @track objectTypes;
    @track fields;
    @track errors = [];
    @track isLoadFinished = false;

    labels = {
        none: NonePicklistValueLabel,
        fieldNotSupported: FieldIsNotSupportedMessage
    };

    connectedCallback() {
        if (this.objectType) {
            this._objectType = this.objectType;
            if (this.disableObjectPicklist || this.hideObjectPicklist) {
                this.availableObjectTypesList = this._availableObjectTypes ? this.splitValues(this._supportedObjectTypes.toLowerCase()) : [this._objectType];
            }
        }

        if (this.objectType && this.field)
            this._field = this.field;
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
            let objectLabel = data.label;
            let fields = data.fields;
            let fieldResults = [];
            for (let field in this.fields = fields) {
                if (Object.prototype.hasOwnProperty.call(fields, field)) {
                    if (this.isTypeSupported(fields[field])) {
                        fieldResults.push({
                            label: this.prependObjectNameToFieldLabel ? objectLabel + ': ' + fields[field].label : fields[field].label,
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
                if (this._field && !Object.prototype.hasOwnProperty.call(fields, this._field)) {
                    this.errors.push(this.labels.fieldNotSupported + this._field);
                    this._field = null;
                }
            }
            if (fieldResults) {
                fieldResults.sort((a, b) => (a.label > b.label) ? 1 : ((b.label > a.label) ? -1 : 0))
            }

            this.fields = fieldResults;

            if (this.fields) {
                this.dispatchDataChangedEvent({...this.fields.find(curField => curField.value == this._field), ...{isInit: true}});
            }
        }
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

    @api get availableObjectTypes() {
        return this._availableObjectTypes;
    }

    set availableObjectTypes(value) {
        this._availableObjectTypes = value;
        this.availableObjectTypesList = this._availableObjectTypes ? this.splitValues(this._supportedObjectTypes.toLowerCase()) : [this._objectType];
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

    get fieldType() {
        if (this._field) {
            return this.fields.find(e => e.value == this._field).dataType;
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
                    objectType: this._objectType,
                    fieldName: this._field
                }
            }
        });
        this.dispatchEvent(memberRefreshedEvt);

    }

    splitValues(originalString) {
        return originalString ? originalString.replace(/ /g, '').split(',') : [];
    };
}