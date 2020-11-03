import {LightningElement, api, track} from 'lwc';
import {FlowAttributeChangeEvent} from "lightning/flowSupport";
import {
    defaults,
    inputTypeToOutputAttributeName,
    inputTypeToInputAttributeName
} from 'c/fsc_dualListBoxUtils';

export default class dualListBoxFSC extends LightningElement {

    @api label;
    @api sourceLabel;
    @api fieldLevelHelp;
    @api selectedLabel;

    @api min;
    @api max;
    @api disableReordering;
    @api size;
    @api required;
    @api requiredOptions;
    @api useWhichObjectKeyForData = defaults.valueField;
    @api useWhichObjectKeyForLabel = defaults.labelField;
    @api useWhichObjectKeyForSort;
    @api useObjectValueAsOutput = false;

    _allOptionsStringFormat;
    @track selectedValuesStringFormat;
    @track _options = [];
    @track _selectedValues = [];
    @track optionValues = {};
    

    set allOptionsStringFormat(value) {

        this._allOptionsStringFormat = value;
        //TODO: ask if we need to have this as a separate list of types of output parameters

        this.selectedValuesStringFormat = value;
        if (inputTypeToInputAttributeName[value] && this.optionValues[inputTypeToInputAttributeName[value]]) {
            this._options = this.optionValues[inputTypeToInputAttributeName[value]];
        }
        if (!this._selectedValues && inputTypeToOutputAttributeName[value] && this.optionValues[inputTypeToOutputAttributeName[value]]) {
            this._selectedValues = this.optionValues[inputTypeToOutputAttributeName[value]];
        }
        if (this._allOptionsStringFormat === defaults.csv && (!this._selectedValues || !this._selectedValues.length)) {
            this._selectedValues = '';
        }
    }

    set allOptionsFieldDescriptorList(value) {
        this.setOptions(inputTypeToInputAttributeName.object, value);
    }

    set allOptionsStringCollection(value) {
        this.setOptions(inputTypeToInputAttributeName.list, value);
    }

    set allOptionsStringCollectionLabels(value) {
        this.setOptions(inputTypeToInputAttributeName.twoLists, value);
    }

    set allOptionsCSV(value) {
        this.setOptions(inputTypeToInputAttributeName.csv, value);
    }

    set selectedOptionsStringList(value) {
        this.setOptions(inputTypeToOutputAttributeName.list, value);
    }

    set selectedOptionsCSV(value) {
        this.setOptions(inputTypeToOutputAttributeName.csv, value);
    }

    set selectedOptionsFieldDescriptorList(value) {
        this.setOptions(inputTypeToOutputAttributeName.object, value);
    }

    @api
    get allOptionsStringFormat() {
        return this._allOptionsStringFormat;
    }

    @api
    get allOptionsFieldDescriptorList() {
        return this.getOptions(defaults.originalObject);
    }

    @api
    get allOptionsStringCollection() {
        return this.getOptions(defaults.list);
    }

    @api
    get allOptionsStringCollectionLabels() {
        return this.getOptions(defaults.twoLists);
    }

    @api
    get allOptionsCSV() {
        return this.getOptions(defaults.csv);
    }

    @api
    get selectedOptionsStringList() {
        return this.getValues(defaults.list);
    }

    @api
    get selectedOptionsCSV() {
        return this.getValues(defaults.csv);
    }

    @api
    get selectedOptionsFieldDescriptorList() {
        return this.getValues(defaults.originalObject);
    }

    get isDataSet() {
        return this.allOptionsStringFormat && this.useWhichObjectKeyForData && this.useWhichObjectKeyForLabel;
    }

    setOptions(optionName, optionValue) {
        this.optionValues[optionName] = optionValue;
        if (this._allOptionsStringFormat && inputTypeToInputAttributeName[this._allOptionsStringFormat] === optionName && this._allOptionsStringFormat !== defaults.twoLists) {
            this._options = optionValue;
        } else if (this._allOptionsStringFormat && inputTypeToOutputAttributeName[this._allOptionsStringFormat] === optionName) {
            this._selectedValues = optionValue;
        }
        if (this._allOptionsStringFormat === defaults.twoLists && this.optionValues[inputTypeToInputAttributeName.list] && this.optionValues[inputTypeToInputAttributeName.twoLists]) {
            this.setDualListOptions();
        }
    }

    setDualListOptions() {
        this._options = [];
        let values = this.optionValues[inputTypeToInputAttributeName.list];
        let labels = this.optionValues[inputTypeToInputAttributeName.twoLists];
        if (labels.length === values.length) {
            for (let i = 0; i < values.length; i++) {
                this._options.push({label: labels[i], value: values[i]});
            }
        }
    }

    getValues(valueType) {
        let listBox = this.template.querySelector('c-fsc_extended-base-dual-list-box');
        if (listBox) {
            return listBox.getValues(valueType);
        }
    }

    getOptions(valueType) {
        let listBox = this.template.querySelector('c-fsc_extended-base-dual-list-box');
        if (listBox) {
            return listBox.getOptions(valueType);
        }
    }

    handleValueChanged(event) {
        this.dispatchFlowAttributeChangedEvent(inputTypeToOutputAttributeName[this.allOptionsStringFormat], event.detail.value);
    }

    dispatchFlowAttributeChangedEvent(attributeName, attributeValue) {
        const attributeChangeEvent = new FlowAttributeChangeEvent(
            attributeName,
            attributeValue
        );
        this.dispatchEvent(attributeChangeEvent);
    }

    @api
    validate() {
        if(this.required == true && this._selectedValues == []) { 
            return { 
                isValid: false, 
                errorMessage: 'At least one value must be selected.' 
                }; 
            } 
        else { 
            return { isValid: true }; 
        } 
    }
}