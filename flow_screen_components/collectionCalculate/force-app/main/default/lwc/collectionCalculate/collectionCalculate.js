/**
 * 
 * By:      Eric Smith
 * Date:    07/24/23
 * Version: 1.0.0
 * 
 * LWC:         collectionCalculate
 * Controller:  collectionCalculateController
 * Action:      CollectionCalculate
 *              Collection Processors (https://unofficialsf.com/list-actions-for-flow/)
 *       
**/

import { api, track, LightningElement } from 'lwc'; 
import { FlowAttributeChangeEvent } from 'lightning/flowSupport';    
import collectionCalculate from '@salesforce/apex/CollectionCalculateController.collectionCalculate';

export default class CollectionCalculate extends LightningElement {

    @api inputCollection;
    @api fieldName; 
    @api operation;
    @api policyForNullAndEmptyFields;
    @api outputDecimalResult;
    @api outputStringResult;
    @api error;   

    @track oldReactiveValue; 

    get reactiveValue() { 
        return JSON.stringify(this.inputCollection) + this.fieldName;
    }

    renderedCallback() {
        if (this.reactiveValue && this.reactiveValue != this.oldReactiveValue) {
            this._callAuraEnabledMethod();
        }
    }

    handleOnChange() { 
        this._debounceHandler();
    }

    _callAuraEnabledMethod() {
        collectionCalculate({ 
            inputCollection: this.inputCollection,
            fieldName: this.fieldName,
            operation: this.operation, 
            policyForNullAndEmptyFields: this.policyForNullAndEmptyFields
        })
        .then(result => { 
            let returnResults = JSON.parse(result);
            this._fireFlowEvent("outputDecimalResult", returnResults.outputDecimalResult);
            this._fireFlowEvent("outputStringResult", returnResults.outputStringResult);
        })
        .catch(error => { 
            this.error = error?.body?.message ?? JSON.stringify(error);
            console.error(error.body.message);
            this._fireFlowEvent("error", this.error);
        });

        this.oldReactiveValue = this.reactiveValue;

    }

    _debounceHandler() {
        this._debounceTimer && clearTimeout(this._debounceTimer);
        if (this.reactiveValue){
            this._debounceTimer = setTimeout(() => this._callAuraEnabledMethod(), 300);
        }    
    }  

    _fireFlowEvent(attributeName, data) {
        this.dispatchEvent(new FlowAttributeChangeEvent(attributeName, data));
    }

}