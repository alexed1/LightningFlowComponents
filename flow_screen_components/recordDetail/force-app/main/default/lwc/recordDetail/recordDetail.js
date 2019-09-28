import {LightningElement, api, track, wire} from 'lwc';
import {getRecord} from 'lightning/uiRecordApi';
import {getObjectInfo} from 'lightning/uiObjectInfoApi';

export default class recordDetail extends LightningElement {
    @api recordId;
    @api mode = 'view';
    @api elementSize = 6;

    @track objectData;
    @track recordData;
    @track fieldsToDisplay = [];
    @track loadFinished = false;
    @track objectApiName;
    @track errors = [];

    @api
    get fields() {
        return this.fieldsToDisplay.join();
    }

    searchEventHandler(event) {
        this.fields = event.detail.value;
    }

    set fields(value) {
        this.errors = [];
        if (value) {
            let fieldsArray = value.replace(/ /g, '').split(',');
            let notSupportedFields = this.getNotSupportedField(fieldsArray);
            if (notSupportedFields.length === 0) {
                this.fieldsToDisplay = fieldsArray;
            } else {
                this.errors.push('Following fields are not supported: ' + notSupportedFields.join(', '));
            }
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