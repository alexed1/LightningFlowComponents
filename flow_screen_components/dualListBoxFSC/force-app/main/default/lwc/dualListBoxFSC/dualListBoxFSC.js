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
    @api valueFieldName = defaults.valueField;
    @api labelFieldName = defaults.labelField;
    @api useValueAsOutput = false;

    @track optionsInputType;
    @track optionsOutputType;
    @track _options;
    @track _selectedValues;
    @track optionsType;


    @api
    get options() {
        return this.getOptions(defaults.originalObject);
    }

    set options(value) {
        this._options = value;
        this.optionsType = defaults.originalObject;
    }

    @api
    get fullItemSetStringList() {
        return this.getOptions(defaults.list);
    }

    set fullItemSetStringList(value) {
        this._options = value;
        this.optionsType = defaults.list;
    }

    @api
    get fullItemSetCSV() {
        return this.getOptions(defaults.csv);
    }

    set fullItemSetCSV(value) {
        this._options = value;
        this.optionsType = defaults.csv;
    }

    @api
    get selectedItemsStringList() {
        this.optionsOutputType = defaults.list;
        return this.getValues(defaults.list);
    }

    set selectedItemsStringList(value) {
        this._selectedValues = value;
        this.optionsInputType = defaults.list;
    }

    @api
    get selectedItemsCSV() {
        this.optionsOutputType = defaults.csv;
        return this.getValues(defaults.csv);
    }

    set selectedItemsCSV(value) {
        this._selectedValues = value;
        this.optionsInputType = defaults.csv;
    }

    get isDataSet() {
        return  this.optionsType && this.valueFieldName && this.labelFieldName;
    }

    handleSelected(event) {
        this.selectedValues = event.detail.values;
    }

    getValues(valueType) {
        let listBox = this.template.querySelector('c-dual-list-box');
        if (listBox) {
            return listBox.getValues(valueType);
        }
    }

    getOptions(valueType) {
        let listBox = this.template.querySelector('c-dual-list-box');
        if (listBox) {
            return listBox.getOptions(valueType);
        }
    }

    @api
    get values() {
        this.optionsOutputType = defaults.csv;
        return this.getValues(defaults.originalObject);
    }

    set values(value) {
        this._selectedValues = value;
        this.optionsInputType = defaults.originalObject;
    }

}