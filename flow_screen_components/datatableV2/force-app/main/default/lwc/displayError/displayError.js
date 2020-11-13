import { api, LightningElement } from 'lwc';

export default class DisplayError extends LightningElement { 

    @api isError = false;
    @api errorMessage = 'Error!';

}