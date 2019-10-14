import {LightningElement, api, track} from 'lwc';
import NoMembersAddedMessage from '@salesforce/label/c.NoMembersAddedMessage';
import {
    buttonStyling,
    generateCapabilityColumns,
    handleButtonAction
} from 'c/buttonUtils';

import {logger, logError} from 'c/lwcLogger';


export default class ViewEditMembers extends LightningElement {
    @api recordId;
    @api supportedEditCapabilities;
    @api managerName;
    @api existingMembers;
    @api supportedButtons;
    @api memberData;
    @api objectData;
    @api typeMapping;

    labels = {
        NoMembersAddedMessage: NoMembersAddedMessage
    };

    @api customTypes;

    // call this when you know the member table is out of sync
    @api refresh() {
        this.dispatchEvent(new CustomEvent('searchrefresh'));
    }

    //TODO: Implement ability to navigate to record on click
    get tableData() {
        const newArray = [];
        if (this.existingMembers) {
            this.existingMembers.forEach(result => {
                newArray.push({
                    ...this.setLabels(result),
                    ...buttonStyling(this.supportedButtons, this.supportedEditCapabilities, result.recordId, this.existingMembers)
                });
            });

        }
        return newArray;
    }

    get isNoResults() {
        if (!this.tableData || this.tableData.length == 0) {
            return true
        } else {
            return false;
        }
    }

    setLabels(result) {
        if (this.customTypes.hasOwnProperty(result.record.Type__c)) {
            return {
                ...result,
                label: this.objectData.fields[result.recordId].label.replace(' ID', '')
            }
        } else {
            return result;
        }

    }

    get columns() {
        return [{
            label: 'Name',
            fieldName: 'label'
        }].concat(generateCapabilityColumns(this.supportedEditCapabilities));
    }

    async handleRowAction(event) {

        //logger(this.log, this.source, 'row action called from datatable', event.detail);
        let actionParams = JSON.stringify({
            'userOrGroupID': event.detail.row.recordId,
            'recordId': this.recordId
        });

        try {
            await handleButtonAction(
                event.detail.action.name,
                this.managerName,
                actionParams
            );
            this.refresh();
        } catch (e) {
            this.toastTheError(e, 'handleButtonAction');
        }
    }

    toastTheError(e, errorSource) {
        logError(this.log, this.source, errorSource, e);
        const dataErrorEvent = new CustomEvent('dataerror', {
            bubbles: true, detail: {
                title: 'Error',
                message: e.body.message,
                variant: 'error',
                autoClose: true
            }
        });

        this.dispatchEvent(dataErrorEvent);
    }
}
