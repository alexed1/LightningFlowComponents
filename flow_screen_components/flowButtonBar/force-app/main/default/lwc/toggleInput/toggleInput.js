import { LightningElement, api } from 'lwc';

const VARIANTS = {
    UNSELECTED: 'neutral',
    SELECTED: 'brand'
}

export default class ToggleInput extends LightningElement {
    @api label;
    @api options;
    @api helpText;
    @api multiselect;
    @api required;
    @api errorMessage;

    @api 
    get values() {
        return this._values;
    }
    set values(values) {
        this._values = values ? [...values] : []; // using spread operator to create a shallow clone of the array for mutability
        if (this.rendered) {
            this.updateToggle();
        }
    }
    _values;

    @api
    get value() {
        return this.values[0] || null;
    }
    set value(value) {
        this.values = [value];
    }
    
    rendered;
    renderedCallback() {
        if (this.rendered) return;
        this.rendered = true;

        this.updateToggle();
    }

    handleToggleClick(event) {
        let clickedValue = event.target.value;
        let curIndex = this.values.findIndex(value => value === clickedValue);
        if (curIndex >= 0) {
            if (!this.required || this.values.length > 1)
                this.values.splice(curIndex, 1);
        } else {
            if (this.multiselect) {
                this.values.push(clickedValue);
            } else {
                this.value = clickedValue;
            }
        }
        this.dispatchEvent(new CustomEvent('togglechange', { 
            detail: { 
                value: this.value,
                values: this.values
            }
        }));
        this.updateToggle();
    }

    updateToggle() {
        for (let button of this.template.querySelectorAll('lightning-button')) {
            if (this.values.includes(button.value)) {
                button.variant = VARIANTS.SELECTED;
            } else {
                button.variant = VARIANTS.UNSELECTED;
            }
        }
    }

    /* No longer used
    handleToggleChange(event) {
        this.dispatchEvent(new CustomEvent('togglechange', { 
            detail: { 
                value: event.detail.value 
            }
        }));
    }
    */
}