import { api, LightningElement } from 'lwc';
import getSobjects from '@salesforce/apex/DataPollerController.getSobjects';
import { FlowAttributeChangeEvent } from 'lightning/flowSupport';
export default class DataPoller extends LightningElement {
    @api pollingFrequency = 3;
    @api queryString;
    @api retrievedRecords = [];
    @api error;

    connectedCallback() {
        console.log('queryString', this.queryString);
        console.log('pollingFrequency', this.pollingFrequency);
        setInterval(function() {
            console.log('queryString', this.queryString);
            console.log('pollingFrequency', this.pollingFrequency,JSON.parse(JSON.stringify(this.retrievedRecords)));
            getSobjects({queryString : this.queryString}).then(
                result => {
                    console.log('result ', result);
                    
                    this.retrievedRecords = result;
                    this.dispatchEvent(new FlowAttributeChangeEvent('retrievedRecords', this.retrievedRecords));    //JSON Version
                    console.log('result2 ', JSON.parse(JSON.stringify(this.retrievedRecords)));
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

    refresh(){
        console.log('queryString', this.queryString);
        console.log('pollingFrequency', this.pollingFrequency);
        console.log('retrievedRecords', JSON.parse(JSON.stringify(this.retrievedRecords)));
        
        
    }
}