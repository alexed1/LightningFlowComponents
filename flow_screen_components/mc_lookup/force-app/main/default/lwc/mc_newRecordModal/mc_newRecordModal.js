import { api } from 'lwc';
import LightningModal from 'lightning/modal';


export default class Mc_newRecordModal extends LightningModal {
    @api recordTypeId;
    @api fields;
    @api objectApiName;
    @api modalTitle;

    @api isError;
    @api errorMessage;

    handleSuccess(event) {
        let output = {
            status: 'success',
            id: event.detail.id,
            fields: event.detail.fields
        }
        console.log('modal handleSuccess: ', JSON.stringify(output));
        this.close(output);
    }

    handleCancel(event) {
        this.close('cancel');
    }
}