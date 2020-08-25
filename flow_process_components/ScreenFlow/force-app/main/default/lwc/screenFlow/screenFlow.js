import {LightningElement, api} from 'lwc';

export default class ScreenFlow extends LightningElement {
    @api width;
    @api height;
    @api flowName;
    @api name;
    @api flowParams;
    url;

    connectedCallback() {
        window.addEventListener("message", (event) => {
            if (event.data.flowOrigin !== this.url) {
                return;
            }
            const moveEvt = new CustomEvent('flowstatuschange', {
                detail: {
                    flowStatus: event.data.flowStatus,
                    flowParams: event.data.flowParams,
                    name: this.name,
                    flowName: this.flowName
                }
            });
            this.dispatchEvent(moveEvt);
        });
        let sfIdent = 'force.com';
        this.url = window.location.href.substring(0, window.location.href.indexOf(sfIdent) + sfIdent.length);
    }

    get fullUrl() {
        let params = (this.flowParams ? '&params=' + encodeURI(this.flowParams) : '');
        let origin = (this.url ? '&origin=' + encodeURI(this.url) : '');
        return this.url + '/apex/screenFlow?flowname=' + this.flowName +  params+origin;
    }
}