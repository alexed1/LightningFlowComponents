import { LightningElement, api } from 'lwc';
import { FlowAttributeChangeEvent } from "lightning/flowSupport";

export default class Ers_InputWithCharacterCount extends LightningElement {

        
    @api charMaxCount;
    @api errorMessage;
    @api label;
    @api placeHolder;
    @api required = false;

    @api
    get sourceText() {
        this._charCount = this._sourceText.length;    
        return this._sourceText;
    }
    set sourceText(value) {
        this._sourceText = value;
    }
    _sourceText = '';

    @api
    get charCount() {
        return this._charCount;
    }
    set charCount(value) {
        this._charCount = value;
    }
    _charCount = 0;

    get overMax() {
        return this.charCount > this.charMaxCount;
    }

    get charString() {
        return `${this._charCount}/${this.charMaxCount}${this.overMax ? " "+this.errorMessage : ""}`;
    }

    get charCountClass() {
        const msgClass = "slds-var-p-top_xxx-small slds-var-p-left_x-small";
        return `${msgClass} ${this.overMax ? "warning" : "default"}`;
    }

    connectedCallback() {

    }

    handleChange(event) {
        this._sourceText = event.detail.value;
        const attributeChangeEvent = new FlowAttributeChangeEvent("charCount", this._charCount);
        this.dispatchEvent(attributeChangeEvent);
    }

}