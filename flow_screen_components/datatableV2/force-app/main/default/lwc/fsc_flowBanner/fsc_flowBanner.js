import { api, track,LightningElement } from 'lwc';

export default class FlowBanner extends LightningElement { 

    // Define how you would like any banner lines to look in the CPE
    // Any of these values can be overridden in the calling HTML
    @api bannerStyle = 'padding:0.3rem;background:#36455C;';    //Brand is #16325c, decreasing shades: 2D405C, 36455C, 404B5C
    @api bannerMargin = 'slds-m-top_small slds-m-bottom_xx-small';
    @api bannerClass = 'slds-text-color_inverse slds-text-heading_medium slds-m-bottom_xx-small';
    @api bannerLabel = 'Banner Label';
    @api bannerIcon = 'utility:info'; 
    @api bannerIconSize = 'medium';
    @api bannerVariant = 'bare-inverse';
    @api bannerTitle = 'Info';
    @api bannerAltText = 'Help Text Info';
    @api bannerInfo = 'Modal Information Text';

    @track openModal = false;
    showModal() {
        this.openModal = true;
    }
    closeModal() {
        this.openModal = false;
    }
    
}