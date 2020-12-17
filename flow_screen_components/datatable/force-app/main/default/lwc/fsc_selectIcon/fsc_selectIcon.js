import { api, track, LightningElement } from 'lwc';
import {FlowAttributeChangeEvent, FlowNavigationNextEvent} from "lightning/flowSupport";

export default class Fsc_selectIcon extends LightningElement {

    @api 
    selectTypeLabel = 'Select the Icon Type';

    @api
    types = [
        {
            name: 'Utility',
            icon: 'utility:einstein',
            size: 'large',
            desc: 'Utility icons are simple, single-color glyphs that identify labels and actions across form factors'
        },
        {
            name: 'Doctype',
            icon: 'doctype:excel',
            size: 'large',
            desc: 'Doctype icons represent document file formats'
        },
        {
            name: 'Standard',
            icon: 'standard:case',
            size: 'large',
            desc: 'Standard and Custom Object icons represent Salesforce entities and objects (Account, Case, etc.)'
        },
        {
            name: 'Custom',
            icon: 'custom:custom61',
            size: 'large',
            desc: 'Standard and Custom Object icons represent Salesforce entities and objects (Account, Case, etc.)'
        },
        {
            name: 'Action',
            icon: 'action:flow',
            size: 'medium',
            desc: 'Action icons are for use with quick actions on touch-screen devices'
        }
    ];

    @api
    gridClassType = 'slds-form-element__control slds-grid slds-gutters_medium slds-wrap slds-grid_vertical-align-center';

    @api
    gridStyleType = 'width:52rem';

    @api
    columnClassType = 'slds-visual-picker slds-visual-picker_vertical slds-col slds-size_1-of-2';

    @api
    get radioGroupType() {
        return "RGT-" + this.selectTypeLabel + "_RGT";
    }

    set radioGroupType(value) {
        this.radioGroupType = value;
    }

    @api
    get type() {
        return this.selectedType;
    }

    set type(value) {
        this.selectedType = value;
        this.iconSize = (value == 'Action') ? 'small' : 'large';
    }

    @api iconSize;

    handleChangeType(event) {
        this.selectedType = event.target.value;
        this.dispatchFlowAttributeChangedEvent('type', this.selectedType);
    }

    dispatchFlowAttributeChangedEvent(attributeName, attributeValue) {
        const attributeChangeEvent = new FlowAttributeChangeEvent(
            attributeName,
            attributeValue
        );
        this.dispatchEvent(attributeChangeEvent);
    }

}