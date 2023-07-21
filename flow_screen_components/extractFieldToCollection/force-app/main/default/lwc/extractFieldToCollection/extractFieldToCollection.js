/**
 * Lightning Web Component for Flow Screens:       extractFieldToCollection
 * 
 * Sample Reactive Flow Screen Component LWC, that calls an AuraEnabled Apex Method in a Controller, that calls an Invocable Flow Action
 * 
 * By:      Eric Smith
 * Date:    07/21/23
 * Version: 1.0.0
 * 
 * LWC:         extractFieldToCollection
 * Controller:  ExtractFieldToCollectionController
 * Action:      ExtractStringsFromCollection
 *              Collection Processors (https://unofficialsf.com/list-actions-for-flow/)
 * 
 **/

// Code commented this way is a standard part of the template and should stay as is
// * Code commented this way should be adjusted to fit your use case

import { api, track, LightningElement } from 'lwc';                                                                     // Standard lWC import
import { FlowAttributeChangeEvent } from 'lightning/flowSupport';                                                       // Standard import for notifying flow of changes in attribute values
import extractFieldToCollection from '@salesforce/apex/ExtractFieldToCollectionController.extractFieldToCollection';    // * Import the AuraEnabled Method from the Controller

export default class ExtractFieldToCollection extends LightningElement {                                                // * Define the name of the Component

    @api inputRecordCollection;                                                                                         // * Define each of the LWC's attributes, with defaults if needed
    @api fieldAPIName = 'Id';                                                                                           // * 
    @api dedupeValues;                                                                                                  // * 
    @api allowEmptyCollection = false;                                                                                  // * 
    @api fieldValueCollection;                                                                                          // * 
    @api fieldValueString;                                                                                              // * 
    @api error;                                                                                                         // * 

    @track oldReactiveValue;                                                                                            // * Track prior value(s) for reactive attributes

    get reactiveValue() {                                                                                               // Get the Reactive Attribute Value
        return JSON.stringify(this.inputRecordCollection);                                                              // * Return reactive attribute as a string to be used in tracking
    }

    get dedupeDefault() {                                                                                               // * Handle any boolean attributes that need a default value of true
        return this.dedupeValues != false ? true : false;                                                               // *
    }

    renderedCallback() {                                                                                                // On rendering, 
        if (this.reactiveValue && this.reactiveValue != this.oldReactiveValue) {                                        // check for a value or change in value of reactive attribute(s)
            this._callAuraEnabledMethod();                                                                              // execute the handler
        }
    }

    handleOnChange() {                                                                                                  // On a change in the reactive attribut(s),
        this._debounceHandler();                                                                                        // call the debounce handler for the AuraEnabledMethod handler
    }
    
    _callAuraEnabledMethod() {                                                                                          // Call the Aura Enabled Method in the Controller

        extractFieldToCollection({                                                                                      // * Identify the Aura Enabled Method
            inputRecordCollection: this.inputRecordCollection,                                                          // * methodAttributeName: value from LWC
            fieldAPIName: this.fieldAPIName,                                                                            // * 
            dedupeValues: this.dedupeDefault,                                                                           // * 
            allowEmptyCollection: this.allowEmptyCollection                                                             // * 
        })
        .then(result => {                                                                                               // If a valid result is returned,
            let returnResults = JSON.parse(result);                                                                     // parse the result into individual attributes
            this._fireFlowEvent("fieldValueCollection", returnResults.fieldValueCollection);                            // * LWC Output Attribute Name, value returned from the method
            this._fireFlowEvent("fieldValueString", returnResults.fieldValueString);                                    // *
        })
        .catch(error => {                                                                                               // If an error is returned,
            this.error = error?.body?.message ?? JSON.stringify(error);                                                 // extract error message, 
            console.error(error.body.message);                                                                          // and expose the error in the browser console
            this._fireFlowEvent("error", this.error);                                                                   // This template includes a standard 'error' output attribute that will be exposed on the flow screen
        });

        this.oldReactiveValue = this.reactiveValue;                                                                     // Save the current value(s) of the reactive attribute(s)

    }

    _debounceHandler() {                                                                                                // Debounce the processing of the reactive changes
        this._debounceTimer && clearTimeout(this._debounceTimer);                                                       // 
        if (this.reactiveValue){                                                                                        // 
            this._debounceTimer = setTimeout(() => this._callAuraEnabledMethod(), 300);                                 // 
        }    
    }  

    _fireFlowEvent(attributeName, data) {                                                                               // Dispatch the value of a changed attribute back to the flow
        this.dispatchEvent(new FlowAttributeChangeEvent(attributeName, data));                                          // 
    }

}