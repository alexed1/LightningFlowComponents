import { LightningElement, api } from 'lwc';

export default class DownloadFile extends LightningElement {
    @api url;
    isShowSpinner = true;
    connectedCallback() {
        setTimeout(
            () => {
                this.isShowSpinner = false;
            }, 2000
        );
    }
}