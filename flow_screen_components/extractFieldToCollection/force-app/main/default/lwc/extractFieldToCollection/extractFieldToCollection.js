/**
 * Lightning Web Component for Flow Screens:       extractFieldToCollection
 * 
 * CREATED BY:          Eric Smith
 * 
 * VERSION:             4.x.x
 * 
 * RELEASE NOTES:       https://github.com/alexed1/LightningFlowComponents/tree/master/flow_screen_components/datatable/README.md
**/

import { api, track, LightningElement } from 'lwc';
import { FlowAttributeChangeEvent } from 'lightning/flowSupport';
import extractFieldToCollection from '@salesforce/apex/ExtractFieldToCollectionController.extractFieldToCollection';

export default class ExtractFieldToCollection extends LightningElement {

    @api inputRecordCollection;
    @api fieldAPIName = 'Id';
    @api dedupeValues;
    @api allowEmptyCollection = false;
    @api fieldValueCollection;
    @api fieldValueString;
    @api error;

    @track oldCollectionString;

    get collectionString() {
        return JSON.stringify(this.inputRecordCollection);
    }

    get dedupeDefault() {
        return this.dedupeValues != false ? true : false;
    }

    renderedCallback() {
        if (this.collectionString && this.collectionString != this.oldCollectionString) {
            this._getTextCollection();
        }
    }

    handleOnChange() {
        this._debounceGetTextCollection();
    }
    
    _getTextCollection() {

        extractFieldToCollection({ inputRecordCollection: this.inputRecordCollection, fieldAPIName: this.fieldAPIName, dedupeValues: this.dedupeDefault, allowEmptyCollection: this.allowEmptyCollection })
        .then(result => {
            console.log("🚀 ~ file: extractFieldToCollection.js:26 ~ ExtractFieldToCollection ~ .then ~ result:", result);
            let returnResults = JSON.parse(result);
            console.log("🚀 ~ file: extractFieldToCollection.js:41 ~ ExtractFieldToCollection ~ .then ~ returnResults:", returnResults);
            this._fireFlowEvent("fieldValueCollection", returnResults.fieldValueCollection);
            this._fireFlowEvent("fieldValueString", returnResults.fieldValueString);
        })
        .catch(error => {
            this.error = error?.body?.message ?? JSON.stringify(error);
            console.log("🚀 ~ file: extractFieldToCollection.js:32 ~ ExtractFieldToCollection ~ setinputRecordCollection ~ this.error:", this.error);
            console.error(error.body.message);
            this._fireFlowEvent("error", this.error);
        });

        this.oldCollectionString = this.collectionString;

    }

    _debounceGetTextCollection() {
        this._debounceTimer && clearTimeout(this._debounceTimer);
        if (this.collectionString){
            this._debounceTimer = setTimeout(() => this._getTextCollection(), 300);
        }    
    }  

    _fireFlowEvent(attributeName, data) {
        this.dispatchEvent(new FlowAttributeChangeEvent(attributeName, data));
    }

}