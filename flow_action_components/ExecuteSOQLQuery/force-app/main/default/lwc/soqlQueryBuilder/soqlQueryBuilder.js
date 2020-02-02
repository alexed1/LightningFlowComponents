import {LightningElement, api, track, wire} from 'lwc';
import {getObjectInfo} from 'lightning/uiObjectInfoApi';
import getObjects from '@salesforce/apex/FieldPickerController.getObjects';

export default class soqlQueryBuilder extends LightningElement {
    @track _objectType = 'Account';
    @track fields = [];
    @track whereClause;
    @track orderByField;
    @track orderByDirection;
    @track limit;
    @track _objectTypes;
    @track _soqlQuery;
    @track _selectedFields = [];

    fieldOptions = [];
    labels = {
        chooseFields: 'Choose the query fields below.',
        generatedQuery: 'The generated query will appear below. You may edit it before finishing.',
        whereClauses: 'Create the where clauses to your query below',
        orderBy: 'Order the number of results by:'
    };

    orderByDirections = [{label: 'ASC', value: 'ASC'}, {label: 'DESC', value: 'DESC'}];

    get soqlQuery() {
        return this._soqlQuery;
    }

    @api
    set soqlQuery(value) {
        this._soqlQuery = value;
        this.parseQuery(value);
    }

    parseQuery(value) {
        this._soqlQuery = value;
        this.setSelectedFields(value);
        this.setObjectTypeByQuery(value);
        this.setOrderBy(value);
        this.setLimit(value);
    }

    get fieldOptionsWithNone() {
        return [...[{label: '--NONE--', value: ''}], ...this.fieldOptions];
    }

    prepareFieldDescriptors() {
        if (this.fieldOptions && this.fieldOptions.length) {
            this.fields = this.fieldOptions.map(curField => {
                return {
                    ...curField, ...{
                        selected: this._selectedFields.includes(curField.value)
                    }
                };
            });
        } else {
            this.fields = [];
        }
    }

    buildQuery() {
        if (this._objectType && this._selectedFields && this._selectedFields.length) {
            let resultQuery = 'SELECT ' + this._selectedFields.join(', ') + ' FROM ' + this._objectType;
            if (this.whereClause) {
                resultQuery += this.whereClause;
            }
            if (this.orderByField && this.orderByDirection) {
                resultQuery += ' ORDER BY ' + this.orderByField + ' ' + this.orderByDirection;
            }
            if (this.limit) {
                resultQuery += ' LIMIT ' + this.limit;
            }
            this._soqlQuery = resultQuery;
        }
    }

    clearSelectedValues() {
        this._selectedFields = [];
    }

    handleConditionChanged(event) {
        this.whereClause = event.detail.whereClause;
        this.buildQuery();
    }

    handleObjectTypeChange(event) {
        this._objectType = event.detail.value;
        this.clearSelectedValues();
    }

    handleSoqlChange(event) {
        this.parseQuery(event.detail.value);
    }

    handleFieldSelected(event) {
        // this.notifyAssignee = event.target.checked === true;
        this._selectedFields = this.toggle(this._selectedFields, event.target.name);
        this.prepareFieldDescriptors();
        this.buildQuery();
    }

    @wire(getObjects, {})
    _getObjects({error, data}) {
        if (error) {
            console.log(error.body.message);
        } else if (data) {
            this._objectTypes = data;
        }
    }

    @wire(getObjectInfo, {objectApiName: '$_objectType'})
    _getObjectInfo({error, data}) {
        if (error) {
            console.log(error.body[0].message);
        } else if (data) {
            this.fieldOptions = Object.keys(data.fields).map(curFieldName => {
                let curField = data.fields[curFieldName];
                return {label: curField.label, value: curField.apiName, dataType: curField.dataType}
            });
            this.prepareFieldDescriptors();
        }
    }

    setOrderBy(value) {
        //TODO: determine by query
        // this.orderByDirection;
        // this.orderByField
    }

    setSelectedFields(query) {
        //TODO: determine by query 'SELECT 'Id', 'Name' FROM Account '
        // this._selectedFields = ['Id', 'Name'];
        this.prepareFieldDescriptors();
    }

    setObjectTypeByQuery(query) {
        //TODO: determine by query 'SELECT Id FROM `Account` '
        // this._objectType = 'Account';
    }

    setLimit(query) {
        //TODO: determine by query 'SELECT Id FROM `Account` LIMIT 1'
        // this.limit = 1;
    }

    toggle(array, element) {
        if (array && element) {
            if (array.includes(element)) {
                return array.filter(curElement => curElement != element);
            } else {
                array.push(element);
                return array;
            }
        } else {
            return array;
        }
    }

    handleValueChanged(event) {
        let inputName = event.target.name;
        this[inputName] = event.detail.value;
        this.buildQuery();
    }
}
