import { LightningElement, track, api, wire } from 'lwc';
import { FlowAttributeChangeEvent } from 'lightning/flowSupport';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getKey from '@salesforce/apex/FileUploadImprovedHelper.getKey';
import encrypt from '@salesforce/apex/FileUploadImprovedHelper.encrypt';
import createContentDocLink from '@salesforce/apex/FileUploadImprovedHelper.createContentDocLink';
import deleteContentDoc from '@salesforce/apex/FileUploadImprovedHelper.deleteContentDoc';
import getExistingFiles from '@salesforce/apex/FileUploadImprovedHelper.getExistingFiles';
import updateFileName from '@salesforce/apex/FileUploadImprovedHelper.updateFileName';

export default class FileUpload extends NavigationMixin(LightningElement) {
    @api acceptedFormats;
    @api allowMultiple;
    @api community; // deprecated
    @api communityDetails; // deprecated
    @api contentDocumentIds;
    @api contentVersionIds;
    @api icon;
    @api label;
    @api overriddenFileName;
    @api recordId;
    @api renderExistingFiles;
    @api renderFilesBelow;
    @api required;
    @api requiredMessage;
    @api sessionKey;
    @api uploadedFileNames;
    @api uploadedlabel;
    @api uploadedLabel; // deprecated
    @api visibleToAllUsers;
    
    @track docIds =[];
    @track fileNames = [];
    @track objFiles = [];
    @track versIds = [];

    key;
    @wire(getKey)
    wiredKey({error,data}){
        if(data){
            this.key = data;
        }
        else if (error){
            this.showErrors(this.reduceErrors(error));
        }
    }

    value;
    @wire(encrypt,{recordId: '$recordId', encodedKey: '$key'})
    wiredValue({error,data}){
        if(data){
            this.value = data;
        }
        else if (error){
            this.showErrors(this.reduceErrors(error));
        }
    }

    get bottom(){
        if(this.renderFilesBelow){
            return true;
        }
        else{
            return false;
        }
    }

    connectedCallback(){
        let cachedSelection = sessionStorage.getItem(this.sessionKey);
        if(cachedSelection){
            this.processFiles(JSON.parse(cachedSelection));
        } else if(this.recordId && this.renderExistingFiles) {
            getExistingFiles({recordId: this.recordId})
                .then((files) => {
                    if(files != undefined && files.length > 0){
                        this.processFiles(files);
                    } else {
                        this.communicateEvent(this.docIds,this.versIds,this.fileNames,this.objFiles);
                    }
                })
                .catch((error) => {
                    this.showErrors(this.reduceErrors(error));
                })
        } else {
            this.communicateEvent(this.docIds,this.versIds,this.fileNames,this.objFiles);
        }
    }
    
    handleUploadFinished(event) {
        const files = event.detail.files;

        var objFile;
        var objFiles = [];
        var versIds = [];
        files.forEach(file => {
            var name;
            if(this.overriddenFileName){
                name = this.overriddenFileName.substring(0,255) +'.'+ file.name.split('.').pop();
            } else {
                name = file.name;
            }
            
            objFile = {
                name: name,
                documentId: file.documentId,
                contentVersionId: file.contentVersionId
            }
            objFiles.push(objFile);

            versIds.push(file.contentVersionId);
        })

        if(this.overriddenFileName){
            updateFileName({versIds: versIds, fileName: this.overriddenFileName.substring(0,255)})
                .catch(error => {
                    this.showErrors(this.reduceErrors(error));
                });
        }

        if(this.recordId){
            createContentDocLink({versIds: versIds, encodedKey: this.key, visibleToAllUsers: this.visibleToAllUsers})
                .catch(error => {
                    this.showErrors(this.reduceErrors(error));
                });
        }

        this.processFiles(objFiles);
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

        this.checkDisabled();

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
        event.target.blur();

        const contentVersionId = event.target.dataset.contentversionid;    

        deleteContentDoc({versId: contentVersionId})
            .then(() => {
                let objFiles = this.objFiles;
                let removeIndex;
                for(let i=0; i<objFiles.length; i++){
                    if(contentVersionId === objFiles[i].contentVersionId){
                        removeIndex = i;
                    }
                }

                this.objFiles.splice(removeIndex,1);
                this.docIds.splice(removeIndex,1);
                this.versIds.splice(removeIndex,1);
                this.fileNames.splice(removeIndex,1);

                this.checkDisabled();

                this.communicateEvent(this.docIds,this.versIds,this.fileNames,this.objFiles);
            })
            .catch((error) => {
                this.showErrors(this.reduceErrors(error));
            })
    }

    disabled = false;
    checkDisabled(){
        if(!this.allowMultiple && this.objFiles.length >= 1){
            this.disabled = true;
        } else {
            this.disabled = false;
        }
    }

    communicateEvent(docIds, versIds, fileNames, objFiles){
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

    showErrors(errors){
        const message = new ShowToastEvent({
            title: 'We hit a snag.',
            message: errors.toString(),
            variant: 'error',
        });
        this.dispatchEvent(message);
    }

    reduceErrors(errors) {
        if (!Array.isArray(errors)) {
            errors = [errors];
        }
    
        return (
            errors
                // Remove null/undefined items
                .filter((error) => !!error)
                // Extract an error message
                .map((error) => {
                    // UI API read errors
                    if (Array.isArray(error.body)) {
                        return error.body.map((e) => e.message);
                    }
                    // Page level errors
                    else if (
                        error?.body?.pageErrors &&
                        error.body.pageErrors.length > 0
                    ) {
                        return error.body.pageErrors.map((e) => e.message);
                    }
                    // Field level errors
                    else if (
                        error?.body?.fieldErrors &&
                        Object.keys(error.body.fieldErrors).length > 0
                    ) {
                        const fieldErrors = [];
                        Object.values(error.body.fieldErrors).forEach(
                            (errorArray) => {
                                fieldErrors.push(
                                    ...errorArray.map((e) => e.message)
                                );
                            }
                        );
                        return fieldErrors;
                    }
                    // UI API DML page level errors
                    else if (
                        error?.body?.output?.errors &&
                        error.body.output.errors.length > 0
                    ) {
                        return error.body.output.errors.map((e) => e.message);
                    }
                    // UI API DML field level errors
                    else if (
                        error?.body?.output?.fieldErrors &&
                        Object.keys(error.body.output.fieldErrors).length > 0
                    ) {
                        const fieldErrors = [];
                        Object.values(error.body.output.fieldErrors).forEach(
                            (errorArray) => {
                                fieldErrors.push(
                                    ...errorArray.map((e) => e.message)
                                );
                            }
                        );
                        return fieldErrors;
                    }
                    // UI API DML, Apex and network errors
                    else if (error.body && typeof error.body.message === 'string') {
                        return error.body.message;
                    }
                    // JS errors
                    else if (typeof error.message === 'string') {
                        return error.message;
                    }
                    // Unknown error shape so try HTTP status text
                    return error.statusText;
                })
                // Flatten
                .reduce((prev, curr) => prev.concat(curr), [])
                // Remove empty strings
                .filter((message) => !!message)
        );
    }
}