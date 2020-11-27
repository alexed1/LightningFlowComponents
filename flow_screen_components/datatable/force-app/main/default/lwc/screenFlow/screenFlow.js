import {LightningElement, api} from 'lwc';
// import {FlowAttributeChangeEvent, FlowNavigationNextEvent} from 'lightning/flowSupport';

export default class ScreenFlow extends LightningElement {
    @api width;
    @api height;
    @api flowName;
    @api name;
    @api flowParams;
    @api saveParams;
    saveStatus;
    url;

    @api    // Flow Navigation Actions
    availableActions = [];

    connectedCallback() {
        window.addEventListener("message", (event) => {     // screenFlow.page does a postMessage whenever the flow status changes      
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
            this.saveStatus = event.data.flowStatus;
            this.saveParams = event.data.flowParams;
            this.dispatchEvent(moveEvt);
        });
        let sfIdent = 'force.com';
        this.url = window.location.href.substring(0, window.location.href.indexOf(sfIdent) + sfIdent.length);
    }

    disconnectedCallback() { 
        const exitEvt = new CustomEvent('flowstatuschange', {
            detail: {
                flowStatus: this.saveStatus,
                flowParams: this.saveParams,
                name: this.name,
                flowName: this.flowName,
                flowExit: true
            }
        });      
        this.dispatchEvent(exitEvt);      
    }

    // handleGoNext() {
    //     // check if NEXT is allowed on this screen
    //     if (this.availableActions.find(action => action === 'NEXT')) {
    //         // navigate to the next screen
    //         const navigateNextEvent = new FlowNavigationNextEvent();
    //         this.dispatchEvent(navigateNextEvent);
    //     }
    // }

    get fullUrl() {
        let params = (this.flowParams ? '&params=' + encodeURI(this.flowParams) : '');
        let origin = (this.url ? '&origin=' + encodeURI(this.url) : '');
        return this.url + '/apex/screenFlow?flowname=' + this.flowName +  params+origin;
    }
}