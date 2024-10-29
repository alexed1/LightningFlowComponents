import { LightningElement,track,api,wire  } from 'lwc';
import getFolders from '@salesforce/apex/GetFolders.execute';

export default class ReportManagerCore extends LightningElement {

    @api selectedFolderId;
   
    connectedCallback() {
        this.retrieve();
        
    }

    retrieve() {
        console.log('beginning retrieval. folderId is ', this.selectedFolderId);
        getFolders({ 
            selectedFolderId : this.selectedFolderId,
            namedCredential : 'Loopback'  //fix this           
        })
        .then(result => {
            
            console.log('successfully called apex getFolders action');
            console.log('result is: ' + JSON.stringify(result.body));
            //TODO why is result not showing any return values when the apex appears to be passing it down?
             
        })
        .catch(error => {
            console.log('An error occurred on the getFolder call: ' + error);    
            this.error = 'Error: ' + JSON.stringify(error.body.message);
        });
    }


}