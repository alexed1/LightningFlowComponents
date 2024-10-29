import { LightningElement, api } from 'lwc';
import * as InvocableCheckLimitMapping from './invocableCheckLimitMapping';

export default class invocableCheckLimitCpe extends LightningElement {
    @api builderContext;
    @api inputVariables;
    
    value = '';
    description = '';

    get options() {
        return InvocableCheckLimitMapping.fieldMapping();
    }

    connectedCallback() {
        // Initialize the value based on the inputVariables
        const limitNameVariable = this.inputVariables.find(
            variable => variable.name === 'limitName'
        );
        if (limitNameVariable) {
            this.value = limitNameVariable.value;
        }
        // Set the description based on the selected picklist value
        this.setDescription(this.value);
    }

    handleChange(event) {
        this.value = event.detail.value;
        this.dispatchFlowValueChangeEvent(this.value);
        // Update the description based on the selected picklist value
        this.setDescription(this.value);
    }

    setDescription(selectedValue) {
        // Find the description for the selected value
        const selectedOption = this.options.find(option => option.value === selectedValue);
        this.description = selectedOption ? selectedOption.description : '';
    }

    dispatchFlowValueChangeEvent(newValue) {
        const valueChangedEvent = new CustomEvent('configuration_editor_input_value_changed', {
            bubbles: true,
            cancelable: false,
            composed: true,
            detail: {
                name: 'limitName',
                newValue: newValue,
                newValueDataType: 'String'
            }
        });
        this.dispatchEvent(valueChangedEvent);
    }
}