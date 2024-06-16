/**
 * @description       : 
 * @author            : Josh Dayment
 * @group             : 
 * @last modified on  : 04-29-2024
 * @last modified by  : Josh Dayment
**/
import { LightningElement, api } from 'lwc';
import LightningModal from 'lightning/modal';
import { notifyRecordUpdateAvailable } from 'lightning/uiRecordApi'; // Added by Brian Paul

export default class fsc_modalFlow extends LightningModal {
@api flowNameToInvoke;
@api flowParams = [];
@api flowFinishBehavior;


handleOpenModal(event){    
    if(event.detail.status === 'FINISHED' || event.detail.status === 'FINISHED_SCREEN'){
        const recordId = this.flowParams[0]?.value;
        if(recordId) { 
            notifyRecordUpdateAvailable([{recordId: recordId}]) 
            } // Add by Brian Paul
        this.close('modal closed, flow status is ' + event.detail.status);
    }
}
}
