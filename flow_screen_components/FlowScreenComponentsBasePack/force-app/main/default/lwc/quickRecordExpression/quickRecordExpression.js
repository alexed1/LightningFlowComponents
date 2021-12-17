import {LightningElement, api, track} from 'lwc';

export default class expressionLine extends LightningElement {
    @api field;


    @api objectType;
    @api operator = 'equals';
    @api value;
    @api renderType = 'text';
    @api expressionId;
    @api expressionIndex;
    @api availableMergeFields = [];
    @api disableRemoveExpression = false;

    @track allOperators = [
        {value: 'equals', label: 'Equals', types: 'ID,BOOLEAN,REFERENCE,STRING,EMAIL,PICKLIST,TEXTAREA,DATETIME,PHONE,DOUBLE,ADDRESS,INTEGER,URL'},
        {value: 'not_equal_to', label: 'Not Equal To', types: 'ID,BOOLEAN,REFERENCE,STRING,EMAIL,PICKLIST,TEXTAREA,DATETIME,PHONE,DOUBLE,ADDRESS,INTEGER,URL'},
        {value: 'greater_then', label: 'Greater than', types: 'DOUBLE,INTEGER,DATETIME'},
        {value: 'greater_or_equal', label: 'Greater Or Equal', types: 'DOUBLE,INTEGER,DATETIME'},
        {value: 'less_then', label: 'Less Than', types: 'DOUBLE,INTEGER,DATETIME'},
        {value: 'less_or_equal', label: 'Less Or Equal', types: 'DOUBLE,INTEGER,DATETIME'},
        {value: 'contains', label: 'Contains', types: 'ID,STRING,EMAIL,PICKLIST,TEXTAREA,PHONE,ADDRESS,URL'},
        {value: 'starts_with', label: 'Starts with', types: 'ID,STRING,EMAIL,PICKLIST,TEXTAREA,PHONE,ADDRESS,URL'},
        {value: 'end_with', label: 'End with', types: 'ID,STRING,EMAIL,PICKLIST,TEXTAREA,PHONE,ADDRESS,URL'}
    ];
    labels = {
        supportedCharactersRegex: '^[a-zA-Z0-9_,.\\- !]*$',
        unsupportedCharactersMessage: "Value contains unsupported characters."
    }
    @track filterValue = '';

    get availableOperators() {
        if (this.field) {
            return (this.allOperators.filter(curOperator => curOperator.types.includes("STRING")));
        } else {
            return [];
        }
    }

    get disabledFilter() {
        return !this.field;
    }
    
    handleOperatorChange(event) {
        this.operator = event.detail.value
        let customEvent = new CustomEvent('change', { detail: {operator: this.operator, value : this.value}});
        this.dispatchEvent(customEvent);
    }

    handleValueChange(event) {
        if(this.validate()){
            this.value = event.target.value;
            let customEvent = new CustomEvent('change', { detail: {operator: this.operator, value : this.value}});
            this.dispatchEvent(customEvent);
        }
    }

    @api
    validate() {
        let validity = {
            isValid: true
        };
        let inputsToVerify = this.template.querySelectorAll('lightning-input');
        if (inputsToVerify && inputsToVerify.length) {
            inputsToVerify.forEach(curInput => {
                let reportedValidity = curInput.reportValidity();
                if (!reportedValidity) {
                    validity.isValid = false;
                    validity.errorMessage = this.labels.unsupportedCharactersMessage;
                    return validity;
                }
            })
        }
        return validity;
    }
}