import {LightningElement, api, track, wire} from 'lwc';

import Search from '@salesforce/label/c.Search';
import For from '@salesforce/label/c.For';
import TooManyResultsMessage from '@salesforce/label/c.TooManyResultsMessage';
import Queues from '@salesforce/label/c.Queues';
import RelatedUsers from '@salesforce/label/c.RelatedUsers';
import PublicGroups from '@salesforce/label/c.PublicGroups';
import Roles from '@salesforce/label/c.Roles';
import Users from '@salesforce/label/c.Users';

import USER_NAME_FIELD from '@salesforce/schema/User.Name';
import GROUP_NAME_FIELD from '@salesforce/schema/Group.Name';

import searchMemberByType from '@salesforce/apex/fbc_SearchUtils.searchMemberByType';

import getSingleMembersByTypeAndId from '@salesforce/apex/fbc_SearchUtils.getSingleMembersByTypeAndId';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
//import {logger, logError} from 'fbc/lwcLogger';

import {
    generateCapabilityColumns,
    splitValues
} from 'c/buttonUtils';


const typeMapping = {
    Group: PublicGroups,
    Role: Roles,
    User: Users,
    Queue: Queues,
    RelatedUsers: RelatedUsers
};

export default class addNewMembers extends LightningElement {
    @api notifyAssignee = false;
    @api memberId;
    @api availableObjectTypes;
    @api supportedAddCapabilities;
    @api notifyAssigneeLabel;

    @track memberData;
    @track showMemberSelect = false;
    @track label = {
        Search,
        TooManyResultsMessage,
        For
    };
    @track searchString = '';
    @track selectedType;
    @track searchResults = [];
    @track searchDisabled = false;
    source = 'ownerSetter';

    @wire(getSingleMembersByTypeAndId, {type: '$selectedType', id: '$memberId'})
    _getSingleMembersByTypeAndId({error, data}) {
        if (error) {
            console.log(error.body.message);
        } else if (data) {
            this.memberData = data[this.memberId];
        }
    }

    connectedCallback() {
        if (this.availableObjectTypes && this.availableObjectTypes.length > 0) {
            this.selectedType = splitValues(this.availableObjectTypes)[0];
        }
    }

    get objectTypes() {
        return splitValues(this.availableObjectTypes).map(curTypeName => {
            return this.getTypeDescriptor(curTypeName);
        });
    }

    getTypeDescriptor(typeName) {
        return {value: typeName, label: typeMapping[typeName]};
    }

    get tooManyResults() {
        return this.searchResults.length > 199;
    }

    get columns() {
        return [{
            label: 'Name',
            fieldName: 'label'
        }].concat(generateCapabilityColumns(this.supportedAddCapabilities));
    }

    get showNotifyAssignee() {
        return this.selectedType === 'User';
    }

    get selectedMemberName() {
        if (this.memberData) {
            return this.memberData.Name;
        } else {
            return null;
        }
    }

    handleTypeChange(event) {
        this.selectedType = event.detail.value;
        this.searchResults = [];
    }

    async actuallySearch() {
        this.searchResults = [];
        this.searchDisabled = true;

        const results =
            await searchMemberByType({
                searchString: this.searchString,
                memberTypes: [this.selectedType]
            });
        this.searchResults = results[this.selectedType];

        this.searchDisabled = false;
    }

    searchEventHandler(event) {
        if (event.detail.value) {
            const searchString = event.detail.value
                .trim()
                .replace(/\*/g)
                .toLowerCase();

            if (searchString.length <= 1) {
                return;
            }

            this.searchString = searchString;
        }
    }

    listenForEnter(event) {
        if (event.code === 'Enter') {
            this.actuallySearch();
        }
    }

    handleRowAction(event) {
        const memberRefreshedEvt = new CustomEvent('membersrefreshed', {
            bubbles: true, detail: {
                memberId: event.detail.row.value,
                notifyAssignee: (this.selectedType === 'User' ? this.notifyAssignee : false),
            }
        });
        this.dispatchEvent(memberRefreshedEvt);
    }

    toastTheError(e, errorSource) {
        //logError(this.log, this.source, errorSource, e);
        this.dispatchEvent(
            new ShowToastEvent({
                message: e.body.message,
                variant: 'error'
            })
        );
    }

    toggleMemberSelect() {
        this.showMemberSelect = !this.showMemberSelect;
    }

    handleNotifyAssigneeChange(event) {
        this.notifyAssignee = event.target.checked === true;
    }
}
