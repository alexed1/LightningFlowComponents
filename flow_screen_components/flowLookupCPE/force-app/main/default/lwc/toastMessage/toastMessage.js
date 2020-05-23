import {LightningElement, api, track} from 'lwc';

export default class MiscNotification extends LightningElement {
    @track title;
    @track message;
    @track variant = 'error';
    @track autoCloseTime = 3000;
    @track autoClose = false;

    @api
    showCustomNotice(event) {
        let data = event.detail;
        this.title = data.title;
        this.message = data.message;
        this.variant = data.variant;
        this.autoClose = data.autoClose;

        const toastModel = this.template.querySelector('[data-id="toastModel"]');
        toastModel.className = 'slds-show';

        if (this.autoClose)
            setTimeout(() => {
                const toastModel = this.template.querySelector('[data-id="toastModel"]');
                toastModel.className = 'slds-hide';
            }, this.autoCloseTime);
    }

    closeModel() {
        const toastModel = this.template.querySelector('[data-id="toastModel"]');
        toastModel.className = 'slds-hide';
    }

    get mainDivClass() {
        return 'slds-notify slds-notify_toast slds-theme_' + this.variant;
    }

    get messageDivClass() {
        return 'slds-icon_container slds-icon-utility-' + this.variant + ' slds-icon-utility-success slds-m-right_small slds-no-flex slds-align-top';
    }

    get iconName() {
        return 'utility:' + this.variant;
    }
}