import {LightningElement, api, track, wire} from 'lwc';
import {getObjectInfo} from "lightning/uiObjectInfoApi";

export default class FieldSelector extends LightningElement {
    @api fieldSelectorLabel;
    @api fieldSelectorStyle;
    @track _options = [];
    _selectedFieldPath;
    _objectType;
    _selectedObjectType;

    iconsPerType = {
        String: 'utility:text',
        Boolean: 'utility:check',
        Date: 'utility:date_input',
        DateTime: 'utility:date_time',
        Number: 'utility:number_input',
        Int: 'utility:number_input',
        Double: 'utility:number_input',
        Picklist: 'utility:picklist',
        TextArea: 'utility:textarea',
        Phone: 'utility:phone_portrait',
        Address: 'utility:location',
        Currency: 'utility:currency_input',
        Url: 'utility:link',
        SObject: 'utility:sobject'
    };

    @api
    get objectType() {
        return this._objectType;
    }

    set objectType(value) {
        this._objectType = value;
        this._selectedObjectType = value;
    }

    @wire(getObjectInfo, {objectApiName: '$_selectedObjectType'})
    _getObjectInfo({error, data}) {
        if (error) {
            console.log(error.body[0].message);
        } else if (data) {
            let tempOptions = [];
            let localKey = 0;
            Object.keys(data.fields).forEach(curField => {
                let curFieldData = data.fields[curField];
                let curDataType = curFieldData.dataType === 'Reference' ? 'SObject' : curFieldData.dataType;
                let curObjectType = curFieldData.referenceToInfos.length ? curFieldData.referenceToInfos[0].apiName : null;
                tempOptions.push({
                    type: curDataType,
                    label: curFieldData.label,
                    value: curFieldData.apiName,
                    isCollection: false,
                    objectType: curObjectType,
                    optionIcon: this.getIconNameByType(curDataType),
                    isObject: curDataType === 'SObject',
                    relationshipName: curFieldData.relationshipName,
                    displayType: curDataType === 'SObject' ? curObjectType : curDataType,
                    key: 'fieldDescriptor' + localKey++
                });
            });
            if (tempOptions && tempOptions.length) {
                this._options = tempOptions.sort((a, b) => (a.label > b.label) ? 1 : ((b.label > a.label) ? -1 : 0));
            }
        }
    }

    getIconNameByType(variableType) {
        return this.iconsPerType[variableType];
    }

    handleSetSelectedRecord(event) {
        if (event.currentTarget.dataset) {
            this.dispatchFieldSelectedEvent(this.formatValue(this._selectedFieldPath, event.currentTarget.dataset.value));
            this.clearSelected();
        }
    }

    clearSelected() {
        this._selectedObjectType = this._objectType;
        this._selectedFieldPath = null;
    }

    dispatchFieldSelectedEvent(value) {
        const filterChangedEvent = new CustomEvent('fieldselected', {
            detail: {value: value}
        });
        this.dispatchEvent(filterChangedEvent);
    }

    handleOpenObject(event) {
        // event.stopPropagation();
        this._selectedFieldPath = (this._selectedFieldPath ? this._selectedFieldPath + '.' : '') + event.currentTarget.dataset.optionValue;
        this._selectedObjectType = event.currentTarget.dataset.objectType;
    }

    formatValue(path, val) {
        return (path ? path + '.' : '') + val;
    }
}