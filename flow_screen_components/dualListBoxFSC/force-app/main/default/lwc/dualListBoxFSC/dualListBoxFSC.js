import {LightningElement, api, track} from 'lwc';

const defaults = {
    csv: 'csv',
    list: 'list',
    originalObject: 'object',
    valueField: 'value',
    labelField: 'label'
};

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
    @api useObjectValueAsOutput = false;

    @track selectedValuesStringFormat;
    @track allOptionsStringFormat;
    @track _options;
    @track _selectedValues;

    @api
    get allOptionsFieldDescriptorList() {
        return this.getOptions(defaults.originalObject);
    }

    set allOptionsFieldDescriptorList(value) {
        this._options = value;
        this.allOptionsStringFormat = defaults.originalObject;
    }

    @api
    get allOptionsStringCollection() {
        return this.getOptions(defaults.list);
    }

    set allOptionsStringCollection(value) {
        this._options = value;
        this.allOptionsStringFormat = defaults.list;
    }

    @api
    get allOptionsCSV() {
        return this.getOptions(defaults.csv);
    }

    set allOptionsCSV(value) {
        this._options = value;
        this.allOptionsStringFormat = defaults.csv;
    }

    @api
    get selectedOptionsStringList() {
        return this.getValues(defaults.list);
    }

    set selectedOptionsStringList(value) {
        this._selectedValues = value;
        this.selectedValuesStringFormat = defaults.list;
    }

    @api
    get selectedOptionsCSV() {
        return this.getValues(defaults.csv);
    }

    set selectedOptionsCSV(value) {
        this._selectedValues = value;
        this.selectedValuesStringFormat = defaults.csv;
    }

    get isDataSet() {
        return  this.allOptionsStringFormat && this.useWhichObjectKeyForData && this.useWhichObjectKeyForLabel;
    }

    handleSelected(event) {
        this.selectedValues = event.detail.values;
    }

    getValues(valueType) {
        let listBox = this.template.querySelector('c-enhanced-dual-list-box');
        if (listBox) {
            return listBox.getValues(valueType);
        }
    }

    getOptions(valueType) {
        let listBox = this.template.querySelector('c-enhanced-dual-list-box');
        if (listBox) {
            return listBox.getOptions(valueType);
        }
    }

    @api
    get selectedOptionsFieldDescriptorList() {
        return this.getValues(defaults.originalObject);
    }

    set selectedOptionsFieldDescriptorList(value) {
        this._selectedValues = value;
        this.selectedValuesStringFormat = defaults.originalObject;
    }

}