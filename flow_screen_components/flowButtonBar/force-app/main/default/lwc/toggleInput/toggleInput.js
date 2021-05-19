import { LightningElement, api } from 'lwc';

export default class ToggleInput extends LightningElement {
    @api label;
    @api options;
    @api value;    
    @api helpText;
    

    handleToggleChange(event) {
        this.dispatchEvent(new CustomEvent('togglechange', { 
            detail: { 
                value: event.detail.value 
            }
        }));
    }
}