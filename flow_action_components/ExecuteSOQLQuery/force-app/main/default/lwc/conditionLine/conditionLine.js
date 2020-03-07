import {LightningElement, api} from 'lwc';

export default class ConditionLine extends LightningElement {
    @api allOperations;
    @api allFields;
    @api fieldName;
    @api objectType;
    _fieldType;
    @api operation;
    @api value;
    @api lineId;
    @api index;
    @api conditionCount;
    @api fieldTypeSettings;
    @api preventErrors;
    @api disabled;
    @api get fieldType() {
        return this._fieldType;
    }

    set fieldType(value) {
        this._fieldType = value;
    }

    get inputType() {
        if (this._fieldType && this.fieldTypeSettings[this._fieldType]) {
            return this.fieldTypeSettings[this._fieldType].inputType;
        }
    }

    get availableOperations() {
        if (this.allOperations) {
            return this.allOperations.filter(curOperation => {
                if (this._fieldType) {
                    return curOperation.types.includes(this._fieldType);
                } else {
                    return false;
                }

            });
        }

    }

    get conditionIndex() {
        return this.index + 1;
    }

    get isDisabled() {
        return (this.disabled || !this.fieldName);
    }

    get valueVariant() {
        return (this._fieldType === 'Date' || this._fieldType === 'DateTime') ? 'label-hidden' : 'label-stacked';
    }

    handleConditionChanged(event) {
        let inputName = event.target.name;
        this[inputName] = (this._fieldType === 'Boolean' && inputName === 'value') ? event.target.checked : event.target.value;
        this.dispatchConditionChangedEvent();
    }

    handleFieldChanged(event) {
        this.fieldName = event.detail.newValue;
        if (event.detail.displayType) {
            this._fieldType = event.detail.displayType;
        }
        if (!this.fieldName) {
            this.value = null;
            this._fieldType = null;
        }
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

    get valueClass() {
        let resultClass = '';
        if (this._fieldType === 'Date' || this._fieldType === 'DateTime') {
            resultClass += 'slds-p-top--large '
        }
        if (this._fieldType && !this.value) {
            resultClass += 'slds-has-error ';
        }
        return resultClass;
    }

    get preventRemoval() {
        return (this.conditionCount <= 1);
    }

    dispatchConditionChangedEvent() {
        const filterChangedEvent = new CustomEvent('conditionchanged', {
            detail: {
                fieldName: this.fieldName,
                dataType: this._fieldType,
                operation: this.operation,
                value: this.value,
                id: this.lineId
            }
        });
        this.dispatchEvent(filterChangedEvent);
    }
}