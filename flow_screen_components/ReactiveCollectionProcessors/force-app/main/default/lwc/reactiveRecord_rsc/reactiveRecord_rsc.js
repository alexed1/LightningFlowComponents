/**
 * Lightning Web Component for Flow Screens:       Reactive Record 
 * 
 * Reactive Flow Screen Component LWC designed to seed a reactive screen component with an alternate record when the screen loads 
 * then on subsequent reactive refreshes of the component, the primary record is used.
 * 
 * Created By:  Eric Smith
 * 
 *              12/24/24     Version: 1.0.0  Initial Release
 * 
 * LWC:         reactiveRecord_rscc
 *       
**/

// Code commented this way is a standard part of the template and should stay as is
// * Code commented this way should be adjusted to fit your use case

// Standard lWC import
import { api, track, LightningElement } from 'lwc'; 
// Standard import for notifying flow of changes in attribute values
import { FlowAttributeChangeEvent } from 'lightning/flowSupport';

// * Define the name of the Component
export default class ReactiveRecord_rsc extends LightningElement {

    // * Define each of the LWC's attributes, with defaults if needed
    @api inputRecord;
    @api alternateRecord;
    @api outputRecord;
    
    // Define the attribute used to store an error message
    @api error;   

    // Track prior value(s) for reactive attributes
    @track oldReactiveValue; 

    // Get the Reactive Attribute Value
    get reactiveValue() { 
        // * Return reactive attributes as a string to be used in tracking
        return JSON.stringify(this.inputRecord);
    }

    // On rendering, check for a value or change in value of reactive attribute(s) and execute the handler
    renderedCallback() {
        if ((this.reactiveValue && this.reactiveValue != this.oldReactiveValue) || (this.alternateRecord && this.alternateRecord != null)) {
            this._callReactiveMethod();
        }
    }

    // On a change in the reactive attribut(s), call the debounce handler for the AuraEnabledMethod handler
    handleOnChange() { 
        this._debounceHandler();
    }

    // Handle reactive processing logic
    _callReactiveMethod() {

        if(this.inputRecord && this.inputRecord != null) {
            this.outputRecord = this.inputRecord;
        } else {
            this.outputRecord = this.alternateRecord;
        }
        this._fireFlowEvent("outputRecord", this.outputRecord);

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

    // Dispatch the value of a changed attribute back to the flow
    _fireFlowEvent(attributeName, data) {
        this.dispatchEvent(new FlowAttributeChangeEvent(attributeName, data));
    }

}