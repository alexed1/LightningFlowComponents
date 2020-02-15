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
    @track fieldPickerStyle = 'height: 14rem;';
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
        if (value.indexOf(" FROM ") !== -1) {
            let objectName = value.substring(value.indexOf(" FROM ") + 6, value.indexOf(" WHERE "));
            this._objectType = objectName;
        } else {
            this._objectType = null;
        }

        if (value.indexOf("SELECT ") !== -1) {
            let selectedFields = value.substring(value.indexOf("SELECT ") + 7, value.indexOf(" FROM "));
            this._selectedFields = selectedFields.split(',').map(curField => curField.trim());

        } else {
            this._selectedFields = [];
        }

        let orderByIndex = value.indexOf(" ORDER BY ");
        let limitIndex = value.indexOf(" LIMIT ");
        if (value.indexOf(" WHERE ") !== -1) {
            this.whereClause = value.substring(value.indexOf(" WHERE ") + 7, Math.min(orderByIndex === -1 ? value.length : orderByIndex, limitIndex === -1 ? value.length : limitIndex, value.length) - 1);
        } else {
            this.whereClause = null;
        }

        if (orderByIndex) {
            let orderByClause = value.substring(orderByIndex + 10);
            let orderByParts = orderByClause.split(' ');
            this.orderByField = orderByParts[0];
            this.orderByDirection = orderByParts.length > 1 ? (orderByParts[1] === 'ASC' || orderByParts[1] === 'DESC' ? orderByParts[1] : null) : null;
        } else {
            this.orderByField = null;
            this.orderByDirection = null;
        }

        if (limitIndex !== -1) {
            let limit = value.substring(limitIndex + 7);
            this.limit = limit;
        } else {
            this.limit = null;
        }

        this.prepareFieldDescriptors();
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
                resultQuery += ' WHERE ' + this.whereClause;
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
        this.whereClause = '';
        this._soqlQuery = '';
        this.limit = null;
        this.orderByField = null;
        this.orderByDirection = null;
        let conditionBuilder = this.template.querySelector('c-condition-builder');
        if (conditionBuilder) {
            conditionBuilder.clearConditions();
        }
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
        this.parseQuery(event.target.value);
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

    calculateFieldPickerStyle() {
        let fieldPickerContainer = this.template.querySelector('.field-picker-container');
        if (fieldPickerContainer) {
            let fullHeight = fieldPickerContainer.offsetHeight;
            this.fieldPickerStyle = 'height: ' + (fullHeight - 50) + 'px';
        }
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
