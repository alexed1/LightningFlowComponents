import {LightningElement, api, track, wire} from 'lwc';
import {FlowAttributeChangeEvent} from 'lightning/flowSupport';
import {getObjectInfo} from 'lightning/uiObjectInfoApi';
import getObjects from '@salesforce/apex/FieldPickerController.getObjects';
import {
    standardObjectOptions
} from 'c/fieldSelectorUtils';

export default class soqlQueryBuilder extends LightningElement {
    @api label = "Create SOQL Query";
    @api disableObjectTypeSelection;
    @track _objectType;
    @track fields = [];
    @track whereClause;
    @track orderByField;
    @track orderByDirection;
    @track limit;
    @track _objectTypes = standardObjectOptions;
    @track _queryString;
    @track _selectedFields = [];
    @track fieldPickerStyle;
    isError;
    isConditionBuilderInitialized = false;
    errors = [];

    fieldOptions = [];
    labels = {
        chooseFields: 'Return which fields:',
        availableFields: 'Add fields',
        generatedQuery: 'Return Records meeting the following conditions:',
        whereClauses: 'Create the where clauses to your query below',
        orderBy: 'Order the number of results by:',
        incompatibleObject: 'The soql string that was passed in was incompatible with the provided object type name',
        lockObjectButNoSoqlNoObject: 'You need to either specify the object type, pass in an existing soql string, or allow the user to choose the object type',
        buttonRemoveAll: 'Remove All'
    };

    orderByDirections = [{label: 'ASC', value: 'ASC'}, {label: 'DESC', value: 'DESC'}];

    @api
    get objectType() {
        return this._objectType;
    }

    set objectType(value) {
        if (!this._objectType || !this.disableObjectTypeSelection) {
            this._objectType = value;
        } else if (this._objectType !== value && this.disableObjectTypeSelection) {
            this.errors.push(this.labels.incompatibleObject);
        }
    }

    @api
    get queryString() {
        return this._queryString;
    }

    set queryString(value) {
        this.parseQuery(value);
    }

    getNextKeywordIndex(query, indexes) {
        let validIndexes = indexes.filter(curIndex => curIndex !== -1);
        if (!validIndexes || !validIndexes.length) {
            return query.length;
        } else {
            return Math.min(...validIndexes);
        }
    }

    get errorMessage() {
        let errorResult = '';
        if (this.errors.length) {
            errorResult += this.errors.join('\n');
        }
        if (!this._objectType && !this._queryString && this.disableObjectTypeSelection) {
            errorResult += this.labels.lockObjectButNoSoqlNoObject;
        }
        return errorResult;
    }

    parseQuery(value) {
        this._queryString = value ? value : '';
        if (!value) {
            this.clearSelectedValues();
            this.addEmptyCondition();
            this.dispatchSoqlChangeEvent();
            return;
        }

        let selectIndex = value.indexOf("SELECT ");
        let fromIndex = value.indexOf(" FROM ");
        let whereIndex = value.indexOf(" WHERE ");
        let orderByIndex = value.indexOf(" ORDER BY ");
        let limitIndex = value.indexOf(" LIMIT ");

        if (fromIndex !== -1) {
            let objectName = value.substring(fromIndex + 6, this.getNextKeywordIndex(value, [whereIndex, orderByIndex, limitIndex]));
            if (objectName) {
                if (!this._objectType || !this.disableObjectTypeSelection) {
                    this._objectType = objectName.trim();
                } else if (this._objectType !== objectName.trim() && this.disableObjectTypeSelection) {
                    this.errors.push(this.labels.incompatibleObject);
                    return;
                }
            }
        }

        if (value.indexOf("SELECT ") !== -1) {
            let selectedFields = value.substring(selectIndex + 7, value.indexOf(" FROM "));
            this._selectedFields = selectedFields.split(',').map(curField => curField.trim());

        } else {
            this._selectedFields = [];
        }

        if (whereIndex !== -1) {
            this.whereClause = value.substring(whereIndex + 7, this.getNextKeywordIndex(value, [orderByIndex, limitIndex]));
        } else {
            this.whereClause = null;
            this.clearConditions();
            this.addEmptyCondition();
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
        this.dispatchSoqlChangeEvent();
    }

    get fieldOptionsWithNone() {
        return [...[{label: '--NONE--', value: ''}], ...this.fieldOptions];
    }

    get conditionBuilderDisabled() {
        return !this._objectType;
    }

    get conditionBuilderStyle() {
        return !this._objectType ? 'display: none' : '';
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
            this._queryString = resultQuery;
            this.dispatchSoqlChangeEvent();
        }
    }

