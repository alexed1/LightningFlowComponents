import {LightningElement, api, track} from 'lwc';
import {
    copyValue
} from 'c/fieldSelectorUtils';

export default class ConditionBuilder extends LightningElement {
    @api isDisabled;
    @api objectType;
    @api disabled;
    @track outputType = 'query'; //query/formula
    @track _fields;
    @track _conditions = [];
    @track logicType = 'AND';
    @track customLogic;
    @track _whereClause;
    conditionKey = 0;
    logicTypes = [
        {label: 'All Conditions Are Met', value: 'AND'},
        {label: 'Any Condition Is Met', value: 'OR'},
        {label: 'Custom', value: 'custom'}
    ];
    operations = [
        {
            label: 'equals',
            value: ' = ',
            types: 'String,Picklist,Url,Email,TextArea,Reference,Phone,Date,DateTime,Currency,Double,Boolean,Int,Address,NestedField'
        },
        {
            label: 'not equals',
            value: ' != ',
            types: 'String,Picklist,Url,Email,TextArea,Reference,Phone,Date,DateTime,Currency,Double,Boolean,Int,Address,NestedField'
        },
        {label: 'less than', value: ' < ', types: 'Date,DateTime,Currency,Double,Int,Address,NestedField'},
        {label: 'greater than', value: ' > ', types: 'Date,DateTime,Currency,Double,Int,Address,NestedField'},
        {label: 'less than or equals', value: ' <= ', types: 'Date,DateTime,Currency,Double,Int,Address,NestedField'},
        {label: 'greater than or equals', value: ' >= ', types: 'Phone,Date,DateTime,Currency,Double,Int,Address,NestedField'},
        {label: 'LIKE', value: ' LIKE ', types: 'String,Picklist,Url,Email,Reference,Phone,NestedField'},
        {
            label: 'NOT IN',
            value: ' NOT IN ',
            types: 'String,Picklist,Url,Email,Reference,Phone,Date,DateTime,Currency,Double,Int,Address,NestedField'
        },
        {
            label: 'IN',
            value: ' IN ',
            types: 'String,Picklist,Url,Email,Reference,Phone,Date,DateTime,Currency,Double,Int,Address,NestedField'
        }
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
        Boolean: {inputType: 'checkbox', dataTransformationFunction: 'transformBoolean'},
        Date: {inputType: 'date', dataTransformationFunction: null},
        Int: {inputType: 'number', dataTransformationFunction: null},
        Url: {inputType: 'url', dataTransformationFunction: 'wrapInQuotes'}
    };

    @api get whereClause() {
        return this._whereClause;
    }

    set whereClause(value) {
        this._whereClause = value;
        if (this._fields && this._fields.length) {
            this.parseWhereClause(this._whereClause);
        }
    }

    @api get fields() {
        return this._conditions;
    }

    set fields(value) {
        this._fields = copyValue(value);
        if (this._whereClause) {
            this.parseWhereClause(this._whereClause);
        }

    }

    @api
    clearConditions() {
        this._conditions = [];
    }

    parseWhereClause(value) {
        if (value) {
            const matcher = new RegExp('(( ?(OR|AND) ?))(?!\\w)|([()])', 'gi');
            let matched = value.match(matcher);
            if (matched) {
                let customLogic = '';
                let index = '' + (matched[0].indexOf('(') === 0 ? 1 : 2);

                matched.forEach(curMatch => {
                    let trimmedMatch = curMatch.trim();
                    // customLogic += trimmedMatch === ')' ? index++ + curMatch : (trimmedMatch === '(' ? curMatch++ + index : curMatch);
                    customLogic += (trimmedMatch === ')' || trimmedMatch === '(') ? trimmedMatch : index++ + trimmedMatch + index++;
                });

                customLogic = customLogic.replace(new RegExp('\\d+\\(', 'gi'), '(');
                customLogic = customLogic.replace(new RegExp('\\)\\d+', 'gi'), ')');
                let matchedNumbers = customLogic.match(new RegExp('\\d+', 'gi'));

                for (let i = 0; i < matchedNumbers.length;) {
                    customLogic = customLogic.replace(matchedNumbers[i], ' ' + ++i + ' ');
                }
                this.customLogic = customLogic;
                if (this.logicType === 'custom' || (customLogic.indexOf('AND') !== -1 && customLogic.indexOf('OR') !== -1)) {
                    this.logicType = 'custom';
                } else if (customLogic.indexOf('OR') !== -1) {
                    this.logicType = 'OR';
                } else {
                    this.logicType = 'AND';
                }

            }
            let conditions = value.replace(new RegExp(' OR| AND|\\(|\\)', 'gi'), '|||').split('|||');
            this.parseConditions(conditions.filter(curCondition => {
                return curCondition.trim();
            }));
        }
    }

