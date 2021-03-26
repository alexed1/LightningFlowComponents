import { LightningElement, track, api } from 'lwc';
 
export default class FileUpload extends LightningElement {
    @api recordId;
    @api label;
    @api AcceptedFileFormats;
    @api icon;
    @api contentDocumentIds;
    @track lstAllFiles = [];
   
   
 
    get acceptedFormats() {
        return ['.pdf','.png','.jpg', '.docx','.doc', '.csv','.xlsx'];
    }
 
    handleUploadFinished(event) {
        // Get the list of uploaded files
        const lstUploadedFiles = event.detail.files;
        lstUploadedFiles.forEach(fileIterator => this.lstAllFiles.push(fileIterator.name));
        
        

    }
}
