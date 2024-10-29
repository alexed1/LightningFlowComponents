import { LightningElement, api } from 'lwc';
export default class IFrameforFlowscreens extends LightningElement {
    @api frameURL;
    @api width;
    @api height;
    @api borderWidth;
}
