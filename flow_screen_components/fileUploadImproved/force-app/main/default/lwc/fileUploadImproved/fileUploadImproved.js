import { LightningElement, track, api, wire } from 'lwc';
import { FlowAttributeChangeEvent } from 'lightning/flowSupport';
import { NavigationMixin } from 'lightning/navigation';
import { deleteRecord } from 'lightning/uiRecordApi';
import getKey from '@salesforce/apex/FileUploadImprovedHelper.getKey';
import encrypt from '@salesforce/apex/FileUploadImprovedHelper.encrypt';
import createContentDocLink from '@salesforce/apex/FileUploadImprovedHelper.createContentDocLink';
import deleteContentDoc from '@salesforce/apex/FileUploadImprovedHelper.deleteContentDoc';
import getExistingFiles from '@salesforce/apex/FileUploadImprovedHelper.getExistingFiles';

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
    @api uploadedLabel; // deprecated
    
    @track docIds =[];
    @track fileNames = [];
    @track objFiles = [];
    @track versIds = [];

    recordIdToUse;
    @api
    get communityDetails(){
        if(this.community != true){
            this.recordIdToUse = this.recordId;
        }
        return this.recordIdToUse;
    }

    key;
    @wire(getKey) key;

    value;
    @wire(encrypt,{recordId: '$recordId', encodedKey: '$key.data'}) value;

    connectedCallback(){
        let cachedSelection = sessionStorage.getItem(this.sessionKey);
        if(cachedSelection){
            console.log('in cached selection');
            this.processFiles(JSON.parse(cachedSelection));
            // this.objFiles = JSON.parse(cachedSelection);

            // this.objFiles.forEach((file) => {
            //     this.docIds.push(file.id);
            //     this.versIds.push(file.versid);
            //     this.fileNames.push(file.name);
            // });
            
            // this.communicateEvent(this.docIds,this.versIds,this.fileNames,this.objFiles);
        }
        else {
            getExistingFiles({recordId: this.recordId})
                .then((files) => {
                    if(files != undefined && files.length > 0){
                        console.log('existing files processing')
                        this.processFiles(files);
                    }
                })
        }
    }
    
    handleUploadFinished(event) {
        const files = event.detail.files;

        this.processFiles(files);

        if(this.community === true && this.value.data){
            console.log('inside community create link');
            console.log(this.versIds);
            console.log(this.key.data);
            createContentDocLink({versIds: this.versIds, encodedKey: this.key.data});
        }
        
        
    }

    processFiles(files){
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
                documentId: file.documentId,
                contentVersionId: file.contentVersionId
            };
            this.objFiles.push(objFile);
            this.docIds.push(file.documentId);
            this.versIds.push(file.contentVersionId);
            this.fileNames.push(file.name);
        });

        this.communicateEvent(this.docIds,this.versIds,this.fileNames,this.objFiles);

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
        console.log('documentId - '+event.target.dataset.documentid);
        console.log('contentVersionId - '+event.target.dataset.contentversionid);

        const documentId = event.target.dataset.documentid;
        const contentVersionId = event.target.dataset.contentversionid;
        
        console.log(documentId);
        if(documentId){
            console.log('in delete docid');
            deleteRecord(documentId);
        } else {
            deleteContentDoc({versId: contentVersionId});
        }

        let objFiles = this.objFiles;
        let removeIndex;
        for(let i=0; i<objFiles.length; i++){
            if(contentVersionId === objFiles[i].contentVersionId){
                removeIndex = i;
            }
        }

        console.log(removeIndex);

        console.log(this.objFiles);
        console.log(this.docIds);
        console.log(this.versIds);
        console.log(this.fileNames);
        console.log('remove from objfiles')

        try {
            this.objFiles.splice(removeIndex,1);
        } catch (error) {
            console.log(error);
        }
        
        
        console.log('remove from docids')
        this.docIds.splice(removeIndex,1);

        console.log('remove from versids')
        this.versIds.splice(removeIndex,1);

        console.log('remove from filenames')
        this.fileNames.splice(removeIndex,1);

        this.communicateEvent(this.docIds,this.versIds,this.fileNames,this.objFiles);
    }    

    communicateEvent(docIds, versIds, fileNames, objFiles){
        console.log('in communicate event')
        this.dispatchEvent(new FlowAttributeChangeEvent('contentDocumentIds', docIds));
        this.dispatchEvent(new FlowAttributeChangeEvent('contentVersionIds', versIds));
        this.dispatchEvent(new FlowAttributeChangeEvent('uploadedFileNames', fileNames));

        sessionStorage.setItem(this.sessionKey, JSON.stringify(objFiles));
    }

    openFile(event) {
        const docId = event.target.dataset.docid;
        event.preventDefault();
        this[NavigationMixin.Navigate]({
            type: 'standard__namedPage',
            attributes: {
                pageName: 'filePreview'
            },
            state: {
                recordIds: docId
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
            return { isValid: true };
        }
    }
}