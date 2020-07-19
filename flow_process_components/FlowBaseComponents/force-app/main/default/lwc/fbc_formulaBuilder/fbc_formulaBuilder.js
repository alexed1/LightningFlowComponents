import {LightningElement, track, api, wire} from 'lwc';
import {FlowAttributeChangeEvent} from 'lightning/flowSupport';
import describeSObjects from '@salesforce/apex/fbc_SearchUtils.describeSObjects';


export default class FormulaBuilder extends LightningElement {

    @api functions;
    @api operators;
    @api supportedSystemTypes;
    @api contextDataString;

    @track formula = '';
    @track _objectName;
    @track contextFields = [];
    @track contextTypes;

    @track functionValue = null;

    @api get contextObjectType() {
        return this._objectName;
    }

    set contextObjectType(value) {
        this._objectName = value;
        if (value) {
            this.contextTypes = [...[value], ...this.supportedSystemTypes ? this.splitValues(this.supportedSystemTypes) : []];
        }
    }

    @api supportedFunctions = [
        'AND', 'OR', 'NOT', 'XOR', 'IF', 'CASE', 'LEN', 'SUBSTRING', 'LEFT', 'RIGHT',
        'ISBLANK', 'ISPICKVAL', 'CONVERTID', 'ABS', 'ROUND', 'CEILING', 'FLOOR', 'SQRT', 'ACOS',
        'ASIN', 'ATAN', 'COS', 'SIN', 'TAN', 'COSH', 'SINH', 'TANH', 'EXP', 'LOG', 'LOG10', 'RINT',
        'SIGNUM', 'INTEGER', 'POW', 'MAX', 'MIN', 'MOD', 'TEXT', 'DATETIME', 'DECIMAL', 'BOOLEAN',
        'DATE', 'DAY', 'MONTH', 'YEAR', 'HOURS', 'MINUTES', 'SECONDS', 'ADDDAYS', 'ADDMONTHS',
        'ADDYEARS', 'ADDHOURS', 'ADDMINUTES', 'ADDSECONDS', 'CONTAINS', 'FIND', 'LOWER', 'UPPER'
        , 'MID', 'SUBSTITUTE', 'TRIM', 'VALUE', 'CONCATENATE', 'TODAY=>$TODAY', 'WEEKDAY', 'BEGINS'
    ];

    @api supportedOperators = ['+', '-', '/', '*', '==', '!=', '>', '<', '>=', '<=', '<>'];

    @api
    get formulaString() {
        return this.formula;
    }

    set formulaString(value) {
        this.formula = value;
    }

    @wire(describeSObjects, {types: '$contextTypes'})
    _describeSObjects(result) {
        if (result.error) {
            console.log(result.error.body.message);
            // this.errors.push(error.body[0].message);
        } else if (result.data) {
            this.contextTypes.forEach(objType => {

                let newContextFields = result.data[objType].map(curField => {
                    return {label: objType + ': ' + curField.label, value: '$' + objType + '.' + curField.value}
                });

                if (this.contextFields) {
                    this.contextFields = this.contextFields.concat(newContextFields);
                } else {
                    this.contextFields = newContextFields;
                }

            });
            if (this.contextDataString) {
                let contextDataObj = JSON.parse(this.contextDataString);
                contextDataObj.forEach(curEl => {
                    this.contextFields.push({label: 'Context Data: ' + curEl.name, value: curEl.value});
                })
            }
        }
    }

    formulaChangedEvent() {
        const memberRefreshedEvt = new CustomEvent('formulachanged', {
            bubbles: true, detail: {
                value: this.formula
            }
        });
        this.dispatchEvent(memberRefreshedEvt);
    }

    dispatchFormulaChangedEvents() {
        this.formulaChangedFlowEvent();
        this.formulaChangedEvent();
    }

    setFunctions() {
        let functions = [];
        this.supportedFunctions.sort((a, b) => (a > b) ? 1 : ((b > a) ? -1 : 0)).forEach(func => {
            let funcParts = func.split('=>');
            functions.push({label: funcParts[0], value: funcParts.length == 1 ? funcParts[0] + '()' : funcParts[1]});
        });
        this.functions = functions;
    }

    connectedCallback() {

        this.setFunctions();
        let operators = [];

        this.supportedOperators.forEach(operator => {
            operators.push({label: operator, value: operator});
        });

        this.operators = operators;

    }

    formulaChangedFlowEvent(event) {
        const valueChangeEvent = new FlowAttributeChangeEvent('value', this.formula);
        this.dispatchEvent(valueChangeEvent);
    }

    insertInCurrentPosition(value, setCursor) {
        let formulaTextArea = this.template.querySelector('.slds-textarea');
        if (formulaTextArea) {
            if (value !== '') {
                let formulaStart = this.formula.substring(0, formulaTextArea.selectionStart) + ' ' + value + ' ';
                let newFormulaString = formulaStart + this.formula.substring(formulaTextArea.selectionEnd);
                this.formula = newFormulaString;
                formulaTextArea.value = newFormulaString;
                if (setCursor) {
                    formulaTextArea.focus();
                    formulaTextArea.selectionEnd = formulaStart.length - 2;
                }
                this.dispatchFormulaChangedEvents();
            }
        }

    }

    selectOperator(event) {
        this.insertInCurrentPosition(event.detail.value);
        this.clearSelections();
    }

    selectFunction(event) {
        this.insertInCurrentPosition(event.detail.value, true);
        this.clearSelections();
    }

    clearSelections() {
        this.template.querySelectorAll('lightning-combobox').forEach(curComboBox => {
            curComboBox.value = null;
        });
    }

    changeFormula(event) {
        this.formula = event.target.value;
        this.dispatchFormulaChangedEvents();
    }

    selectField(event) {
        this.insertInCurrentPosition(event.detail.value, false);
        this.clearSelections();
    }

    splitValues(originalString) {
        return originalString ? originalString.replace(/ /g, '').split(',') : [];
    }
}