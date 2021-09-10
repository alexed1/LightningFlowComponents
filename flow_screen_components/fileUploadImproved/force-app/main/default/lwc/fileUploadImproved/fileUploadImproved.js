import { LightningElement, track, api, wire } from 'lwc';
import { FlowAttributeChangeEvent } from 'lightning/flowSupport';
import { NavigationMixin } from 'lightning/navigation';
import { deleteRecord } from 'lightning/uiRecordApi';
import getKey from '@salesforce/apex/FileUploadImprovedHelper.getKey';
import encrypt from '@salesforce/apex/FileUploadImprovedHelper.encrypt';
import createContentDocLink from '@salesforce/apex/FileUploadImprovedHelper.createContentDocLink';

export default class FileUpload extends NavigationMixin(LightningElement) {
    @api acceptedFormats;
    @api allowMultiple;
    @api community;
    @api contentDocumentIds;
    @api contentVersionIds;
    @api icon;
    @api label;
    @api recordId;
    @api required;
    @api requiredMessage;
    @api sessionKey;
    @api uploadedFileNames;
    @api uploadedlabel;
    
    @track docIds =[];
    @track fileNames = [];
    @track objFiles = [];
    @track versIds = [];

    recordIdToUse = '';
    @api
    get communityDetails(){
        if(this.community != true){
            this.recordIdToUse = this.recordId;
        }
        return this.recordIdToUse;
    }

    @api
    get uploadedLabel(){
        return this.uploadedlabel;
    }

    get sessionStorageKey() {
        return this.sessionKey;
    }

    key;
    @wire(getKey) key;

    value = '';
    @wire(encrypt,{recordId: '$recordId', encodedKey: '$key.data'})
    wiredEncryption({ data }) {
        if(this.community === true){
            this.value = data;
        }
    }

    connectedCallback(){
        let cachedSelection = sessionStorage.getItem(this.sessionStorageKey);
        if(cachedSelection){
            this.objFiles = JSON.parse(cachedSelection);

            this.objFiles.forEach((file) => {
                this.docIds.push(file.id);
                this.versIds.push(file.versid);
                this.fileNames.push(file.name);
            });
            
            this.communicateEvent(this.docIds,this.versIds,this.fileNames);
        }
    }
    
    handleUploadFinished(event) {
        const files = event.detail.files;

        var objFile;
        files.forEach(file => {
            var filetype;
            if(this.icon == null){
                filetype = getIconSpecs(file.name.split('.').pop());
            }
            else{
                filetype = this.icon;
            }
            objFile = {
                name: file.name,
                filetype: filetype,
                id: file.documentId,
                versid: file.contentVersionId
            };
            this.objFiles.push(objFile);
            this.docIds.push(file.documentId);
            this.versIds.push(file.contentVersionId);
            this.fileNames.push(file.name);
        });

        this.communicateEvent(this.docIds,this.versIds,this.fileNames);

        sessionStorage.setItem(this.sessionStorageKey, JSON.stringify(this.objFiles));

        if(this.community === true){
            createContentDocLink({versIds: this.versIds, encodedKey: this.key.data});
        }
        
        function getIconSpecs(docType){
            switch(docType){
                case 'csv':
                    return 'doctype:csv';
                case 'pdf':
                    return 'doctype:pdf';
                case 'pps':
                case 'ppt':
                case 'pptx':
                    return 'doctype:ppt';
                case 'xls':
                case 'xlsx':
                    return 'doctype:excel';
                case 'doc':
                case 'docx':
                    return 'doctype:word';
                case 'txt':
                    return 'doctype:txt';
                case 'png':
                case 'jpeg':
                case 'jpg':
                case 'gif':
                    return 'doctype:image';
                default:
                    return 'doctype:unknown';
            }
        }
    }
    
    deleteDocument(event){
        const recordId = event.target.dataset.recordid;
        deleteRecord(recordId);
        
        let objFiles = this.objFiles;
        let removeIndex;
        for(let i=0; i<objFiles.length; i++){
            if(recordId === objFiles[i].id){
                removeIndex = i;
            }
        }

        this.objFiles.splice(removeIndex,1);
        this.docIds.splice(removeIndex,1);
        this.versIds.splice(removeIndex,1);
        this.fileNames.splice(removeIndex,1);

        this.communicateEvent(this.docIds,this.versIds,this.fileNames);

        sessionStorage.setItem(this.sessionStorageKey, JSON.stringify(this.objFiles));

    }

    communicateEvent(docIds, versIds, fileNames){
        this.dispatchEvent(new FlowAttributeChangeEvent('contentDocumentIds', docIds));
        this.dispatchEvent(new FlowAttributeChangeEvent('contentVersionIds', versIds));
        this.dispatchEvent(new FlowAttributeChangeEvent('uploadedFileNames', fileNames));
    }

    openFile(event) {
        const recordId = event.target.dataset.recordid;
        event.preventDefault();
        this[NavigationMixin.Navigate]({
            type: 'standard__namedPage',
            attributes: {
                pageName: 'filePreview'
            },
            state: {
                recordIds: recordId
            }
        });
    }

    @api
    validate(){
        if(this.docIds.length === 0 && this.required === true){ 
            var errorMessage;
            if(this.requiredMessage == null){
                errorMessage = 'Upload at least one file.';
            }
            else{
                errorMessage = this.requiredMessage;
            }
            return { 
                isValid: false,
                errorMessage: errorMessage
             }; 
        } 
        else {
            return { 
                isValid: true
            };
        }
    }
}