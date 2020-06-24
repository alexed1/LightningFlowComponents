import { LightningElement,track,api,wire } from 'lwc';
import requestMetadata from '@salesforce/apex/RetrieveMetadata.retrieveMetadataItem';
import checkRetrieveStatus from '@salesforce/apex/RetrieveMetadata.checkAsyncRequest';
import getFileNames from '@salesforce/apex/RetrieveMetadata.getFileNames';
import deployMetadata from '@salesforce/apex/DeployMetadata.deploy';
import checkDeployStatus from '@salesforce/apex/DeployMetadata.checkAsyncRequest';
import {FlowAttributeChangeEvent} from 'lightning/flowSupport';
import { FlowNavigationNextEvent } from 'lightning/flowSupport';

export default class TransferMetadata extends LightningElement {
 
    contacts;
    error;

    @track jobId;

    @track activity;
    transferComplete = false;
    @api zipFileString = '';
    @api metadataName;
    @api transferMode;
    @api metadataString;
    @api objectType;
    modifiedName;


    connectedCallback() {

        this.activity = 'Beginning metadata transfer...';
       if (this.transferMode.toLowerCase() == 'retrieve')
            this.retrieve();
       else if (this.transferMode.toLowerCase() == 'deploy')
            this.deploy();
            else {
             console.log('transfermodeerror!');
            }
    }

    retrieve() {
        console.log('beginning retrieval');
        requestMetadata({ metadataName : this.metadataName })
        .then(result => {
            
            console.log('successfully sent async retrieval request');
            console.log('jobId is: ' + result);
             
            this.jobId = result;
            
            if (!this.transferComplete) {
                console.log('initial retrieval not complete');
                this.waitForRetrieval(this.jobId);
            }
        })
        .catch(error => {
            console.log('An error occurred on the initial retrieve call:');    
            this.activity = 'Error: ' + JSON.stringify(error.body.message);
            this.error = error;
        });
    }

    deploy() {
        console.log('beginning deployment');
        console.log('this.metadataName is: ' + this.metadataName);
        console.log('beginning deployment of this.metadataString is: ' + this.metadataString);
        console.log('this.objectTpe is: ' + this.objectType);
        if (this.objectType.toLowerCase() == this.objectType || this.objectType.toUpperCase() == this.objectType) {
            console.log('ERROR: objectType parameter should be in CamelCase');
        }
        // this.modifiedName = this.metadataName + '_Converted';
        this.modifiedName = this.metadataName;
        console.log('this.modifiedName is: ' + this.modifiedName);
        deployMetadata({ metadataText : this.metadataString, metadataName : this.modifiedName, testLevel: null, objectType : this.objectType,  })
        .then(result => {
            console.log('result of deployment request is: ' + result);
            console.log('successfully sent async deployment request');
            console.log('jobId is: ' + result);
             
            this.jobId = result;
            
            if (!this.transferComplete) {
                console.log('deployment not complete');
                this.waitForDeployment(this.jobId);
            } else
            this.activity = 'Deployment Complete!';
        })
        .catch(error => {
            console.log('error calling deployMetadata from transfer');
            this.error = error;
        });
    }
    
    waitForRetrieval(jobId) {
        setTimeout(function(){ 
            console.log('checking status. jobId is: ' + this.jobId);
            this.activity = 'Checking status...'
            this.checkRetrievalStatus();
        }.bind(this), 1000); 
        this.activity = 'Waiting...'
    }

    waitForDeployment(jobId) {
        setTimeout(function(){ 
            console.log('checking status after wait. jobId is: ' + this.jobId);
            this.activity = 'Checking status...'
            self = this;
            this.checkDeploymentStatus(self);
        }.bind(this), 1000); 
        this.activity = 'Waiting...'
    }

    checkDeploymentStatus(self) {
        console.log('starting to check deploy status');
        checkDeployStatus({ jobId : this.jobId })
        .then(result => {
            console.log('successfully checked deploy job status');
            if (result == 'success'){
                console.log('deployment successful');
             
                self.activity = 'Flow converted successfully. '
                console.log('this.activity is: ' + this.activity);

            } else if (result == 'inprocess') {
                console.log('deployment not complete');
                this.waitForDeployment(this.jobId);
                
              } else  {
                //console.log('not done yet. jobid is: ' + this.jobId);
                 

                console.log ('deployment failed');
                console.log ( result);
                self.activity = result;

                  
            }
        });
 
    }

    checkRetrievalStatus() {
        console.log('starting to check retrieval status');
        checkRetrieveStatus({ jobId : this.jobId })
        .then(result => {
            console.log('successfully checked job status');
            if (result != 'inprocess'){
                console.log('data returned');
                console.log('data is: ' + result);
                this.activity = 'process builder metadata retrieved successfully. '
                console.log('this.activity is: ' + this.activity);
                this.zipFileString = result;
                const attributeChangeEvent = new FlowAttributeChangeEvent('zipFileString', this.zipFileString);
                this.dispatchEvent(attributeChangeEvent);
                
              

                const nextNavigationEvent = new FlowNavigationNextEvent();
                this.dispatchEvent(nextNavigationEvent);
            } else  {
                console.log('retrieval not complete for job id: ' + this.jobId);
                this.waitForRetrieval(this.jobId);
            } 
        })
        .catch(error => {
            console.log('error checking async request.');
            this.error = error;
            //retry endlessly
            console.log('retrying');
            this.waitForRetrieval(this.jobId);
        });
    }

    handleChange(event) {
        this.selectedFlowApiName = event.detail.value;
        const attributeChangeEvent = new FlowAttributeChangeEvent('zipFileString', this.zipFileString);
        this.dispatchEvent(attributeChangeEvent);
    }

}
