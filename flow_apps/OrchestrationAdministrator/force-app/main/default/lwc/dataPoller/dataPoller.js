import { api, LightningElement } from 'lwc';
import getSobjects from '@salesforce/apex/DataPollerController.getSobjects';
import { FlowAttributeChangeEvent } from 'lightning/flowSupport';
export default class DataPoller extends LightningElement {
    @api pollingFrequency = 3;
    @api queryString;
    @api retrievedRecords = [];
    @api error;

    connectedCallback() {
        setInterval(function() {
            getSobjects({queryString : this.queryString}).then(
                result => {
                    
                    this.retrievedRecords = result;
                    this.dispatchEvent(new FlowAttributeChangeEvent('retrievedRecords', this.retrievedRecords));             
                }
            ).catch(
                error => {
                    this.error = error;
                    console.error('error', error);
                }
            );
        }.bind(this), this.pollingFrequency * 1000
        )
        
    }

}