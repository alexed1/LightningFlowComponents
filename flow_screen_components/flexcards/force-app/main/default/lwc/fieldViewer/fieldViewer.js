import { LightningElement, api, wire, track } from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';

export default class FieldViewer extends LightningElement {
    @api
    fieldNames = [];

    @api
    fieldTitleStyle = 'text-transform: uppercase; overflow-wrap: break-word';

    @api
    fieldValueStyle = 'overflow-wrap: break-word';

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
                let apiName = this.objectInfo.fields[key].apiName, label = this.objectInfo.fields[key].label;
                if(this.fieldNames.includes(apiName)) {
                    return {fieldName: apiName, label, value: this.record[apiName]};
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
