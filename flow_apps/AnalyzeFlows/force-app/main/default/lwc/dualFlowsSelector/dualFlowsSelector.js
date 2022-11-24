import { LightningElement, api } from 'lwc';
import getFlowVersions from '@salesforce/apex/FlowsSelecterController.getFlowVersions';
export default class FlowsSelector extends LightningElement {
    @api selectedFlow1APIName = '';
    @api selectedFlow2APIName = '';

    selectFlow1(event) {
        this.selectedFlow1APIName = event.detail;
    }

    selectFlow2(event) {
        this.selectedFlow2APIName = event.detail;
    }

    @api
    validate() {
        if (!this.selectedFlow1APIName || !this.selectedFlow2APIName) {
            return {
                isValid: false,
                errorMessage: 'Please select two Flows'
            };
        } else {
            return {isValid: true};
        }
    }

}