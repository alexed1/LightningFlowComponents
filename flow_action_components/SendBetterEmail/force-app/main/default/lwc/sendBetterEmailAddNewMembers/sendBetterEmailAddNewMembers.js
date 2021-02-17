/**
 * @description       : addNewMembers.js
 * @group             : unofficialSF
 * @last modified on  : 10-28-2020
 * @last modified by  : Jack D. Pond
 * Modifications Log 
 * Ver		Date			Author			Modification
 * 1.0		07-09-2020		Andrii Kraiev	Initial Version
 * 1.33.2	07-23-2020		Jack D. Pond	Modified for Summer '20 changes
**/
import {LightningElement, api, track, wire} from 'lwc';

import Search from '@salesforce/label/c.sremailSearchMembers';
import For from '@salesforce/label/c.fsc_For';
import TooManyResultsMessage from '@salesforce/label/c.fsc_TooManyResultsMessage';
import NoSearchResultsMessage from '@salesforce/label/c.sremailNoSearchResultsMessage';


export default class sendBetterEmailAddNewMembers extends LightningElement {


    @api singleSelect = false;
    @api name;

    @track existingMembers = [];
    @track searchResults = [];
    @track searchDisabled = false;
    @track isSearchApplied = false;
    @track searchString;
    @track selectedType;
    _customDataStructure;
    _memberTypes;

    @track label = {
        Search,
        TooManyResultsMessage,
        NoSearchResultsMessage,
        For
    };
    settings = {
        selectButton: 'Select',
        reactionConfirm: {label: 'Confirm', variant: 'destructive', value: 'yes'},
        reactionCancel: {label: 'Cancel', variant: 'brand', value: 'no'},
        stringVariablesOption: 'String Variables (or type an address)',
        stringDataType: 'String',
        referenceDataType: 'reference',
    };

    get modalReactions() {
        return [this.settings.reactionConfirm, this.settings.reactionCancel];
    }

    handleModalReactionButtonClick(event) {
        if (event.detail.value === this.settings.reactionConfirm.value) {
            this.dispatchValueChangedEvent(this.searchString);
        }
    }

    showStringVariableModal() {
        if (this.selectedType === this.settings.stringVariablesOption && this.isSearchApplied && (!this.searchResults || !this.searchResults.length)) {
            this.modalAction(true);
        }
    }

    modalAction(isOpen) {
        const existing = this.template.querySelector('c-send-better-email-uc-modal');
        if (existing) {
            if (isOpen) {
                existing.openModal();
            } else {
                existing.closeModal();
            }
        }
    }

    @api get objectType() {
        return this.selectedType;
    }

    set objectType(value) {
        this.selectedType = value;
        if (value) {
            this.actuallySearch(true);
        }
    }

    @api get customDataStructure() {
        return this._customDataStructure;
    }

    set customDataStructure(value) {
        this._customDataStructure = value;
        if (value) {
            this._memberTypes = Object.keys(value).map(curKey => {
                return {label: curKey, value: curKey}
            });

            if (this._memberTypes && this._memberTypes.length && !this.selectedType) {
                this.selectedType = this._memberTypes[0].value;
            }
        }
    }

    @api get value() {
        return this.existingMembers;
    }

    set value(value) {
        if (this.existingMembers !== value) {
            this.existingMembers = value;
            this.actuallySearch(true);
        }
    }

    typeChange(event) {
        this.selectedType = event.detail.value;
        this.searchResults = [];
        this.isSearchApplied = false;
    }

    searchEventHandler(event) {
        const searchString = event.detail.value
            .trim()
            .replace(/\*/g)
            .toLowerCase();

        this.isSearchApplied = false;
        this.searchString = searchString;
    }

    listenForEnter(event) {
        if (event.code === 'Enter') {
            this.actuallySearch(false);
        }
    }

    actuallySearch(preventShowStringVariableModal) {
        if (this._customDataStructure && this.selectedType && this._customDataStructure[this.selectedType]) {
            this.searchDisabled = true;
            let valueFieldName = this._customDataStructure[this.selectedType].valueFieldName;
            let labelFieldName = this._customDataStructure[this.selectedType].labelFieldName;

            this.searchResults = this._customDataStructure[this.selectedType].data.filter(curItem => {
                return curItem[valueFieldName].toLowerCase().includes(this.searchString ? this.searchString.toLowerCase() : '')
            }).map(curItem => {
                return {
                    label: curItem[labelFieldName],
                    value: curItem[valueFieldName],
                    iconName: this.getSelectedIconName(this.existingMembers.includes(curItem[valueFieldName]))
                };
            });

            this.isSearchApplied = true;
            this.searchDisabled = false;
            if (preventShowStringVariableModal !== true) {
                this.showStringVariableModal();
            }
        }
    }


    get isSearchDisabled() {
        return this.searchDisabled || !this.selectedType;
    }

    updateSelected() {
        this.searchResults = this.searchResults.map(curResult => {
            return {...curResult, iconName: this.getSelectedIconName(this.existingMembers.includes(curResult.value))}
        });
    }

    getSelectedIconName(value) {
        return value ? 'utility:check' : ' ';
    }


    get tooManyResults() {
        return this.searchResults.length > 199;
    }

    get columns() {
        return [{
            label: 'Value',
            fieldName: 'value'
        }].concat(this.generateCapabilityColumns(this.settings.selectButton));
    }

    generateCapabilityColumns = (labels) => {
        let labelsArray = labels.replace(/ /g, '').split(',');
        return labelsArray.map(curLabel => {
            return this.getColumnDescriptor(curLabel);
        });
    };

    getColumnDescriptor = (curButtonLabel) => {
        return {
            type: 'button',
            label: curButtonLabel,
            typeAttributes: {
                label: curButtonLabel,
                name: curButtonLabel,
                variant: 'neutral',
                iconName: {fieldName: 'iconName'}
            },
            initialWidth: curButtonLabel.length * 7 + 80
        }
    };


    get isTableVisible() {
        // return true;
        return (this.searchResults && this.searchResults.length > 0);
    }

    get isNoSearchResultsMessageVisible() {
        return (!this.searchDisabled && this.searchResults && this.searchResults.length == 0 && this.isSearchApplied)
    }


    handleRowAction(event) {
        let rowValue = event.detail.row.value;
        if (rowValue && this.singleSelect) {
            if (this.existingMembers.includes(rowValue)) {
                this.existingMembers = [];
            } else {
                this.existingMembers = [rowValue];
            }

        } else {
            if (rowValue && !this.existingMembers.includes(rowValue)) {
                this.existingMembers.push(rowValue);
            } else {
                this.existingMembers = this.existingMembers.filter(curMember => curMember !== rowValue);
            }
        }
        this.dispatchValueChangedEvent();
        this.updateSelected();
    }

    dispatchValueChangedEvent(value) {
        let returnedValue = value;
        let valueType = this.settings.stringDataType;
        if (!returnedValue) {
            returnedValue = this.singleSelect ? (this.existingMembers.length ? this.existingMembers[0] : null) : this.existingMembers;
            valueType = this.settings.referenceDataType;
        }

        const valueChangedEvent = new CustomEvent('valuechanged', {
            detail: {
                name: this.name,
                newValue: returnedValue,
                newValueType: valueType,
                newValueObjectType: this.selectedType
            }
        });
        this.dispatchEvent(valueChangedEvent);
    }

}