    parseConditions(conditions) {
        this._conditions = [];
        conditions.forEach(curCondition => {
            for (let i = 0; i < this.operations.length; i++) {
                let curLogicType = this.operations[i];
                if (curCondition.indexOf(curLogicType.value) !== -1) {
                    let conditionParts = curCondition.split(curLogicType.value);
                    let fieldDescriptor = this._fields.find(curField => curField.value === conditionParts[0].trim());
                    let newCondition = this.generateEmptyCondition();
                    newCondition.fieldName = conditionParts[0].trim();
                    newCondition.operation = curLogicType.value;
                    if (fieldDescriptor) {
                        if (this.fieldTypeSettings[fieldDescriptor.dataType]) {
                            newCondition.value = this.fieldTypeSettings[fieldDescriptor.dataType].dataTransformationFunction === 'wrapInQuotes' ? this.stripQuotes(conditionParts[1].trim()) : conditionParts[1].trim();
                        }
                        newCondition.dataType = fieldDescriptor.dataType;
                    } else {
                        //TODO: replace this with proper dataType handler
                        newCondition.value = this.stripQuotes(conditionParts[1].trim());
                        newCondition.dataType = 'NestedField';
                    }
                    this._conditions.push(newCondition);
                    break;
                }
            }
        });
    }

    get renderCustomLogicInput() {
        return this.logicType === 'custom';
    }

    handleValueChanged(event) {
        let inputName = event.target.name;
        this[inputName] = event.target.value;
        if (inputName === 'logicType' && this.logicType === 'custom') {

        } else {
            if (event.currentTarget.dataset.dispatchValueChangedEvent && this.isValid()) {
                this.dispatchConditionsChangedEvent();
            }
        }
    }

    isValid() {
        if (this.logicType === 'custom') {
            let customLogicInput = this.template.querySelector(".customLogic");
            let hasError = false;
            if (this.customLogic) {
                let matched = this.customLogic.match(new RegExp('\\d+', 'gi'), '(');
                if (!matched) {
                    hasError = true;
                }
                if (customLogicInput && !hasError) {
                    for (let i = 1; i <= this._conditions.length; i++) {
                        matched = matched.filter(curElement => curElement !== ('' + i));
                        if (!this.customLogic || !this.customLogic.includes(i)) {
                            hasError = true;
                            break;
                        }
                    }
                    if (matched.length) {
                        hasError = true;
                    }
                }
            } else {
                hasError = true;
            }
            if (hasError) {
                customLogicInput.setCustomValidity("Invalid custom conditions String");
            } else {
                customLogicInput.setCustomValidity('');
            }
            customLogicInput.reportValidity();
            return !hasError;
        }

        return true;
    }

    handleAddCondition(event) {
        this.addEmptyCondition();
    }

    @api
    addEmptyCondition(params) {
        if (!this._conditions) {
            this._conditions = [];
        }
        let newCondition = this.generateEmptyCondition();
        if (params) {
            newCondition = {...newCondition, ...params};
        }
        this._conditions.push(newCondition);
        if (this._conditions.length > 1) {
            this._conditions = this._conditions.map(curCondition => {
                curCondition.preventErrors = false;
                return curCondition;
            });
        }
        this.dispatchConditionAddedEvent(newCondition);
    }

