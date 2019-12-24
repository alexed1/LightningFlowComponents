import { LightningElement, api, track,wire} from 'lwc';
import {FlowAttributeChangeEvent} from 'lightning/flowSupport';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import TYPE_FIELD from '@salesforce/schema/Account.Type';

/* eslint-disable no-alert */
/* eslint-disable no-console */


export default class SmartChoiceFSC extends LightningElement {


    @api value;
    @api masterLabel;
    @api choiceLabels;
    @api choiceValues; //string collection
    @api displayMode;

    @api recordTypeId; //used for picklist fields
    @api objectName; //used for picklist fields
    @api fieldName; //used for picklist fields

    @api useWhichFieldForValue;
    @api useWhichFieldForLabel;
    @api inputMode;
    @api required;
    picklistOptionsStorage;

    @track selectedValue;
    @track showRadio = true;
    @track legitInputModes = [
        'Picklist Field',
        'Single String Collection',
        'Dual String Collections'
    ];
    @track options = [];
   
//possibility masster record type only works if there aren't other record types? 
    @wire(getPicklistValues, { recordTypeId: '$recordTypeId', fieldApiName: 'Account.Type'})
    picklistValues({error, data}) {
        if (data) {
            console.log('inside picklist wiring');
            let picklistOptions = [{ label: '--None--', value: '--None--'}];

            // Picklist values
            data.values.forEach(key => {
                picklistOptions.push({
                    label: key.label, 
                    value: key.value
                })
            });

            this.picklistOptionsStorage = picklistOptions;
            if(this.inputMode === 'Picklist Field'){
                this.setPicklistOptions();
            }
        } else if (error) {
            this.error = JSON.stringify(error);
        }
    }

    setPicklistOptions() {
        this.options = this.picklistOptionsStorage;
    }


    connectedCallback() {
        console.log('initializing smartchoice');
        if (this.displayMode === 'Picklist') {
            this.showRadio = false;
        }

        console.log("initializing smartChoice. inputMode is: " + this.inputMode);
        let options = [];
        let index = 0;
         if (this.legitInputModes.includes(this.inputMode)) {
            switch (this.inputMode) {
                //User can simply pass in a collection of strings as choiceValues. The same text is used for both label and value
                case 'Single String Collection' : 
                    console.log('entering input mode String Collection');
                    console.log ('choiceValues is: ' + this.choiceValues);
                    //console.log ('splitting choice values would be: ' + this.choiceValues.split(','));
                    //let values = this.choiceValues.split(';');

                    this.choiceValues.forEach((value) => {
                        console.log('value is: ' + value);
                        options.push({label: value, value: value});
                        console.log('options is: ' + options);
                    });
                break;

                //User can  pass in one collection of strings for visible labels and another for the underlying values (such as recordIds) 
                case 'Dual String Collections' : 
                    console.log('entering input mode Dual String Collections');
                    console.log ('choiceValues is: ' + this.choiceValues);
                    //console.log ('splitting choice values would be: ' + this.choiceValues.split(','));
                    //let values = this.choiceValues.split(';');
                    
                    this.choiceLabels.forEach((label) => {
                        console.log('label is: ' + label);
                        console.log('value is: ' + this.choiceValues[index]);
                        options.push({label: label, value: this.choiceValues[index]});
                        console.log('options is: ' + options);
                        index += 1;
                    });
                break;

                default:
                

            }
            this.options = options;
        }
            
        else {
            throw new Error('Missing or invalid inputMode value');
        }
         

           

         

            

        }

    handleChange(event) {
        this.selectedValue = event.detail.value;
        console.log('selected value is: ' + this.selectedValue);
        const attributeChangeEvent = new FlowAttributeChangeEvent('value', this.selectedValue);
        this.dispatchEvent(attributeChangeEvent);
    }
}