import {LightningElement, api, track} from 'lwc';
import {FlowAttributeChangeEvent} from 'lightning/flowSupport';

export default class ExpressChoiceFSC extends LightningElement {
    @api masterLabel;
    @api choiceLabels;
    @api choiceValues;
    @api displayMode;
    @api approvalProcessStepDefinitions;
    @api approvalProcessDefinitions;
    @api useWhichFieldForValue;
    @api useWhichFieldForLabel;
    @api inputMode;
    @api required;
    // @api value;

    @track selectedValue;
    @track showRadio = true;
    @track legitInputModes = [
        'Choice labels',
        'Approval process step definitions',
        'Approval process definitions'
    ];
    @track options = [];

    @api
    get value() {
        return this.selectedValue;
    }

    set value(curValue) {
        this.selectedValue = curValue;
    }

    connectedCallback() {

        if (this.displayMode === 'Picklist') {
            this.showRadio = false;
        }

        if (this.legitInputModes.includes(this.inputMode)) {
            let index = this.legitInputModes.indexOf(this.inputMode)
            let options = [];

            if (index === 0) {
                let labels = this.choiceLabels.split(';');
                let values = this.choiceValues.split(';');

                labels.forEach((label, ind) => {
                    options.push({label: label, value: values[ind]});
                });
            }

            if (index === 1) {
                let approvalProcessStepDefinitions = JSON.parse(this.approvalProcessStepDefinitions);
                approvalProcessStepDefinitions.forEach(item => {
                    options.push({label: item[this.useWhichFieldForLabel], value: item[this.useWhichFieldForValue]});
                })
            }

            if (index === 2) {
                let approvalProcessDefinitions = JSON.parse(this.approvalProcessDefinitions);
                approvalProcessDefinitions.forEach(item => {
                    options.push({label: item[this.useWhichFieldForLabel], value: item[this.useWhichFieldForValue]});
                })
            }

            this.options = options;

        }
    }

    handleChange(event) {
        this.selectedValue = event.detail.value;
        const attributeChangeEvent = new FlowAttributeChangeEvent('value', this.selectedValue);
        this.dispatchEvent(attributeChangeEvent);
    }
}