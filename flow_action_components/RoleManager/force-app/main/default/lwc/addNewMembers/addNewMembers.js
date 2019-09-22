import {LightningElement, api, track, wire} from 'lwc';

import Search from '@salesforce/label/c.Search';
import For from '@salesforce/label/c.For';
import TooManyResultsMessage from '@salesforce/label/c.TooManyResultsMessage';
import NoSearchResultsMessage from '@salesforce/label/c.NoSearchResultsMessage';
import Queues from '@salesforce/label/c.Queues';
import RelatedUsers from '@salesforce/label/c.RelatedUsers';
import PublicGroups from '@salesforce/label/c.PublicGroups';
import Roles from '@salesforce/label/c.Roles';
import Users from '@salesforce/label/c.Users';

import searchMemberByType from '@salesforce/apex/SearchUtils.searchMemberByType';

import {logger, logError} from 'c/lwcLogger';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';

import {
    buttonStyling,
    handleButtonAction,
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
    @api log = false;
    @api recordId;

    //'User, Queue'
    @api availableObjectTypes;
    //Apex class name
    @api managerName;
    //Button labels 'Add, Remove', will determine functions called in apex class
    @api supportedAddCapabilities;
    //Existing members for current record
    @api existingMembers;
    @api supportedButtons;
    @api memberParams;
    @track label = {
        Search,
        TooManyResultsMessage,
        NoSearchResultsMessage,
        For
    };
    @track searchString = '';
    @track selectedType;
    @track searchResults = [];
    @track searchDisabled = false;
    viewEditMembers = [];
    @track isSearchApplied = false;
    source = 'addNewMembers';

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

    refresh() {
        this.dispatchEvent(new CustomEvent('searchrefresh'));
    }

    get columns() {
        return [{
            label: 'Name',
            fieldName: 'label'
        }].concat(generateCapabilityColumns(this.supportedAddCapabilities));
    }

    typeChange(event) {
        this.selectedType = event.detail.value;
        logger(this.log, this.source, `type is now ${this.selectedType}`);
        // clear the results
        this.searchResults = [];
    }

    async actuallySearch() {

        logger(this.log, this.source, 'actually searching!');
        this.searchResults = [];
        this.searchDisabled = true;

        const results =
            await searchMemberByType({
                searchString: this.searchString,
                memberTypes: [this.selectedType]
            });

        logger(this.log, this.source, 'search results', results);

        this.searchResults = results[this.selectedType];
        this.updateRowButtons();
        this.isSearchApplied = true;
        this.searchDisabled = false;
    }

    searchEventHandler(event) {
        const searchString = event.detail.value
            .trim()
            .replace(/\*/g)
            .toLowerCase();

        if (searchString.length <= 1) {
            return;
        }

        this.isSearchApplied = true;
        this.searchString = searchString;
    }

    listenForEnter(event) {
        if (event.code === 'Enter') {
            this.actuallySearch();
        }
    }

    @api updateRowButtons() {
        const newArray = [];

        this.searchResults.forEach(result => {
            newArray.push({
                ...result,
                ...buttonStyling(this.supportedButtons, this.supportedAddCapabilities, result.value, this.existingMembers)
            });
        });

        this.searchResults = newArray;
    }

    get isTableVisible() {
        return (this.searchResults && this.searchResults.length > 0);
    }

    get isNoSearchResultsMessageVisible() {
        return (this.searchResults && this.searchResults.length == 0 && this.searchString && this.isSearchApplied)
    }

    async handleRowAction(event) {
        let actionParams = JSON.stringify({
            'userOrGroupID': event.detail.row.value,
            'recordId': this.recordId,
            'type': this.selectedType,
            'memberParams': this.memberParams
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
        // this.dispatchEvent(
        //     new ShowToastEvent({
        //         message: e.body.message,
        //         variant: 'error'
        //     })
        // );
    }
}
