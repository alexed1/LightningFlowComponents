import {LightningElement, api, track, wire} from 'lwc';
import {getRecord} from 'lightning/uiRecordApi';
import {getObjectInfo} from 'lightning/uiObjectInfoApi';
import NotSupportedMessage from '@salesforce/label/c.NotSupportedMessage';

export default class recordDetailFSC extends LightningElement {
    @api recordId;
    @api mode = 'view';

    @track elementSize = 6;
    @track objectData;
    @track recordData;
    @track fieldsToDisplay = [];
    @track notSupportedFields = [];
    @track loadFinished = false;
    @track objectApiName;
    @track errors = [];

    @api
    get fields() {
        return this.fieldsToDisplay.join();
    }

    get fieldData() {
        return this.fieldsToDisplay.map(curField => {
            let isError = !!this.notSupportedFields.find(curNSField => curNSField === curField) || !curField;
            return {
                fieldName: curField,
                isError: isError,
                errorMessage: isError ? NotSupportedMessage + ' ' + (curField ? curField : 'null') : ''
            }
        });
    }

    searchEventHandler(event) {
        this.fields = event.detail.value;
    }

    set fields(value) {
        this.errors = [];
        if (value) {
            let fieldsArray = value.replace(/^[,\s]+|[,\s]+$/g, '').replace(/\s*,\s*/g, ',').split(',');
            this.fieldsToDisplay = fieldsArray;
        } else {
            this.fieldsToDisplay = [];
        }
    }

    @wire(getRecord, {recordId: '$recordId', layoutTypes: 'Compact'})
    wiredRecord({error, data}) {
        if (error) {
            console.log(error.body[0].message)
        } else if (data) {
            this.recordData = data;
            this.objectApiName = this.recordData.apiName;
        }
    }

    @wire(getObjectInfo, {objectApiName: '$objectApiName'})
    _getObjectInfo({error, data}) {
        if (error) {
            console.log(error.body[0].message);
        } else if (data) {
            this.objectData = data;

            if (this.objectData && this.fieldsToDisplay && this.fieldsToDisplay.length === 0) {
                this.fieldsToDisplay = Object.values(this.objectData.fields).map(curField => curField.apiName);
            }

            this.notSupportedFields = this.getNotSupportedField(this.fieldsToDisplay);
            this.loadFinished = true;
        }
    }

    getNotSupportedField(fieldsToVerify) {
        let notSupportedFields = [];
        if (this.objectData) {
            fieldsToVerify.forEach(curFied => {
                if (curFied !== '' && typeof this.objectData.fields[curFied] === 'undefined') {
                    notSupportedFields.push(curFied);
                }
            });
        }
        return notSupportedFields;
    }

    get isViewMode() {
        return this.mode.toLowerCase() === 'view';
    }

    get isError() {
        return this.errors.length > 0;
    }
}