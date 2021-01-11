import { LightningElement, api, wire, track } from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';

export default class FieldViewer extends LightningElement {
    @api
    fieldNames = [];

    @api
    fieldTitleStyle = 'text-transform: uppercase';

    @api
    fieldValueStyle;

    @api
    objectInfo;

    @api
    record;

    @track
    visibleRecord = [];

    connectedCallback() {
        this.removeDuplicateFields();
        this.setupVisibleData();
    }

    /**
     * setup field labels and value to show in view
     */
    setupVisibleData() {
        if(this.objectInfo && this.objectInfo.fields) {
            this.visibleRecord =  [...Object.keys(this.objectInfo.fields).map(key => {
                let apiName = this.objectInfo.fields[key].apiName;
                if(this.fieldNames.includes(apiName)) {
                    return {fieldName: apiName, label: key, value: this.record[apiName]};
                }
            })];
            this.visibleRecord = this.visibleRecord.filter(item => {return item != null});
        }
    }

    /**
     * remove duplicate labels
     */

    removeDuplicateFields() {
        let visibleFields = [];
        let fieldData = {};
        this.fieldNames.split(',').forEach(field => {
            visibleFields.push(field.trim());
            })
        this.fieldNames = Array.from(new Set(visibleFields));
    }

}