import { LightningElement, api } from 'lwc';
import LightningModal from 'lightning/modal';

export default class fsc_modalFlow extends LightningModal {
@api flowNameToInvoke;
@api flowParams = [];
@api flowFinishBehavior;


handleOpenModal(event){    
    if(this.flowFinishBehavior == 'NONE' && (event.detail.status === 'FINISHED' || event.detail.status === 'FINISHED_SCREEN')){
        this.close('modal closed, flow status is ' + event.detail.status);
    }
}
closeModal() {
    this.close('modal closed manually');
  }

}

