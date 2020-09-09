import { LightningElement, track, api } from 'lwc';
import { FlowAttributeChangeEvent, FlowNavigationNextEvent } from 'lightning/flowSupport';
import IBAN from './iban.js';

export default class IbanComponent extends LightningElement {
    @api availableActions = [];
    _value = '';
    @api set value(iban) {
        this._value = this.formatIBAN(iban);
    } get value() {
        return this._value;
    }
    @track invalidIBAN = false;
    
    isValidIBANNumber(input) {
        input = input.replace(/ /g, '');
        return IBAN.isValid(input);
    }
    
    validateIBAN() {
        if (!this.isValidIBANNumber(this.value)) {
            this.invalidIBAN = true;
            this.template.querySelector(".slds-form-element").classList.add("slds-has-error");
        } else {
            this.invalidIBAN = false;
            this.template.querySelector(".slds-form-element").classList.remove("slds-has-error");
        }
    }

    handleIBAN2Change(event) {
        if (event.code === "KeyA" && event.target.selectionStart === 0 && event.target.selectionEnd === event.target.value.length) {
            return;
        }
        if (event.key === "Meta" || event.key === "Shift") {
            this.value = event.target.value;
            event.target.value = this.value;
            this.validateIBAN();
            return;
        }
        if (event.shiftKey === true && (event.key === "ArrowLeft" || event.key === "ArrowRight")) {
            this.value = event.target.value;
            event.target.value = this.value;
            this.validateIBAN();
            return;
        }
        const previousSelection = event.target.selectionStart;
        const lengthBefore = event.target.value.length;
        this.value = event.target.value;
        const lengthAfter = this.value.length;
        this.validateIBAN();
        event.target.value = this.value;
        if (previousSelection === lengthBefore) {
            event.target.selectionStart = lengthAfter;
            event.target.selectionEnd = lengthAfter;
            this.dispatchEvent(new FlowAttributeChangeEvent('value', this.value));
            return;
        }
        event.target.selectionStart = previousSelection;
        event.target.selectionEnd = previousSelection;
        this.dispatchEvent(new FlowAttributeChangeEvent('value', this.value));
    }

    formatIBAN(value) {
        return value.toUpperCase().replace(/[^\dA-Z]/g, '').replace(/(.{4})/g, '$1 ').trim();
    }

    get displayNext() {
        if (this.availableActions && this.availableActions.find(action => action === 'NEXT')) {
            return true;
        } else {
            return false;
        }
    }

    handleGoNext() {
        if (this.availableActions.find(action => action === 'NEXT')) {
            this.dispatchEvent(new FlowNavigationNextEvent());
        }
    }

    @api validate() {
        if(this.isValidIBANNumber) {
            return {isValid: true};
        } 
        else { 
            return { 
                isValid: false, 
                errorMessage: 'The entered IBAN number is not valid'
            };
        }
    }
}