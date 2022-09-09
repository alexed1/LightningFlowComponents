/*------------------------------------------------------------
@author        Salesforce, Jeroen Burgers
@description   Flow utility Lwc to determine Form factor and auto-navigate the Flow
               Auto-navigate is optional, default to false
               Form factor is returned per output, so Flow can branch based on Form Factor
Version:       1.0
History
        @date 27/12/2019      Created
------------------------------------------------------------*/
import { LightningElement, api } from 'lwc';
import { FlowAttributeChangeEvent, FlowNavigationNextEvent } from 'lightning/flowSupport';
import FORM_FACTOR from '@salesforce/client/formFactor';

export default class FormfactorFlowHelperLwc extends LightningElement {

    @api availableActions = [];         // Populated by lightning/flowSupport
    @api autoNavigate = false;          // Input. Should the Lwc execute the Flow's navigate event?
    @api formFactor = '';               // Output. Form factor.

    connectedCallback() {
        this.setFormFactor();
        // Workaround for Winter '23
        if (this.autoNavigate) {
           setTimeout(() => {
               this.navigate();						
           }, 0)
        }
    }

    setFormFactor () {
        const attributeChangeEvent = new FlowAttributeChangeEvent('formFactor', FORM_FACTOR);
        this.dispatchEvent(attributeChangeEvent);
    }

    navigate () {
        if (this.availableActions.find(action => action === 'NEXT')) {
            const navigateNextEvent = new FlowNavigationNextEvent();
            this.dispatchEvent(navigateNextEvent);
        }
    }
}
