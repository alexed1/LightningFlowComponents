import {LightningElement, api, track, wire} from 'lwc';
import {getObjectInfo} from "lightning/uiObjectInfoApi";
import {
    flashElement,
    buildOptions,
    getErrorMessage,
    showToast
} from 'c/fieldSelectorUtils';

export default class FieldSelector extends LightningElement {
    @api fieldSelectorLabel;
    @api fieldSelectorStyle;
    @track _options = [];
    _selectedFieldPath;
    _objectType;
    _selectedObjectType;

    labels = {
        buttonAddAll: 'Add All',
        buttonRemoveAll: 'Remove All'
    };

    @api
    get objectType() {
        return this._objectType;
    }

    set objectType(value) {
        this._objectType = value;
        this._selectedObjectType = value;
    }

    @wire(getObjectInfo, {objectApiName: '$_selectedObjectType'})
    _getObjectInfo({error, data}) {
        if (error) {
            showToast('Error', getErrorMessage(error), 'error');
        } else if (data) {
            let tempOptions = buildOptions(data.fields);
            if (tempOptions && tempOptions.length) {
                this._options = tempOptions.sort((a, b) => (a.label > b.label) ? 1 : ((b.label > a.label) ? -1 : 0));
            }
        }
    }

    handleSetSelectedRecord(event) {
        if (event.currentTarget.dataset) {
            this.dispatchFieldSelectedEvent(this.formatValue(this._selectedFieldPath, event.currentTarget.dataset.value));
            this.clearSelected();
        }
    }

    clearSelected() {
        this._selectedObjectType = this._objectType;
        this._selectedFieldPath = null;
    }

    dispatchFieldSelectedEvent(value) {
        const filterChangedEvent = new CustomEvent('fieldselected', {
            detail: {value: value}
        });
        this.dispatchEvent(filterChangedEvent);
    }

    handleRemoveAll(event) {
        this.dispatchEvent(new CustomEvent('removeall', {}));
    }

    handleAddAll(event) {
        this.dispatchEvent(new CustomEvent('addall', {}));
    }

    handleOpenObject(event) {
        this._selectedFieldPath = (this._selectedFieldPath ? this._selectedFieldPath + '.' : '') + event.currentTarget.dataset.optionValue;
        this._selectedObjectType = event.currentTarget.dataset.objectType;
        flashElement(this, '.custom-path', 'custom-blue-flash', 2, 400);
    }

    formatValue(path, val) {
        return (path ? path + '.' : '') + val;
    }

    handleMouseDown(event) {
        let target = event.currentTarget;
        target.classList.add('clicked-field');
    }

    handleMouseUp(event) {
        let target = event.currentTarget;
        target.classList.remove('clicked-field');
    }

    get formattedPath() {
        if (this._selectedFieldPath) {
            return this._selectedFieldPath.replace(/\./g, ' > ');
        }
    }
}