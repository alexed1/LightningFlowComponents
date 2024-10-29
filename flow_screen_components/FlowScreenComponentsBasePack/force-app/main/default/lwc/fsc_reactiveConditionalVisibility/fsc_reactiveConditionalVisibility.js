import { api, track, LightningElement } from 'lwc'; 
import { FlowAttributeChangeEvent } from 'lightning/flowSupport';

export default class Fsc_reactiveConditionalVisibility extends LightningElement {

    @api
    get reactiveValue() {
        return this._reactiveValue;
    }
    set reactiveValue(value) {
        this._reactiveValue = value;
    }
    _reactiveValue;

    @track oldReactiveValue;

    get textReactiveValue() {
        return JSON.stringify(this._reactiveValue);
    }

    renderedCallback() {
        if (this.textReactiveValue && this.textReactiveValue != this.oldReactiveValue) {
            this.dispatchEvent(new FlowAttributeChangeEvent("reactiveValue", this._reactiveValue));
        }
        this.oldReactiveValue = this._reactiveValue;
    }

}