import { LightningElement, api } from 'lwc';
import getFlowVersions from '@salesforce/apex/FlowsSelecterController.getFlowVersions';
export default class FlowsSelector extends LightningElement {
    //flow outputs
    @api selectedFlow1APIName = '';
    @api selectedFlow2APIName = '';

    //flow inputs
    @api baseFlowName = '';
    @api baseFlowVersion = '';
    @api secondFlowName = '';
    @api secondFlowVersion = '';


    @api mainLabel = 'Select flow';
    @api selectFlowLabel = 'Select flow';

    selectFlow1(event) {
        this.selectedFlow1APIName = event.detail;
    }

    selectFlow2(event) {
        this.selectedFlow2APIName = event.detail;
    }

    @api
    validate() {
        console.log(this.selectedFlow1APIName, this.selectedFlow2APIName);
        if (!this.selectedFlow1APIName || !this.selectedFlow2APIName) {
            return {
                isValid: false,
                errorMessage: 'Please select two Flows'
            };
        } else if(this.selectedFlow1APIName.split('-')[0] !== this.selectedFlow2APIName.split('-')[0]) {
            return {
                isValid: false,
                errorMessage: 'Please select a flows with the same name'
            };
        } else {
            return {isValid: true};
        }
    }

}