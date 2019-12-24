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
    masterRecordTypeId = '012000000000000AAA'; //if a recordTypeId is not provided, use this one
    @api objectAndFieldName;

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
    @wire(getPicklistValues, { recordTypeId: '$recordTypeId', fieldApiName: '$objectAndFieldName'})
    picklistValues({error, data}) {
        if (data) {
            console.log('inside picklist wiring');
            
            let picklistOptions = [{ label: '--None--', value: 'None'}];

            // Picklist values
            data.values.forEach(key => {
                picklistOptions.push({
                    label: key.label, 
                    value: key.value
                })
            });

            this.picklistOptionsStorage = picklistOptions;
            if (this.displayMode === 'Picklist') {
                this.showRadio = false;
            }
            if(this.inputMode === 'Picklist Field'){
                this.setPicklistOptions();
            }
        } else if (error) {
            this.error = JSON.stringify(error);
            console.log('getPicklistValues wire service returned error: ' + this.error);
            console.log('object and field ' + this.objectPlusFieldName);
            if (!this.objectPlusFieldName)
                throw new Error('objectPlusFieldName is undefined. Needs a value like Account.Rating');
        }
    }

    setPicklistOptions() {
        this.options = this.picklistOptionsStorage;
    }


    connectedCallback() {
        console.log('initializing smartchoice');
        console.log('recordtypeId is: ' + this.recordTypeId);
        console.log('objectFieldName is: ' + this.objectAndFieldName);
        if (!this.recordTypeId)
            this.recordTypeId = this.masterRecordTypeId;

        if (this.displayMode === 'Picklist') {
            console.log('setting Picklist on');
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
            console.log('SmartChoiceFSC: Need a valid Input Mode value. Didn\'t get one');
            throw new Error('SmartChoiceFSC: Need a valid Input Mode value. Didn\'t get one');
        }
    

     }

    @api
    validate() {
        let errorMessage = 'You must make a selection in: ' +  this.masterLabel + ' to continue'; 
        
        if((this.required === true) && (this.value === 'None')) { 
           //If the component is invalid, return the isValid parameter as false and return an error message. 
           return { 
                isValid: false, 
                errorMessage: errorMessage,
            }; 
        } 
        else {   
            return { isValid: true }; 
        }
    }
     
    

    handleChange(event) {
        this.selectedValue = event.detail.value;
        console.log('selected value is: ' + this.selectedValue);
        const attributeChangeEvent = new FlowAttributeChangeEvent('value', this.selectedValue);
        this.dispatchEvent(attributeChangeEvent);
    }
}