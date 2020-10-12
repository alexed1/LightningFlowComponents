import {LightningElement, api, track} from 'lwc';

export default class expressionLine extends LightningElement {

    @api objectType;
    @api operator;
    @api value;
    @api renderType = 'text';
    @api expressionId;
    @api expressionIndex;
    @api availableMergeFields = [];
    @track _fields = [];

    @track currentField;
    @track _fieldName;
    @track allOperators = [
        {
            value: 'equals',
            label: 'Equals',
            types: 'ID,BOOLEAN,REFERENCE,STRING,EMAIL,PICKLIST,TEXTAREA,DATETIME,PHONE,DOUBLE,ADDRESS,INTEGER,URL'
        },
        {
            value: 'not_equal_to',
            label: 'Not Equal To',
            types: 'ID,BOOLEAN,REFERENCE,STRING,EMAIL,PICKLIST,TEXTAREA,DATETIME,PHONE,DOUBLE,ADDRESS,INTEGER,URL'
        },
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

    @api
    get fields() {
        return this._fields;
    }

    set fields(value) {
        this._fields = value;
        this.setCurrentField();
    }


    @api
    get fieldName() {
        return this._fieldName;

    }

    set fieldName(value) {
        this._fieldName = value;
        this.setCurrentField();
    }

    get availableOperators() {
        if (this.currentField) {
            return this.allOperators.filter(curOperator => curOperator.types.includes(this.currentField.dataType.toUpperCase()));
        } else {
            return [];
        }
    }

    selectField(event) {
        let eventValue = event.detail.value;
        if (eventValue) {
            this._fieldName = eventValue;
            this.setCurrentField();
            this.dispatchChangeEvent({
                id: this.expressionId,
                fieldName: eventValue
            });
        }
    }

    setCurrentField() {
        if (this._fields && this._fields.length && this._fieldName) {
            if (!this.currentField || this.currentField.value !== this._fieldName) {
                this.currentField = this._fields.find(curField => curField.value === this._fieldName);
            }
        }
    }

    get disabledFilter() {
        return !this._fieldName;
    }

    handleOperatorChange(event) {
        this.dispatchChangeEvent({
            id: this.expressionId,
            operator: event.detail.value
        });
    }

    handleValueChange(event) {
        this.dispatchChangeEvent({
            id: this.expressionId,
            parameter: event.target.value
        });
    }

    dispatchChangeEvent(customParams) {
        const memberRefreshedEvt = new CustomEvent('fieldselected', {
            bubbles: true,
            detail: {...this.currentField, ...customParams}
        });
        this.dispatchEvent(memberRefreshedEvt);
    }

    handleExpressionRemove() {
        const expressionRemovedEvent = new CustomEvent('expressionremoved', {
            bubbles: true, detail: this.expressionId
        });
        this.dispatchEvent(expressionRemovedEvent);
    }

    get position() {
        return this.expressionIndex + 1;
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