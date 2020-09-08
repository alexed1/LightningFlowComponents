import { LightningElement, track } from 'lwc';

export default class IbanComponent extends LightningElement {
    @track value = '';
    @track invalidIBAN = false;
    
    /*
     * Returns 1 if the IBAN is valid 
     * Returns FALSE if the IBAN's length is not as should be (for CY the IBAN Should be 28 chars long starting with CY )
     * Returns any other number (checksum) when the IBAN is invalid (check digits do not match)
     */
    isValidIBANNumber(input) {
        var CODE_LENGTHS = {
            AD: 24, AE: 23, AT: 20, AZ: 28, BA: 20, BE: 16, BG: 22, BH: 22, BR: 29,
            CH: 21, CR: 21, CY: 28, CZ: 24, DE: 22, DK: 18, DO: 28, EE: 20, ES: 24,
            FI: 18, FO: 18, FR: 27, GB: 22, GI: 23, GL: 18, GR: 27, GT: 28, HR: 21,
            HU: 28, IE: 22, IL: 23, IS: 26, IT: 27, JO: 30, KW: 30, KZ: 20, LB: 28,
            LI: 21, LT: 20, LU: 20, LV: 21, MC: 27, MD: 24, ME: 22, MK: 19, MR: 27,
            MT: 31, MU: 30, NL: 18, NO: 15, PK: 24, PL: 28, PS: 29, PT: 25, QA: 29,
            RO: 24, RS: 22, SA: 24, SE: 24, SI: 19, SK: 24, SM: 27, TN: 24, TR: 26,   
            AL: 28, BY: 28, CR: 22, EG: 29, GE: 22, IQ: 23, LC: 32, SC: 31, ST: 25,
            SV: 28, TL: 23, UA: 29, VA: 22, VG: 24, XK: 20
        };
        var iban = String(input).toUpperCase().replace(/[^A-Z0-9]/g, ''), // keep only alphanumeric characters
                code = iban.match(/^([A-Z]{2})(\d{2})([A-Z\d]+)$/), // match and capture (1) the country code, (2) the check digits, and (3) the rest
                digits;
        // check syntax and length
        if (!code || iban.length !== CODE_LENGTHS[code[1]]) {
            return false;
        }
        // rearrange country code and check digits, and convert chars to ints
        digits = (code[3] + code[1] + code[2]).replace(/[A-Z]/g, function (letter) {
            return letter.charCodeAt(0) - 55;
        });
        // final check
        return this.mod97(digits);
    }
    
    mod97(string) {
        var checksum = string.slice(0, 2), fragment;
        for (var offset = 2; offset < string.length; offset += 7) {
            fragment = String(checksum) + string.substring(offset, offset + 7);
            checksum = parseInt(fragment, 10) % 97;
        }
        return checksum;
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
            this.value = event.target.value.toUpperCase().replace(/[^\dA-Z]/g, '').replace(/(.{4})/g, '$1 ').trim();
            event.target.value = this.value;
            this.validateIBAN();
            return;
        }
        if (event.shiftKey === true && (event.key === "ArrowLeft" || event.key === "ArrowRight")) {
            this.value = event.target.value.toUpperCase().replace(/[^\dA-Z]/g, '').replace(/(.{4})/g, '$1 ').trim();
            event.target.value = this.value;
            this.validateIBAN();
            return;
        }
        const previousSelection = event.target.selectionStart;
        const lengthBefore = event.target.value.length;
        this.value = event.target.value.toUpperCase().replace(/[^\dA-Z]/g, '').replace(/(.{4})/g, '$1 ').trim();
        const lengthAfter = this.value.length;
        this.validateIBAN();
        event.target.value = this.value;
        if (previousSelection === lengthBefore) {
            event.target.selectionStart = lengthAfter;
            event.target.selectionEnd = lengthAfter;
            return;
        }
        event.target.selectionStart = previousSelection;// + lengthAfter - lengthBefore;
        event.target.selectionEnd = previousSelection;// + lengthAfter - lengthBefore;
    }
}