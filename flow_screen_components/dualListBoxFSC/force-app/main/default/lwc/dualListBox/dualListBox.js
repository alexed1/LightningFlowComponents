import {LightningElement, track, api} from 'lwc';

const defaults = {
    csv: 'csv',
    list: 'list',
    originalObject: 'object',
    valueField: 'value',
    labelField: 'label',
    originalObjectOutputNotSupported: 'Object output is not supported for this option type.',
    valueLabelFieldNamesNotSupported: 'Value and Label field names should be left empty for this option type.',
    canNotUseValuesForOutput: 'Values for output can be used only with "csv" or "list" input type.'
};

export default class dualListBox extends LightningElement {

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

    @api optionsInputType = defaults.csv; //csv;list
    @api optionsOutputType = defaults.csv; //csv;list;object
    @api optionsType = defaults.csv;//csv;list;object
    @api valueFieldName = defaults.valueField;
    @api labelFieldName = defaults.labelField;
    @api useValueAsOutput = false; //used with csv or list optionsOutputType
    @track _options; //always json{label,value}
    @track _optionsOriginal; //stores original values
    @track _value; //['value1','value2','value3']

    @api
    getValues(valueType) {
        return this.formatValuesGet(this._value, valueType);
    }

    @api
    getOptions(valueType) {
        return this.formatOptionsGet(this._options, valueType);
    }

    @api
    get selectedValues() {
        return this.getValues(this.optionsOutputType);
    }

    set selectedValues(value) {
        if (!this.isError) {
            this._value = this.formatValuesSet(value, this.optionsInputType);
        }
    }

    @api
    get options() {
        return this.getOptions(this.optionsType);
    }

    set options(value) {
        if (!this.isError) {
            this._optionsOriginal = value;
            this._options = this.formatOptionsSet(value, this.optionsType);
        }
    }

    get isError() {
        if (this.optionsOutputType === defaults.originalObject && this.optionsType !== defaults.originalObject) {
            return defaults.originalObjectOutputNotSupported;
        }
        if (this.optionsType !== defaults.originalObject && (this.valueFieldName !== defaults.valueField || this.labelFieldName !== defaults.labelField)) {
            return defaults.valueLabelFieldNamesNotSupported;
        }
        if (this.useValueAsOutput && this.optionsOutputType === defaults.originalObject) {
            return defaults.canNotUseValuesForOutput;
        }
    }

    formatValuesSet(value, optionType) {
        if (!value) {
            return;
        }
        if (optionType === defaults.csv) {
            return value.replace(/[\s]+/, '').split(',');
        } else if (optionType === defaults.list) {
            return value;
        } else if (optionType === defaults.originalObject) {
            return value.map(curItem => curItem[this.valueFieldName]);
        }
    }

    formatValuesGet(items, optionType) {
        if (!items) {
            return;
        }
        let selectedValues = this.useValueAsOutput ? items : items.map(curItem => {
            return this._options.find(curFilterItem => curItem === curFilterItem.value).label;
        });
        if (optionType === defaults.csv) {
            return selectedValues.join(',');
        } else if (optionType === defaults.list) {
            return selectedValues;
        } else if (optionType === defaults.originalObject) {
            return this._optionsOriginal.filter(curOriginal => {
                return items.includes(curOriginal[this.valueFieldName]);
            });
        }
    }

    formatOptionsSet(items, optionType) {
        if (!items) {
            return;
        }
        if (optionType === defaults.csv) {
            let localItems = items.replace(/[\s]+/, '').split(',');
            return localItems.map(curItem => {
                return {label: curItem, value: curItem}
            });
        } else if (optionType === defaults.list) {
            return items.map(curItem => {
                return {label: curItem, value: curItem}
            });
        } else if (optionType === defaults.originalObject) {
            return items.map(curItem => {
                return {label: curItem[this.labelFieldName], value: curItem[this.valueFieldName]}
            });
        }
    }

    formatOptionsGet(items, optionType) {
        if (!items) {
            return;
        }
        if (optionType === defaults.csv) {
            return items.map(curItem => this.useValueAsOutput ? curItem.value : curItem.label).join(',');
        } else if (optionType === defaults.list) {
            return items.map(curItem => this.useValueAsOutput ? curItem.value : curItem.label);
        } else if (optionType === defaults.originalObject) {
            return items.map(curItem => {
                return this._optionsOriginal.find(curFilterItem => curItem.value === curFilterItem[this.valueFieldName]);
            });
        }
    }

    handleChange(event) {
        this._value = event.detail.value;
    }
}