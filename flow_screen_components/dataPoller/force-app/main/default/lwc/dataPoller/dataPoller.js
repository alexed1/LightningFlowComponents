import { api, LightningElement } from 'lwc';
import getSobjects from '@salesforce/apex/DataPollerController.getSobjects';
import { FlowAttributeChangeEvent } from 'lightning/flowSupport';

export default class DataPoller extends LightningElement {
    @api pollingFrequency = 3;
    @api queryString;
    @api newQueryString;

    @api runInitialQueryImmediately = false;

    _queryId;
    @api 
    get queryId() {
        return this._queryId;
    }
    set queryId(value) {
        this._queryId = value;
        this.newQueryString = this.queryString?.replace('{Id}', value);
    }

    @api retrievedRecords = [];
    @api error;

    connectedCallback() {
        if (!this.newQueryString && this.queryString) {
            this.newQueryString = this.queryString;
        }

        this.dispatchEvent(new FlowAttributeChangeEvent('retrievedRecords', [])); 

        if (this.runInitialQueryImmediately) {
            this.executeQuery();
        }

        setInterval(this.executeQuery.bind(this), this.pollingFrequency * 1000);
    }

    executeQuery() {
        if (!this.newQueryString) {
            console.error('Error: queryString or newQueryString is undefined');
            return;
        }

        getSobjects({ queryString: this.newQueryString })
            .then(result => {
                this.retrievedRecords = result;
                this.dispatchEvent(new FlowAttributeChangeEvent('retrievedRecords', this.retrievedRecords));
            })
            .catch(error => {
                console.error('Error executing query:', error);
                this.error = error?.body?.message;
                this.dispatchEvent(new FlowAttributeChangeEvent('error', this.error));
            });
    }
}
