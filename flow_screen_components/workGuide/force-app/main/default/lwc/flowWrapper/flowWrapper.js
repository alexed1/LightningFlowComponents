import {LightningElement, api} from 'lwc';

export default class FlowWrapper extends LightningElement {
    @api width;
    @api height;
    @api flowName;
    @api stepName;
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
                    stepName: this.stepName,
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
        //console.log('calling flow: ' + this.flowName + ' with params: ' + params + ' with origin: ' + origin);
        return this.url + '/apex/flowWrapper?flowname=' + this.flowName +  params+origin;
    }
}