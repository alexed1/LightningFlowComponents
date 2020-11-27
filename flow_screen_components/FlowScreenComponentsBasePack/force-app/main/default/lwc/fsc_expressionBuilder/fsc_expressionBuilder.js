import {LightningElement, track, api, wire} from 'lwc';
import {FlowAttributeChangeEvent} from 'lightning/flowSupport';
//import conditionLogicHelpText from '@salesforce/label/c.ConditionLogicHelpText';
import assembleFormulaString from '@salesforce/apex/usf.ExpressionBuilder.assembleFormulaString';
import disassemblyFormulaString from '@salesforce/apex/usf.ExpressionBuilder.disassemblyFormulaString';
import describeSObjects from '@salesforce/apex/usf.SearchUtils.describeSObjects';

export default class fsc_ExpressionBuilder extends LightningElement {
    @api name;
    @api addButtonLabel = 'Add Condition';
    @api dispatchComponentChangeEvents = false;
    @api customVariableDelimiter;
    @track objectName;
    @track expressionLines = [];
    @track customLogic = '';
    @track logicType = 'AND';
    @track convertedExpression;
    @track contextFields = [];
    @track contextTypes = [];
    @track isLoading = true;

    @api customMergeFields = [];

    @api
    get formulaString() {
        return this.convertedExpression;
    }

    set formulaString(value) {
        this.convertedExpression = value;
    }

    @api
    get contextObjectType() {
        return this._objectName;
    }

    set contextObjectType(value) {
        this._objectName = value;
        if (!this.contextTypes || this.contextTypes.length === 0) {
            this.contextTypes = [value];
        }
    }

    @api //f.e. 'User,Organization,Profile'
    get supportedSystemTypes() {
        return this.contextTypes.filter(curObject => curObject !== this._objectName).join(',');
    }

    set supportedSystemTypes(value) {
        this.contextTypes = [...[this._objectName], ...this.splitValues(value)];
    }

