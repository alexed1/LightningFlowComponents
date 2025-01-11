import {LightningElement, api, track, wire} from 'lwc';
import {FlowAttributeChangeEvent} from 'lightning/flowSupport';
import {getObjectInfo} from 'lightning/uiObjectInfoApi';
import getObjects from '@salesforce/apex/usf3.FieldPickerController.getObjects'; // Requires Greater Than v3.0
import {standardObjectOptions} from 'c/fsc_pickObjectAndFieldUtils';
import NonePicklistValueLabel from '@salesforce/label/c.fsc_NonePicklistValueLabel';
import FieldIsNotSupportedMessage from '@salesforce/label/c.fsc_FieldIsNotSupportedMessage';
import FieldTypeNotSuportedMessage from '@salesforce/label/c.fsc_FieldTypeNotSuportedMessage';


import {flowComboboxDefaults, formattedValue, getDataType, isReference} from 'c/fsc_flowComboboxUtils';

export default class fsc_pickObjectAndField extends LightningElement {
    @api name;
    @api masterLabel;
    @api objectLabel = 'Object';
    @api fieldLabel = 'Field';
    @api disableMergefieldSelection = false;
    @api builderContext;
    @api availableObjectTypes;
    @api availableFields;
    @api isAllowAll = false;    // Eric Smith 12/18/20 - Handle a Display All Objects override
    @api DataTypeFilter;        // Andy Haas 01/03/23 - Depreciated
    @api fieldTypeFilter;       // Andy Haas 01/03/23 - Added to match the field selection component

    @api disableObjectPicklist = false;
    @api hideObjectPicklist = false;
    @api hideFieldPicklist = false;
    @api displayFieldType = false;
    @api testproperty;      // Christopher Strecker 09/25/2024 - This property does not do anything 
                            // but it cannot be removed due to current managed package restrictions 
                            // when using IsExposed is True

    @api allowFieldMultiselect = false;

    @api required = false;

    @track _objectType;
    @track _fields;
    @track _field;
    @track objectTypes = standardObjectOptions;
    @track fields;
    @track errors = [];
    @track isLoadFinished = false;
    fieldDataType;
    showCollections = false;
    picklistFieldTypeLabel = 'picklist';

    labels = {
        none: NonePicklistValueLabel,
        fieldNotSupported: FieldIsNotSupportedMessage,
        dataTypeNotSupported: FieldTypeNotSuportedMessage
    };

    get hasMasterLabel() {  // Fix artifact introduced by Christopher Strecker changes in v3.3.7
        return this.masterLabel && this.masterLabel.length > 0;
    }

    @api get objectType() {
        return this._objectType;
    }

    set objectType(value) {
        this._objectType = value;
    }

    @api get field() {
        return this._field;
    }

    get requiredSymbol() {
        return this.required ? '*' : '';
    }

    set field(value) {
        this._field = value;
        this.fieldDataType = getDataType(value);
    }

    connectedCallback() {
        if(this.fieldTypeFilter && this.fieldTypeFilter.toLowerCase() !== this.picklistFieldTypeLabel.toLowerCase()) {
            this.errors.push(this.labels.dataTypeNotSupported);
        }
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
console.log("🚀 ~ file: fsc_pickObjectAndField.js ~ line 75 ~ fsc_pickObjectAndField ~ _getObjectInfo ~ error", error, this.isAllowAll, this._objectType);
            if (!this.isAllowAll && standardObjectOptions.findIndex(obj => obj.value == this._objectType) != -1) {     // Eric Smith 12/18/20 - Error is expected for many Objects when allowing all, will use Apex to get field information
                if (Array.isArray(error.body)) {
                    this.errors.push(error.body[0].message);
                } else{
                    this.errors.push(error.body.message);
                }
            }
        } else if (data) {
            let fields = data.fields;
            let fieldResults = [];

            // Christopher Strecker 06/06/2024 - Removed from for loop and updated to support multi select
            if (this.fieldList && this.fieldList.length > 0) {

                let foundFields = [];

                let missingFields = [];

                this.fieldList.forEach(fieldName => {

                    if(fieldName && !isReference(fieldName) && !Object.prototype.hasOwnProperty.call(fields, fieldName)) {
                        missingFields.push(fieldName)
                    } else {
                        foundFields.push(fieldName);
                    }

                });

                if(foundFields && foundFields.length > 0) {
                    this._field = foundFields.join(",");
                } else {
                    this._field = null;
                }

                if(missingFields && missingFields.length > 0) {
                    this.errors.push(this.labels.fieldNotSupported + missingFields.join(","));
                }
                
            }

            for (let field in this.fields = fields) {
                if (Object.prototype.hasOwnProperty.call(fields, field)) {
                    if (this.isTypeSupported(fields[field]) && this.isFieldTypeSupported(fields[field])) {
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
                // if (this._field && !isReference(this._field) && !Object.prototype.hasOwnProperty.call(fields, this._field)) {
                //     this.errors.push(this.labels.fieldNotSupported + this._field);
                //     this._field = null;
                // }
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

    isFieldTypeSupported(field) {
        let result = false;
        /*Sahib Gadzhiev3/32/2021 DataTypeFilter property can filled in FLow Screen for field type setting. 
        used toLowerCase to remove case sensitivity(Example: 'Picklist' = 'picklist')
        */  
        if (!this.fieldTypeFilter || (!result && this.fieldTypeFilter.toLowerCase() === field.dataType.toLowerCase())) {
            result = true;    
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

    // Christopher Strecker 06/06/2024 - Added function to return this._field
    //                                   as a list in order to support multi select input
    get fieldList() {

        if (this._field) {

            if(this.allowFieldMultiselect) {
                return this.splitValues(this._field);
            } else {
                return [this._field];
            }
            
        } 

        return [];
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

    handleFieldUpdate(event) {
        console.log('in handleFieldUpdate');
        console.log(JSON.stringify(event.detail.value));
        this._field = event.detail.value.map(item => item.name).join();
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