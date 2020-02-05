import {LightningElement, api, track} from 'lwc';

export default class ConditionBuilder extends LightningElement {
    @track outputType = 'query'; //query/formula
    @track _fields;
    @track _conditions = [];
    @track logicType;
    @track customLogic;
    @track _whereClause;
    logicTypes = [
        {label: 'AND', value: 'AND'},
        {label: 'OR', value: 'OR'},
        {label: 'CUSTOM', value: 'custom'}
    ];
    operations = [
        {
            label: 'equals',
            value: ' = ',
            types: 'String,Picklist,Url,Email,TextArea,Reference,Phone,Date,DateTime,Currency,Double,Boolean,Int,Address'
        },
        {
            label: 'not equals',
            value: ' != ',
            types: 'String,Picklist,Url,Email,TextArea,Reference,Phone,Date,DateTime,Currency,Double,Boolean,Int,Address'
        },
        {label: 'less than', value: ' < ', types: 'Date,DateTime,Currency,Double,Int,Address'},
        {label: 'greater than', value: ' > ', types: 'Date,DateTime,Currency,Double,Int,Address'},
        {label: 'less than or equals', value: ' <= ', types: 'Date,DateTime,Currency,Double,Int,Address'},
        {label: 'greater than or equals', value: ' >= ', types: 'Phone,Date,DateTime,Currency,Double,Int,Address'},
        {label: 'IN',value: ' IN ',types: 'String,Picklist,Url,Email,Reference,Phone,Date,DateTime,Currency,Double,Int,Address'},
        {label: 'LIKE',value: ' LIKE ', types: 'String,Picklist,Url,Email,Reference,Phone'},
        {label: 'NOT IN',value: ' NOT IN ',types: 'String,Picklist,Url,Email,Reference,Phone,Date,DateTime,Currency,Double,Boolean,Int,Address'}
    ];

    fieldTypeSettings = {
        String: {inputType: 'text', dataTransformationFunction: 'wrapInQuotes'},
        Picklist: {inputType: 'text', dataTransformationFunction: 'wrapInQuotes'},
        Email: {inputType: 'text', dataTransformationFunction: 'wrapInQuotes'},
        Currency: {inputType: 'number', dataTransformationFunction: null},
        Address: {inputType: null, dataTransformationFunction: null},
        Double: {inputType: 'number', dataTransformationFunction: null},
        TextArea: {inputType: 'text', dataTransformationFunction: 'wrapInQuotes'},
        Reference: {inputType: 'text', dataTransformationFunction: 'wrapInQuotes'},
        DateTime: {inputType: 'datetime', dataTransformationFunction: null},
        Phone: {inputType: 'text', dataTransformationFunction: 'wrapInQuotes'},
        Boolean: {inputType: 'toggle', dataTransformationFunction: null},
        Date: {inputType: 'date', dataTransformationFunction: null},
        Int: {inputType: 'number', dataTransformationFunction: null},
        Url: {inputType: 'url', dataTransformationFunction: 'wrapInQuotes'}
    };

    @api get whereClause() {
        return this._whereClause;
    }

    set whereClause(value) {
        this._whereClause = value; //original clause
        this.determineLogicType();
        this.parseWhereClause(value);
    }

    determineLogicType() {
        if (!this._whereClause) {
            this.logicType = 'AND';
        }
    }

    parseWhereClause(value) {
        //TODO: generate conditions and custom logic based on input query
    }

    get renderCustomLogicInput() {
        return this.logicType === 'custom';
    }

    handleValueChanged(event) {
        let inputName = event.target.name;
        this[inputName] = event.detail.value;
        if (event.currentTarget.dataset.dispatchValueChangedEvent) {
            this.dispatchConditionsChangedEvent();
        }
    }

    @api get fields() {
        return this._conditions;
    }

    set fields(value) {
        this._fields = this.copyValue(value);
    }

    conditionKey = 0;

    handleAddCondition(event) {
        if (!this._conditions) {
            this._conditions = [];
        }
        let newCondition = this.generateEmptyCondition();
        this._conditions.push(newCondition);
    }

    handleConditionChanged(event) {
        let newCondition = event.detail;
        let changedCondition = this._conditions.find(curCondition => curCondition.key === newCondition.id);
        if (changedCondition) {
            changedCondition.fieldName = newCondition.fieldName;
            changedCondition.operation = newCondition.operation;
            changedCondition.value = newCondition.value;
            let fieldDescriptor = this._fields.find(curField => curField.value === newCondition.fieldName);
            if (fieldDescriptor) {
                changedCondition.dataType = fieldDescriptor.dataType;
            }
            this.dispatchConditionsChangedEvent();
        }
    }

    constructWhereClause() {
        let whereClause = '';
        let completeConditions = this._conditions.filter(curCondition => curCondition.fieldName && curCondition.operation && curCondition.value);
        if (completeConditions && completeConditions.length) {
            whereClause += ' WHERE ';
            if (this.logicType === 'custom') {
                whereClause += this.customLogic ? this.customLogic : '';
                for (let i = 0; i < completeConditions.length; i++) {
                    const regex = new RegExp('' + (i + 1), 'gi');
                    whereClause = whereClause.replace(regex, this.buildCondition(completeConditions[i]))
                }
            } else {
                whereClause += completeConditions.map(curCompleteCondition => {
                    return this.buildCondition(curCompleteCondition);
                }).join(' ' + this.logicType + ' ');
            }
        }
        return whereClause;
    }

    buildCondition(completeCondition) {
        return ' ' + completeCondition.fieldName + completeCondition.operation + this.getConditionValue(completeCondition) + ' ';
    }

    getConditionValue(condition) {
        if (condition.dataType && this.fieldTypeSettings[condition.dataType]) {
            let fieldTypeSetting = this.fieldTypeSettings[condition.dataType];
            if (fieldTypeSetting.dataTransformationFunction) {
                return this[fieldTypeSetting.dataTransformationFunction](condition.value);
            }
        }
        return condition.value;
    }

    wrapInQuotes(value) {
        return '\'' + value + '\'';
    }

    dispatchConditionsChangedEvent() {
        const filterChangedEvent = new CustomEvent('conditionschanged', {
            detail: {
                whereClause: this.constructWhereClause()
            }
        });
        this.dispatchEvent(filterChangedEvent);
    }

    generateEmptyCondition() {
        return {
            fieldName: null,
            operation: null,
            value: null,
            dataType: null,
            key: 'whereCondition' + this.conditionKey++
        }
    }

    copyValue(value) {
        if (value) {
            return JSON.parse(JSON.stringify(value));
        } else {
            return value;
        }
    }
}