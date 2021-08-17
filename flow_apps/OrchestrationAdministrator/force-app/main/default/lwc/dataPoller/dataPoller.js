import { api, LightningElement } from 'lwc';
import getSobjects from '@salesforce/apex/DataPollerController.getSobjects';
export default class DataPoller extends LightningElement {
    @api pollingFrequency = 3;
    @api queryString;
    @api retrievedRecords = [];
    @api error;

    connectedCallback() {
        setInterval(function() {
            console.log('queryString', this.queryString);
            console.log('pollingFrequency', this.pollingFrequency);
            getSobjects({queryString : this.queryString}).then(
                result => {
                    console.log('result ', result);
                    this.retrievedRecords = result;
                }
            ).catch(
                error => {
                    this.error = error;
                    console.error('error', error);
                }
            );
        }, this.pollingFrequency * 1000)
    }
}