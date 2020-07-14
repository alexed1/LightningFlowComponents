import {LightningElement, api, track, wire} from 'lwc';
import getFlowNamesApex from '@salesforce/apex/FlowListController.getFlowNamesApex';
import {FlowAttributeChangeEvent} from 'lightning/flowSupport';

export default class flowPickerFSC extends LightningElement {
    @api label;
    @api selectedFlowApiName;
    @api showActiveFlowsOnly = false;
    @api searchString;
    @api required;
    @api showWhichFlowTypes = 'Flow,AutolaunchedFlow';
    @api placeholder = '- Select a Flow -';
    @api componentWidth = '12';
    @track flowDefinitions;

    @wire(getFlowNamesApex, {filtersString: '$filters'})
    _getFlowNamesApex({error, data}) {
        if (error) {
            console.log(error.body.message);
        } else if (data) {
            this.flowDefinitions = data;
        }
    }

    // Set the width of the component as a # out of 12
    // 12 = 100% width, 6 = 50% width, 3 = 25%width, etc
    get comboboxWidth() {
        return 'slds-size_' + this.componentWidth + '-of-12 slds-form-element';
    }

    get filters() {
        let filters = new Object();

        if (this.showWhichFlowTypes) {
            filters['ProcessType'] = this.splitValues(this.showWhichFlowTypes);
        }
        if (this.showActiveFlowsOnly) {
            filters['!ActiveVersionId'] = ['null'];
        }
        // Add filter for Search String
        if (this.searchString) {
            filters['Label'] = ["\'%"+this.searchString+"%\'"];
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

    // This is added to make the selected Flow API Name available to a calling Aura component
    @api
    flowApiName() {
        return this.selectedFlowApiName;
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
