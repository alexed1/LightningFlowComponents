import { LightningElement, api, track } from 'lwc';
import { FlowAttributeChangeEvent } from 'lightning/flowSupport';

export default class TextAreaPlus extends LightningElement {
    // Component facing props
    @track textValue;
    @track maxLength;

    // Flow inputs  
    @api label;
    @api placeHolder;
    @api set maxlen(val) {
        this.maxLength = val;
    }
    get maxlen() {
        return this.maxLength;
    }

    @api set value(val) {
        this.textValue = val;
    }
    get value() {
        return this.textValue;
    }

    @api validate() {
        if (Number(this.maxLength) >= 0) {
            return { isValid: true};
        } else {
            return { isValid: false};
        }
    }

    // Dynamic properties
    get charsLeft() {
        return this.maxLength - (this.textValue?.length >= 0 ? this.textValue.length : 0);
    }

    get labelCss() {
        return `slds-var-p-top_xxx-small slds-var-p-left_x-small ${this.charsLeft > 0 ? 'default' : 'warning'}`;
    }
    
    // Event handler
    handleChange({detail}) {
        this.textValue = detail.value;
        // required for Flow
        const attributeChangeEvent = new FlowAttributeChangeEvent('value', this.textValue);
        this.dispatchEvent(attributeChangeEvent);
    }
}