    dispatchSoqlChangeEvent() {
        const attributeChangeEvent = new FlowAttributeChangeEvent('queryString', this._queryString);
        this.dispatchEvent(attributeChangeEvent);
    }

    clearSelectedValues() {
        this._selectedFields = [];
        this.whereClause = '';
        this._queryString = '';
        this.limit = null;
        this.orderByField = null;
        this.orderByDirection = null;
        this.clearConditions();
        this.dispatchSoqlChangeEvent();
    }

    clearConditions() {
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
        this.addEmptyCondition();
    }

    addEmptyCondition() {
        let conditionBuilder = this.template.querySelector('c-condition-builder');
        if (conditionBuilder) {
            conditionBuilder.addEmptyCondition({preventErrors: true});
        }
    }

    handleSoqlChange(event) {
        this.parseQuery(event.target.value);

    }

    handleFieldSelected(event) {
        // this.notifyAssignee = event.target.checked === true;
        this._selectedFields = this.toggle(this._selectedFields, event.detail.value, true);
        this.prepareFieldDescriptors();
        this.buildQuery();
    }

    handleRemoveAll(event) {
        this._selectedFields = [];
        this.prepareFieldDescriptors();
        this._queryString = '';
        this.buildQuery();
    }

    handleAddAll(event) {
        this._selectedFields = this.fieldOptions.map(curOption => curOption.value);
        this.prepareFieldDescriptors();
        this.buildQuery();
    }

    handleFieldRemove(event) {
        this._selectedFields = this.toggle(this._selectedFields, event.detail.value);
        if (!this._selectedFields || !this._selectedFields.length) {
            this._queryString = '';
        }
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
            }).sort((a, b) => (a.label > b.label) ? 1 : ((b.label > a.label) ? -1 : 0));
            this.prepareFieldDescriptors();
        }
    }

    calculateFieldPickerStyle() {
        if (!this.isConditionBuilderInitialized) {
            this.isConditionBuilderInitialized = true;
            if (!this.whereClause) {
                this.addEmptyCondition();
            }
        }

        let fieldPickerContainer = this.template.querySelector('.field-picker-container');
        if (fieldPickerContainer) {
            let fullHeight = fieldPickerContainer.offsetHeight;
            this.fieldPickerStyle = 'min-height: 120px; height: ' + (fullHeight - 50) + 'px';
        }
    }

    toggle(array, element, skipIfPersists) {
        if (array && element) {
            if (array.includes(element)) {
                if (skipIfPersists) {
                    this.flashSelectedField(element);
                    return array;
                } else {
                    return array.filter(curElement => curElement != element);
                }
            } else {
                array.push(element);
                return array;
            }
        } else {
            return array;
        }
    }

    flashSelectedField(fieldName) {
        let selectedFields = this.template.querySelector('c-selected-fields');
        if (selectedFields) {
            selectedFields.highlightField(fieldName);
        }
    }

    handleValueChanged(event) {
        let inputName = event.target.name;
        this[inputName] = event.detail.value;
        this.buildQuery();
    }

    get isRHSDisabled() {
        return (!this._selectedFields || !this._selectedFields.length);
    }
}
