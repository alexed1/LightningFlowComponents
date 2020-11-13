import { api, track, LightningElement } from 'lwc';

export default class FlowBanner extends LightningElement { 

    // Any of these values can be overridden in the calling HTML
    // Define how you would like the banner lines to look in the CPE
    @api bannerPadding = '0.3rem';
    @api bannerColor = '#4C6E96';   //Brand is #1B5297, decreasing shades: 346096, 4C6E96, 657B96  
    @api bannerMargin = 'slds-m-top_small slds-m-bottom_xx-small';
    @api bannerClass = 'slds-text-color_inverse slds-text-heading_medium';
    @api modalHeaderColor = '#657B96';

    // Info Icon Attributes
    @api bannerIcon = 'utility:info'; 
    @api bannerIconSize = 'medium';
    @api bannerVariant = 'bare-inverse';
    @api bannerTitle = 'Info';
    @api bannerAltText = 'Help Text Info';
    
    // Banner Label and Help Text passed from the calling CPE
    @api bannerLabel = 'Banner Label';
    @api bannerInfo = 
        [
            {label: 'Attribute #1 Label', helpText: 'Attribute #1 Helptext'},
            {label: 'Attribute #2 Label', helpText: 'Attribute #2 Helptext'},
        ];

    @api
    get bannerStyle() { 
        return 'padding:' + this.bannerPadding + ';background:' + this.bannerColor + ';';
    }

    @track openBannerModal = false;

    // Modal Header Color
    renderedCallback() {
        document.documentElement.style.setProperty('--headerColor', this.modalHeaderColor);
        const customProperty = getComputedStyle(document.documentElement)
        .getPropertyValue('--headerColor');
    }

    // Keep the ESC key from also closing the CPE
    connectedCallback() { 
        this.template.addEventListener('keydown', event => {
            var keycode = event.code;
            if(keycode == 'Escape'){
                this.openBannerModal = false;
                event.preventDefault();
                event.stopImmediatePropagation();
            }
        }, true);
    }

    showModal() {
        this.openBannerModal = true;
    }
    closeModal() {
        this.openBannerModal = false;
    }
    
}