    handleConditionChanged(event) {
        let newCondition = event.detail;
        let changedCondition = this._conditions.find(curCondition => curCondition.key === newCondition.id);
        if (changedCondition) {
            changedCondition.fieldName = newCondition.fieldName;
            changedCondition.operation = newCondition.operation ? newCondition.operation : ' = ';
            changedCondition.value = newCondition.value;
            let fieldDescriptor = this._fields.find(curField => curField.value === newCondition.fieldName);
            if (fieldDescriptor) {
                changedCondition.dataType = fieldDescriptor.dataType;
            } else {
                if (this._fields) {
                    this._fields.push({
                        value: newCondition.fieldName,
                        lable: newCondition.fieldName,
                        dataType: newCondition.dataType
                    });
                }
                changedCondition.dataType = newCondition.dataType;
            }
            this.dispatchConditionsChangedEvent();
        }
    }

    handleConditionRemoved(event) {
        let newCondition = event.detail;
        this._conditions = this._conditions.filter(curCondition => curCondition.key !== newCondition.id);
        this.dispatchConditionRemovedEvent();
        this.dispatchConditionsChangedEvent();
    }

    constructWhereClause() {
        let whereClause = '';
        // let completeConditions = this._conditions.filter(curCondition => curCondition.fieldName && curCondition.operation && this.isValidValue(curCondition));
        let completeConditions = this._conditions.filter(curCondition => curCondition.fieldName);
        if (completeConditions && completeConditions.length) {
            whereClause += ' ';
            if (this.logicType === 'custom') {
                let customLogicLocal = this.buildCustomLogic(this.customLogic);
                if (customLogicLocal) {
                    for (let i = 0; i < completeConditions.length; i++) {
                        const regex = new RegExp('\\$' + (i + 1) + '_', 'gi');
                        customLogicLocal = customLogicLocal.replace(regex, this.buildCondition(completeConditions[i]))
                    }
                }
                whereClause += customLogicLocal ? customLogicLocal : '';
            } else {
                whereClause += completeConditions.map(curCompleteCondition => {
                    return this.buildCondition(curCompleteCondition);
                }).join(' ' + this.logicType + ' ');
            }
        }
        return whereClause;
    }

    buildCustomLogic(customLogic) {
        if (customLogic) {
            const matcher = new RegExp('\\d+', 'gi');
            let matched = customLogic.match(matcher);
            if (matched) {
                matched.forEach(curMatch => {
                    customLogic = customLogic.replace(curMatch, '$' + curMatch + '_')
                });
            }
        }
        return customLogic;
    }

    isValidValue(condition) {
        if (condition.dataType === 'Boolean') {
            return true;
        } else {
            return condition.value
        }
    }

    buildCondition(completeCondition) {
        return ' ' + completeCondition.fieldName + (completeCondition.operation ? completeCondition.operation : '') + this.getConditionValue(completeCondition) + ' ';
    }

    getConditionValue(condition) {
        if (condition.value === null) {
            return '';
        }
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

    stripQuotes(value) {
        return value.replace(new RegExp('\'', 'gi'), '');
    }

    transformBoolean(value) {
        return !!value;
    }

    dispatchConditionAddedEvent(condition) {
        const filterChangedEvent = new CustomEvent('conditionadded', {
            detail: condition
        });
        this.dispatchEvent(filterChangedEvent);
    }

    dispatchConditionRemovedEvent(condition) {
        const filterChangedEvent = new CustomEvent('conditionremoved', {
            detail: condition
        });
        this.dispatchEvent(filterChangedEvent);
    }

    dispatchConditionsChangedEvent() {
        let incompleteConditions = this.getIncompleteConditions();
        if (incompleteConditions.length === 0 && this.isValid()) { //all condition are populated with valid values
            const filterChangedEvent = new CustomEvent('conditionschanged', {
                detail: {
                    whereClause: this.constructWhereClause(),
                    numberOfConditions: this._conditions ? this._conditions.length : 0
                }
            });
            this.dispatchEvent(filterChangedEvent);
        }
    }

    getIncompleteConditions() {
        if (this._conditions && this._conditions.length === 1 && !this._conditions[0].fieldName) {
            return [];
        } else {
            return this._conditions.filter(curCondition => !curCondition.fieldName || !curCondition.operation || !this.isValidValue(curCondition));
        }
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

    get parentClass() {
        if (this.isDisabled) {
            return 'slds-is-disabled';
        }
    }


    renderedCallback() {
        const renderfinishedEvent = new CustomEvent('renderfinished', {});
        this.dispatchEvent(renderfinishedEvent);
    }
}