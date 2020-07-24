import {LightningElement, api, track, wire} from 'lwc';
import getPicklistValues from '@salesforce/apex/fbc_FieldPickerController.getPicklistValues';
import NonePicklistValueLabel from '@salesforce/label/c.NonePicklistValueLabel';

export default class setPickList extends LightningElement {
    @api masterLabel = 'Picklist Options';
    @api valueAboveRadioLabel = 'The value above the current one';
    @api valueBelowRadioLabel = 'The value below the current one';
    @api specificValueRadioLabel = 'A Specific Value';
    @api picklistObjectName;
    @api picklistFieldName;
    @api selectionType;
    @api value;

    @track _selectionType;
    @track _value;
    @track availableValues;
    @track errors = [];

    labels = {
        none: NonePicklistValueLabel,
        previous: '__PicklistPrevious',
        next: '__PicklistNext',
        nullValue: '__null'
    };

    connectedCallback() {
        // this._selectionType = this.selectionType;
        this._value = (this.value === null ? this.labels.nullValue : this.value);
        if (this._value === this.labels.next || this._value === this.labels.previous) {
            this._selectionType = this._value;
        } else {
            this._selectionType = this.labels.nullValue;
        }
    }

    @wire(getPicklistValues, {objectApiName: '$picklistObjectName', fieldName: '$picklistFieldName'})
    _getPicklistValues({error, data}) {
        if (error) {
            this.errors.push(error.body.message);
        } else if (data) {
            this.availableValues = JSON.parse(JSON.stringify(data));
            this.availableValues.unshift({value: this.labels.nullValue, label: this.labels.none});
        }
    }

    get picklistOptions() {
        return [
            {label: this.valueAboveRadioLabel, value: this.labels.previous},
            {label: this.valueBelowRadioLabel, value: this.labels.next},
            {label: this.specificValueRadioLabel, value: this.labels.nullValue}];
    }

    get isSpecificValue() {
        return this._selectionType === this.labels.nullValue;
    }

    handleOptionChange(event) {
        this._selectionType = event.detail.value;
        this.handlePicklistValueChange(event);
    }

    handlePicklistValueChange(event) {
        const memberRefreshedEvt = new CustomEvent('picklistselected', {
            bubbles: true, detail: {
                value: (event.detail.value === this.labels.nullValue ? null : event.detail.value),
                selectionType: this._selectionType
            }
        });
        this.dispatchEvent(memberRefreshedEvt);
    }

}