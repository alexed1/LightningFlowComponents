import { LightningElement, api, track, wire } from 'lwc';

export default class ReactiveDisplay extends LightningElement {

    @track myDisplayValue;

    @api 
    get displayValue() {
        return this.myDisplayValue;
    }

    set displayValue(value) {
        this.myDisplayValue = value;
    }
    
}