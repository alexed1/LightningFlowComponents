/**
 * Lightning Web Component for Flow Screens:       collectionCalculate
 * 
 * Sample Reactive Flow Screen Component LWC, that calls an AuraEnabled Apex Method in a Controller, that calls an Invocable Flow Action
 * 
 * Created By:  Eric Smith
 * 
 *              07/24/23    Version: 1.0.0  Initial Release
 *              10/21/23    Version: 1.0.1  Updated with Date format fix
 * 
 * LWC:         collectionCalculate
 * Controller:  collectionCalculateController
 * Action:      CollectionCalculate
 *              Collection Processors (https://unofficialsf.com/list-actions-for-flow/)
 *       
**/

// Code commented this way is a standard part of the template and should stay as is
// * Code commented this way should be adjusted to fit your use case

// Standard lWC import
import { api, track, LightningElement } from 'lwc'; 
// Standard import for notifying flow of changes in attribute values
import { FlowAttributeChangeEvent } from 'lightning/flowSupport';

// * Import the AuraEnabled Method from the Controller
import collectionCalculate from '@salesforce/apex/CollectionCalculateController.collectionCalculate';

// * Define the name of the Component
export default class CollectionCalculate extends LightningElement {

    // * Define each of the LWC's attributes, with defaults if needed
    @api inputCollection;
    @api fieldName; 
    @api operation;
    @api policyForNullAndEmptyFields;
    @api outputDecimalResult;
    @api outputStringResult;
    @api error;   

    // Track prior value(s) for reactive attributes
    @track oldReactiveValue; 

    // Get the Reactive Attribute Value
    get reactiveValue() { 
        // * Return reactive attributes as a string to be used in tracking
        return JSON.stringify(this.inputCollection) + this.fieldName + this.operation;
    }

    // On rendering, check for a value or change in value of reactive attribute(s) and execute the handler
    renderedCallback() {
        if (this.reactiveValue && this.reactiveValue != this.oldReactiveValue) {
            this._callAuraEnabledMethod();
        }
    }

    // On a change in the reactive attribut(s), call the debounce handler for the AuraEnabledMethod handler
    handleOnChange() { 
        this._debounceHandler();
    }

    // Call the Aura Enabled Method in the Controller
    _callAuraEnabledMethod() {

        // * Identify the Aura Enabled Method
        collectionCalculate({ 
            // * For each attribute to be passed to the controller - methodAttributeName: value from LWC
            inputCollection: this.inputCollection,
            fieldName: this.fieldName,
            operation: this.operation, 
            policyForNullAndEmptyFields: this.policyForNullAndEmptyFields
        })

        // If a valid result is returned,
        .then(result => { 

            // parse the result into individual attributes and fix the date format
            let returnResults = JSON.parse(result.replace(/\+0000/g, "Z"));

            // * LWC Output Attribute Name, value returned from the method
            // * If the attribute is a record collection, call the _removeAttr function on the result value
            this._fireFlowEvent("outputDecimalResult", returnResults.outputDecimalResult);
            this._fireFlowEvent("outputStringResult", returnResults.outputStringResult);

        })

        // This template includes a standard 'error' output attribute that will be exposed on the flow screen
        // If an error is returned, extract error message, and expose the error in the browser console
        .catch(error => { 
            this.error = error?.body?.message ?? JSON.stringify(error);
            // Skip if the error is undefined or empty
            if (this.error.length > 2) {
                console.error(this.error);
                this._fireFlowEvent("error", this.error);
            } else {
                this.error = "";
            }
        });

        // Save the current value(s) of the reactive attribute(s)
        this.oldReactiveValue = this.reactiveValue;

    }

    // Debounce the processing of the reactive changes
    _debounceHandler() {
        this._debounceTimer && clearTimeout(this._debounceTimer);
        if (this.reactiveValue){
            this._debounceTimer = setTimeout(() => this._callAuraEnabledMethod(), 300);
        }    
    }  

    // Remove 'attributes' that get added by the JSON conversion from a record collection
    _removeAttr(obj) {
        obj.forEach(rec => {
            delete rec['attributes'];
        });
        return obj;
    }

    // Dispatch the value of a changed attribute back to the flow
    _fireFlowEvent(attributeName, data) {
        this.dispatchEvent(new FlowAttributeChangeEvent(attributeName, data));
    }

}