import {LightningElement, api, track, wire} from 'lwc';
import getFlowNamesApex from '@salesforce/apex/FlowListController.getFlowNamesApex';
import {FlowAttributeChangeEvent} from 'lightning/flowSupport';

export default class flowPickerFSC extends LightningElement {
    @api label;
    @api selectedFlowApiName;
    @api showActiveFlowsOnly = false;
    @api required;
    @api showWhichFlowTypes = 'Flow,AutolaunchedFlow';
    @track flowDefinitions;


    @wire(getFlowNamesApex, {filtersString: '$filters'})
    _getFlowNamesApex({error, data}) {
        if (error) {
            console.log(error.body.message);
        } else if (data) {
            this.flowDefinitions = data;
        }
    }

    get filters() {
        let filters = new Object();

        if (this.showWhichFlowTypes) {
            filters['ProcessType'] = this.splitValues(this.showWhichFlowTypes);
        }
        if (this.showActiveFlowsOnly) {
            filters['!ActiveVersionId'] = ['null'];
        }
        return JSON.stringify(filters);
    }

    get options() {
        if (this.flowDefinitions) {
            return this.flowDefinitions.map(curFD => {
                return {
                    value: curFD.ApiName,
                    label: curFD.Label
                }
            });
        } else {
            return [];
        }
    }

    handleChange(event) {
        this.selectedFlowApiName = event.detail.value;
        const attributeChangeEvent = new FlowAttributeChangeEvent('selectedFlowApiName', this.selectedFlowApiName);
        this.dispatchEvent(attributeChangeEvent);
    }

    @api
    validate() {
        if (this.required && !this.selectedFlowApiName) {
            return {
                isValid: false,
                errorMessage: 'Complete this field.'
            };
        } else {
            return {isValid: true};
        }
    }

    splitValues(originalString) {
        if (originalString) {
            return originalString.replace(/ /g, '').split(',');
        } else {
            return [];
        }
    };

}