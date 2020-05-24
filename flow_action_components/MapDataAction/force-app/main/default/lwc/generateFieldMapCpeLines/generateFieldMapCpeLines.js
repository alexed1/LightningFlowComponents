import {LightningElement, api, track} from 'lwc';

const defaults = {
    inputAttributePrefix: 'select_',
}

export default class GenerateFieldMapCpeLine extends LightningElement {
    @api name;
    @api inputObjectType;
    @api outputObjectType;
    @api fieldLabel;
    @api builderContext;
    @track _fieldRows = [];
    rowIterator = 0;

    defaults = {
        addButtonLabel: 'Add Mapping',
        removeRowLabel: 'Delete',
        inputName: 'input',
        outputName: 'output'
    }


    @api get inputMapJson() {
        return this.stringifyFieldMap();
    }

    set inputMapJson(value) {
        this.rowIterator = 0;
        this.parseFieldMap(value);
    }

    @api clearRows() {
        this._fieldRows = [];
        this.renderSingleRow();
    }

    connectedCallback() {
        this.renderSingleRow();
    }

    stringifyFieldMap() {
        if (!this._fieldRows.length) {
            return null;
        }
        let outputMap = {};
        let hasValues;
        this._fieldRows.forEach(curRow => {
            if (curRow.input.field || curRow.output.field) {
                outputMap[curRow.input.field] = curRow.output.field;
                hasValues = true;
            }
        });
        return hasValues ? JSON.stringify(outputMap) : null;
    }

    parseFieldMap(fieldMap) {
        this._fieldRows = [];
        if (fieldMap) {
            let keyValue = JSON.parse(fieldMap);
            Object.keys(keyValue).forEach(curFieldKey => {
                let newRow = this.generateEmptyRow();
                newRow.input.field = curFieldKey;
                newRow.output.field = keyValue[curFieldKey];
                if (newRow.input.field && newRow.output.field) {
                    this._fieldRows.push(newRow);
                }
            });
        }
        this.renderSingleRow();
    }

    renderSingleRow() {
        if (!this._fieldRows || !this._fieldRows.length) {
            this.addNewRow(true);
        } else if (this._fieldRows.length === 1 && !this._fieldRows[0].input.field && !this._fieldRows[0].output.field) {
            this._fieldRows[0].isRemovable = false;
        }
    }

    handleAddMapping(event) {
        this.addNewRow();
    }

    handleRemoveMapping(event) {
        this.removeRow(event.currentTarget.dataset.id);
    }

    removeRow(rowId) {
        this._fieldRows = this._fieldRows.filter(curRow => curRow.id != rowId);
        this.renderSingleRow();
    }

    addNewRow(hideRemoveOption) {
        this._fieldRows.push(this.generateEmptyRow(hideRemoveOption));
    }

    generateEmptyRow(hideRemoveOption) {
        return {
            input: {objectType: this.inputObjectType, field: null},
            output: {objectType: this.outputObjectType, field: null},
            id: this.rowIterator++,
            isRemovable: !hideRemoveOption
        }
    }

    handleOutputFieldSelected(event) {
        if (this._fieldRows) {
            let curAttributeName = event.target.name ? event.target.name.replace(defaults.inputAttributePrefix, '') : null;
            let curFieldRow = this._fieldRows.find(curRow => curRow.id == event.currentTarget.dataset.id);
            if (curFieldRow) {
                curFieldRow[curAttributeName].field = event.detail.fieldName;
                curFieldRow.isRemovable = true;
            }
        }
    }

    @api
    reportValidity() {
        let result = {hastError: false, errors: []};
        let rowNumber = 1;
        if (!this._fieldRows || !this._fieldRows.length) {
            result.hasError = true;
            result.errors.push({key: 'inputMapJson', errorString: 'At least one pair of keys should be selected'});
        } else {
            this._fieldRows.forEach(curRow => {
                if (!curRow[this.defaults.inputName].field || !curRow[this.defaults.outputName].field) {
                    result.hasError = true;
                    result.errors.push({key: rowNumber, errorString: 'Row #: ' + rowNumber + ' value can not be null'});
                }
                rowNumber++;
            });
        }
        let pickObjectAndFieldCmp = this.template.querySelectorAll('c-pick-object-and-field-f-s-c');
        if (pickObjectAndFieldCmp) {
            pickObjectAndFieldCmp.forEach(curPickObjectAndFieldCmp => {
                if (!curPickObjectAndFieldCmp.reportValidity()) {
                    result.hasError = true;
                    result.errors.push({
                        key: 'c-pick-object-and-field-f-s-c',
                        errorString: 'flow combobox  validation error'
                    });
                }
            })
        }
        return result;
    }
}