    settings = {
        valueTypeString: 'string',
        invalidCharactersRegex: /['"\\\/|&^]/g
    }

    @wire(describeSObjects, {types: '$contextTypes'})
    _describeSObjects(result) {
        if (result.error) {
            console.log(result.error.body);
        } else if (result.data) {
            this.contextTypes.forEach(objType => {
                let newContextFields = result.data[objType].map(curField => {
                    return {
                        ...curField, ...{
                            label: objType + ': ' + curField.label,
                            value: '$' + curField.type + '.' + curField.value
                        }
                    }
                });

                if (this.contextFields && this.contextFields.length > 0) {
                    this.contextFields = this.contextFields.concat(newContextFields);
                } else {
                    this.contextFields = newContextFields;
                }
            });

            if (this.customMergeFields && this.customMergeFields.length) {
                this.contextFields = this.contextFields.concat(this.customMergeFields);
            }

            if (this.contextFields && this.contextFields.length > 0) {
                this.doDisassemblyFormulaString();
            } else {
                this.isLoading = false;
            }
        }
    }

    lastExpressionIndex = 0;
    logicTypes = [
        {value: 'AND', label: 'All Conditions Are Met'},
        {value: 'OR', label: 'Any Condition Is Met'}
        // {value: 'CUSTOM', label: 'Custom Condition Logic Is Met'}
    ];
    conditionLogicHelpText = 'placeholder for conditionLogicHelpTest' //conditionLogicHelpText;

    doDisassemblyFormulaString() {
        disassemblyFormulaString({
            expression: this.convertedExpression,
            customVariableDelimiter: this.customVariableDelimiter
        }).then(result => {
            if (result.logicType !== undefined) {
                this.logicType = result.logicType;
            }
            if (result.customLogic !== undefined) {
                this.customLogic = result.customLogic;
            }
            if (result.expressionLines !== undefined) {
                let expressionLines = [];
                result.expressionLines.forEach((line, index) => {
                    let fieldData = this.contextFields.find(curField => curField.value === line.fieldName);
                    expressionLines.push({
                        ...this.generateNewExpression(), ...{
                            fieldName: line.fieldName,
                            id: index,
                            objectType: line.objectType,
                            operator: line.operator,
                            parameter: line.parameter,
                            renderType: fieldData ? fieldData.renderType : 'text',
                            dataType: fieldData ? fieldData.dataType : null
                        }
                    });
                    this.lastExpressionIndex = index + 1
                });
                this.expressionLines = expressionLines;
            }

        }).finally(() => {
            this.isLoading = false;
        });
    }

    generateNewExpression() {
        return {
            id: this.lastExpressionIndex++,
            objectType: this.contextObjectType,
            parameter: ''
        };
    }

    handleAddExpression() {
        this.expressionLines.push(this.generateNewExpression());
    }

    get showCustomLogicInput() {
        return this.logicType === 'CUSTOM';
    }

    handleCustomLogicChange(event) {
        this.customLogic = event.detail.value;
        this.assembleFormula();
    }

    handleWhenToExecuteChange(event) {
        this.logicType = event.detail.value;
        this.assembleFormula();
    }

    handleExpressionChange(event) {
        let expressionToModify = this.expressionLines.find(curExp => curExp.id === event.detail.id);

        for (let detailKey in event.detail) {
            if (Object.prototype.hasOwnProperty.call(event.detail, detailKey)) {
                expressionToModify[detailKey] = event.detail[detailKey];
            }
        }
        if (event.detail.isInit !== true && this.isExpressionValid(expressionToModify)) {
            this.assembleFormula();
        }
    }

    isExpressionValid(expression) {
        let isParameterValid = true;
        if (expression.renderType === this.settings.valueTypeString) {
            isParameterValid = !expression.parameter || !expression.parameter.match(this.settings.invalidCharactersRegex)
        }
        return !!(expression.fieldName && expression.operator && expression.parameter && isParameterValid);
    }

    handleRemoveExpression(event) {
        this.expressionLines = this.expressionLines.filter(curExp => curExp.id !== event.detail);
        this.assembleFormula();
    }

    assembleFormula() {
        if ((this.logicType === 'CUSTOM' && this.customLogic.length > 0) || this.logicType !== 'CUSTOM') {
            assembleFormulaString({
                customLogic: this.customLogic.toUpperCase(),
                logicType: this.logicType,
                expressionLines: JSON.stringify(this.expressionLines)
            }).then(result => {
                this.convertedExpression = result
                if (this.dispatchComponentChangeEvents) {
                    this.dispatchValueChangedEvent();
                } else {
                    this.dispatchFlowValueChangedEvent();
                }
            })
        } else {
            this.convertedExpression = ''
            this.dispatchFlowValueChangedEvent();
        }
    }

    dispatchValueChangedEvent() {
        const memberRefreshedEvt = new CustomEvent('expressionchanged', {
            bubbles: true,
            detail: {
                name: this.name,
                value: this.convertedExpression
            }
        });
        this.dispatchEvent(memberRefreshedEvt);
    }

    dispatchFlowValueChangedEvent() {
        const valueChangeEvent = new FlowAttributeChangeEvent('value', this.convertedExpression);
        this.dispatchEvent(valueChangeEvent);
    }

    get disabledAddButton() {
        return this.expressionLines.length > 9;
    }

    splitValues(originalString) {
        return originalString ? originalString.replace(/ /g, '').split(',') : [];
    }

    @api
    getFormulaString() {
        return this.convertedExpression;
    }

    @api
    validate() {
        let validity = {
            isValid: true
        };
        let inputsToVerify = this.template.querySelectorAll('c-fsc-expression-line');
        if (inputsToVerify && inputsToVerify.length) {
            inputsToVerify.forEach(curInput => {
                let reportedValidity = curInput.validate();
                if (!reportedValidity || !reportedValidity.isValid) {
                    validity = reportedValidity;
                    return reportedValidity;
                }
            })
        }
        return validity;
    }
}