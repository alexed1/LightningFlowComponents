import {LightningElement, api, track} from 'lwc';

const defaults = {
    inputAttributePrefix: 'select_',
}

export default class GenerateFieldMapCpeLine extends LightningElement {
    @api name;
    @api inputObjectType;
    @api outputObjectType;
    @api fieldLabel;
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
    }

    stringifyFieldMap() {
        if (!this._fieldRows.length) {
            return null;
        }
        let outputMap = {};
        this._fieldRows.forEach(curRow => {
            outputMap[curRow.input.field] = curRow.output.field;
        });
        return JSON.stringify(outputMap);
    }

    parseFieldMap(fieldMap) {
        this._fieldRows = [];
        if (fieldMap) {
            let keyValue = JSON.parse(fieldMap);
            Object.keys(keyValue).forEach(curFieldKey => {
                let newRow = this.generateEmptyRow();
                newRow.input.field = curFieldKey;
                newRow.output.field = keyValue[curFieldKey];
                this._fieldRows.push(newRow);
            });
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
    }

    addNewRow() {
        this._fieldRows.push(this.generateEmptyRow());
    }

    generateEmptyRow() {
        return {
            input: {objectType: this.inputObjectType, field: null},
            output: {objectType: this.outputObjectType, field: null},
            id: this.rowIterator++
        }
    }

    handleOutputFieldSelected(event) {
        if (this._fieldRows) {
            let curAttributeName = event.target.name ? event.target.name.replace(defaults.inputAttributePrefix, '') : null;
            let curFieldRow = this._fieldRows.find(curRow => curRow.id == event.currentTarget.dataset.id);
            if (curFieldRow) {
                curFieldRow[curAttributeName].field = event.detail.fieldName;
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
        return result;
    }
}