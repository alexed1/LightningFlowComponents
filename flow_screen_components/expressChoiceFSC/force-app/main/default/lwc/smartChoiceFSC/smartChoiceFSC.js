import { LightningElement, api, track} from 'lwc';
import {FlowAttributeChangeEvent} from 'lightning/flowSupport';

export default class SmartChoiceFSC extends LightningElement {


    @api value;
    @api masterLabel;
    @api choiceLabels;
    @api choiceValues; //string collection
    @api displayMode;
    @api useWhichFieldForValue;
    @api useWhichFieldForLabel;
    @api inputMode;
    @api required;
  

    @track selectedValue;
    @track showRadio = true;
    @track legitInputModes = [
        'String Collection',
        'Picklist Field',
    ];
    @track options = [];


    connectedCallback() {
        console.log("initializing expressChoice. inputMode is: " + this.inputMode);
        if (this.displayMode === 'Picklist') {
            this.showRadio = false;
        }
        
        if (this.legitInputModes.includes(this.inputMode)) {
            console.log("entering legitInputModes");
            let options = [];

            if (this.inputMode === 'String Collection') {
                console.log('entering input mode String Collection');
                console.log ('choiceValues is: ' + this.choiceValues);
                //console.log ('splitting choice values would be: ' + this.choiceValues.split(','));
                //let values = this.choiceValues.split(';');

                this.choiceValues.forEach((value) => {
                    console.log('value is: ' + value);
                    options.push({label: value, value: value});
                    console.log('options is: ' + options);
                });
            }

            if (this.inputMode === 'Picklist Field') {
                let approvalProcessStepDefinitions = JSON.parse(this.approvalProcessStepDefinitions);
                
                approvalProcessStepDefinitions.forEach(item => {
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