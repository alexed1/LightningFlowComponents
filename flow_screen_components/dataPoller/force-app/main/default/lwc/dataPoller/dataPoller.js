import { api, LightningElement } from 'lwc';
import getSobjects from '@salesforce/apex/DataPollerController.getSobjects';
import { FlowAttributeChangeEvent } from 'lightning/flowSupport';
export default class DataPoller extends LightningElement {
    @api pollingFrequency = 3;
    @api queryString;

    @api newQueryString;

    _queryId;
    @api 
    get queryId() {
        return this._queryId;
    }
    set queryId(value) {
        this._queryId = value;
        this.newQueryString = this.queryString.replace('{Id}', value);
    }

    @api retrievedRecords = [];
    @api error;

    connectedCallback() {
        this.dispatchEvent(new FlowAttributeChangeEvent('retrievedRecords', [])); 
        setInterval(function() {
            getSobjects({queryString : this.newQueryString}).then(
                result => {
                    this.retrievedRecords = result;
                    this.dispatchEvent(new FlowAttributeChangeEvent('retrievedRecords', this.retrievedRecords));             
                }
            ).catch(
                error => {
                    console.error('error', error);
                    if(this.newQueryString) {
                        this.error = error?.body?.message;
                        this.dispatchEvent(new FlowAttributeChangeEvent('error', this.error?.body?.message)); 
                    }
                }
            );
        }.bind(this), this.pollingFrequency * 1000
        )
        
    }

}