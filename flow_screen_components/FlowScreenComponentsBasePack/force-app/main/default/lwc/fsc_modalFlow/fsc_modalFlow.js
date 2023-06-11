/**
 * @description       : 
 * @author            : Josh Dayment
 * @group             : 
 * @last modified on  : 05-31-2023
 * @last modified by  : Josh Dayment
**/
import { LightningElement, api } from 'lwc';
import LightningModal from 'lightning/modal';

export default class fsc_modalFlow extends LightningModal {
@api flowNameToInvoke;
@api flowParams = [];
@api flowFinishBehavior;


handleOpenModal(event){    
    if(event.detail.status === 'FINISHED' || event.detail.status === 'FINISHED_SCREEN'){
        this.close('modal closed, flow status is ' + event.detail.status);
    }
}
}