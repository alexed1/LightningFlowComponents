import {LightningElement, api} from 'lwc';
import {FlowAttributeChangeEvent} from 'lightning/flowSupport';

export default class LookupCpe extends LightningElement {

    _masterLabel;
    _objectName;
    _outputWhichValue;
    _displayWhichField;

    @api get masterLabel() {
        return this._masterLabel;
    }

    set masterLabel(value) {
        this._masterLabel = value;
    }

    @api get objectName() {
        return this._objectName;
    }

    set objectName(value) {
        this._objectName = value;
    }

    @api get displayWhichField() {
        return this._displayWhichField;
    }

    set displayWhichField(value) {
        this._displayWhichField = value;
    }

    @api get outputWhichValue() {
        return this._outputWhichValue;
    }

    set outputWhichValue(value) {
        this._outputWhichValue = value;
    }

    labels = {
        lookupWhichObject: 'Lookup which Object?',
        displayWhichField: 'Display which Field?',
        outputWhichField: 'Output which Field?',
        masterLabel: 'Master Label'
    };

    handleDisplayFieldSelected(event) {
        this._objectName = event.detail.objectType;
        this._displayWhichField = event.detail.fieldName;
        this.handleSelectionChange(['objectName', 'displayWhichField']);
    }

    handleOutputFieldSelected(event) {
        this._outputWhichValue = event.detail.fieldName;
        this.handleSelectionChange(['outputWhichValue']);
    }

    handleMasterLabelChanged(event) {
        this._masterLabel = event.detail.value;
        this.handleSelectionChange(['masterLabel']);
    }

    handleSelectionChange(attributes) {
        if (attributes && attributes.length) {
            attributes.forEach(curAttributeName => {
                const valueChangeEvent = new FlowAttributeChangeEvent('curAttributeName', this[curAttributeName]);
                this.dispatchEvent(valueChangeEvent);
            });
        }
    }
}