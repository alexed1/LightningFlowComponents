import {LightningElement, api, track} from 'lwc';

export default class ConfigEditorLwc extends LightningElement {
    @api values;
    @api property;
    @api flowContext;

    @track _flowContext;

    @api validate() {
        return [];
    }
}