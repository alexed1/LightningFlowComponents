import {LightningElement, api} from 'lwc';

export default class ConditionLine extends LightningElement {
    @api allOperations;
    @api allFields;
    @api fieldName;
    @api fieldType;
    @api operation;
    @api value;
    @api lineId;
    @api index;
    @api fieldTypeSettings;

    get inputType() {
        if (this.fieldType && this.fieldTypeSettings[this.fieldType]) {
            return this.fieldTypeSettings[this.fieldType].inputType;
        }
    }

    get availableOperations() {
        if (this.allOperations) {
            return this.allOperations.filter(curOperation => {
                return curOperation.types.includes(this.fieldType);
            });
        }

    }

    get conditionIndex() {
        return this.index + 1;
    }

    get isDisabled() {
        return !this.fieldName;
    }

    get valueVariant() {
        return (this.fieldType === 'Date' || this.fieldType === 'DateTime') ? 'label-hidden' : 'label-stacked';
    }

    handleConditionChanged(event) {
        let inputName = event.target.name;
        this[inputName] = (this.fieldType === 'Boolean' && inputName === 'value') ? event.target.checked : event.target.value;
        this.dispatchConditionChangedEvent();
    }

    handleConditionRemove(event) {
        const filterChangedEvent = new CustomEvent('conditionremoved', {
            detail: {
                id: this.lineId
            }
        });
        this.dispatchEvent(filterChangedEvent);
    }

    get fieldNameClass() {
        if(!this.fieldType){
            return 'slds-has-error';
        }
    }

    get valueClass() {
        if(this.fieldType && !this.value){
            return 'slds-has-error';
        }
    }

    dispatchConditionChangedEvent() {
        const filterChangedEvent = new CustomEvent('conditionchanged', {
            detail: {
                fieldName: this.fieldName,
                operation: this.operation,
                value: this.value,
                id: this.lineId
            }
        });
        this.dispatchEvent(filterChangedEvent);
    }
}