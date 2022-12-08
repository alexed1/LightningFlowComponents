import { LightningElement, api, track, wire } from 'lwc';
import { FlowAttributeChangeEvent } from 'lightning/flowSupport';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import search from '@salesforce/apex/fsc_lookupController.search';
import getRecentlyViewed from '@salesforce/apex/fsc_lookupController.getRecentlyViewed';
import getRecordsFromIds from '@salesforce/apex/fsc_lookupController.getRecordsFromIds';

const DEFAULTS = {
    NUM_RECENTLY_VIEWED: 5,
    DEBOUNCE_DELAY: 200
}

const ACTIONS = {
    NEW_RECORD: {
        label: 'New Record',
        value: 'newRecord',
        icon: 'utility:add',
        isAction: true
    }
}

export default class Fsc_lookup extends NavigationMixin(LightningElement) {
        /* PUBLIC PROPERTIES */
        @api objectName;

        @api label = 'Select Record';
        @api required;
        @api messageWhenValueMissing = 'Please select a record';
        @api allowMultiselect;
        @api publicClass;
        @api publicStyle;
        @api debounceDelay = DEFAULTS.DEBOUNCE_DELAY;
        @api get fieldsToSearch() {
            return this._fieldsToSearch;
        };
        set fieldsToSearch(value) {
            console.log('in set fieldsToSearch');
            console.log(value);
            this._fieldsToSearch = value;
            this.visibleFields_ToSearchNames = JSON.parse(value).map(field => field.name).join();
            this.fieldCollection_toSearch = JSON.parse(value).map(field => field.name);
            console.log('this.fieldCollection_toSearch: ' + JSON.stringify(this.fieldCollection_toSearch));
            console.log('this.visibleFields_ToSearchNames: ' + JSON.stringify(this.visibleFields_ToSearchNames));
        }
        @track _fieldsToSearch;
        @api visibleFields_ToSearchNames;
        @api fieldCollection_toSearch = [];

        @api get fieldsToDisplay() {
            return this._fieldsToDisplay;
        };
        set fieldsToDisplay(value) {
            console.log('in set fieldsToDisplay');
            console.log(value);
            this._fieldsToDisplay = value;
            this.visibleFields_ToDisplayNames = JSON.parse(value).map(field => field.name).join();
            this.fieldCollection_toDisplay = JSON.parse(value).map(field => field.name);
            console.log('this.fieldCollection_toDisplay: ' + JSON.stringify(this.fieldCollection_toDisplay));
            console.log('this.visibleFields_ToDisplayNames: ' + JSON.stringify(this.visibleFields_ToDisplayNames));
        }
        @track _fieldsToDisplay;
        @api visibleFields_ToDisplayNames;
        @api fieldCollection_toDisplay = [];


        @api iconName;
        @api leftIconName = 'utility:search';
        @api rightIconName = 'utility:down';
        @api placeholder;
        @api noMatchString = 'No matches found';
        @api fieldLevelHelp;
        @api isLoading = false;
        @api showNewRecordAction = false;
        @api excludeSublabelInFilter = false;   // If true, the 'sublabel' text of an option is included when determining if an option is a match for a given search text.
        @api includeValueInFilter = false;  // If true, the 'value' text of an option is not included when determining if an option is a match for a given search text.
        @api whereClause; // Reserved for future use
        @api orderByClause; // Reserved for future use
        @api defaultValueInput;
        @api minimumNumberOfSelectedRecords = 0;
        @api maximumNumberOfSelectedRecords = 0;
        @api disabled = false;

        // Determins if the lookup is a parent or child lookup
        @api parentOrChildLookup = '';
        @api parentComponentApiName = '';
        @api childRelationshipApiName = '';
        @api componentName = '';


        /* PRIVATE PROPERTIES */
        @track recentlyViewedRecords = [];
        @track records = [];
        showNewRecordModal;

        /* OUTPUT PROPERTIES */
        @api selectedRecordsOutput = [];
        @api selectedRecordOutput;
        @api numberOfRecordsOutput = 0;


        /* PUBLIC GETTERS AND SETTERS */
        @api
        get values() {
            return this._values || [];
        }
        set values(values) {
            if (!values) {
                this._values = [];
            } else {
                this._values = Array.isArray(values) ? values : [values];
                console.log('in set values');
                let unqueriedValues = this.values.filter(value => !this.records.some(record => record.value == value));
                console.log('unqueried values: ' + JSON.stringify(unqueriedValues));
                if (unqueriedValues.length) {
                    // String objectName, String fieldsToReturn, List<String> idsToRetrieve
                    getRecordsFromIds({
                        objectName: this.objectName,
                        fieldsToReturn: this.visibleFields_ToDisplayNames,
                        idsToRetrieve: unqueriedValues
                    }).then(result => {
                        console.log('got result');
                        console.log(JSON.stringify(result));
                        this.records = [...this.records, ...this.parseFields(result)];
                        this.addNewRecordAction();
                        console.log('finished get getRecordsFromIds result');
                    }).catch(error => {
                        console.log('in getRecordsFromIds error');
                        console.log(JSON.stringify(error));
                    }).finally(() => {
                        console.log('finished search change, setting isloading to false');
                        this.isLoading = false;
                    })
                }
            }
        }
        @track _values = [];
        @api
        get value() {
            return this.values.join(this.valueDelimiter);
        }
        set value(value) {
            value = String(value);
            this.values = this.allowMultiselect ? value.split(this.valueDelimiter).map(val => val.trim()) : [value];
        }
        @api
        get selectedRecords() {
            let records = [];
            for (let value of this.values) {
                const record = this.records.find(rec => rec.value === value);
                if (record) {
                    records.push(record);
                }
            }
            return records;
        }
        @api
        get selectedRecord() {
            return this.selectedRecords.length ? this.selectedRecords[0] : null;
        }

        // Get the object info
        @wire(getObjectInfo, { objectApiName: '$objectName' })
        objectInfo;
    
        // Lifecycle hooks
        connectedCallback() {
            console.log('in lookup connectedcallback');
            // If defaultValueInput is set, we want to ignore the values passed in and set the default value
            if ( this.defaultValueInput ) {
                this.values = this.defaultValueInput;
            } else {
                this.getRecentlyViewed();
            }
        }
    
        getRecentlyViewed() {
            this.isLoading = true;
            getRecentlyViewed({ objectName: this.objectName, fieldsToReturn: this.visibleFields_ToDisplayNames, numRecordsToReturn: DEFAULTS.NUM_RECENTLY_VIEWED, whereClause: this.whereClause })
                .then(result => {
                    console.log('result = ' + JSON.stringify(result));
                    this.recentlyViewedRecords = this.parseFields(result);
                    if (!this.records.length) {
                        this.resetRecentlyViewed();
                    }
                })
                .catch(error => {
                    console.log('ERROR: ' + JSON.stringify(error));
                }).finally(() => {
                    this.isLoading = false;
                })
        }
    
        handleSearchChange = (searchText) => {
            console.log('in handleSearchChange for ' + searchText);
            if (!searchText) {
                this.resetRecentlyViewed();
            } else {
                this.isLoading = true;
                search({
                    searchTerm: searchText,
                    objectName: this.objectName,
                    fieldsToSearch: this.visibleFields_ToSearchNames || (this.excludeSublabelInFilter ? null : this.visibleFields_ToDisplayNames),
                    fieldsToReturn: this.visibleFields_ToDisplayNames,
                    whereClause: this.whereClause,
                    orderByClause: this.orderByClause,
                    numRecordsToReturn: 0
                }).then(result => {
                    console.log('got result');
                    console.log(JSON.stringify(result));
                    this.records = this.parseFields(result);
                    this.addNewRecordAction();
                    console.log('finished get result');
                }).catch(error => {
                    console.log('in error');
                    console.log(JSON.stringify(error));
                }).finally(() => {
                    console.log('finished search change, setting isloading to false');
                    this.isLoading = false;
                })
            }
        }
    
        parseFields(apexResults) {
            let displayFields, labelField, sublabel;
            if (this.visibleFields_ToDisplayNames) {
                displayFields = this.visibleFields_ToDisplayNames.split(',');
                labelField = displayFields.splice(0, 1);
            }
    
            return apexResults.map(record => {
                if (!labelField) {
                    let nonIdFields = Object.keys(record).filter(fieldName => fieldName != 'Id');
                    if (nonIdFields.length !== 1) {
                        // THROW ERROR
                        console.log('Error: expected exactly one other field');
                    }
                    labelField = nonIdFields[0];
                }
                if (displayFields && displayFields.length) {
                    let sublabelValues = [];
                    for (let sublabelField of displayFields) {
                        if (record[sublabelField]) {
                            sublabelValues.push(record[sublabelField]);
                        }
                    }
                    sublabel = sublabelValues.join(' • ');
                }
                return {
                    label: record[labelField],
                    value: record.Id,
                    sublabel: sublabel,
                    icon: this.iconName
                }
            });
        }
    
        resetRecentlyViewed() {
            this.records = this.recentlyViewedRecords.map(rec => Object.assign({}, rec));
            this.addNewRecordAction();
        }
    
        addNewRecordAction() {
            if (this.showNewRecordAction) {
                this.records.unshift(ACTIONS.NEW_RECORD);
            }
        }
    
        handleComboboxChange(event) {
            if (this.allowMultiselect) {
                this.values = event.detail.values;

                // For each record that was selected map to Id and the value the value to the selectedRecordsOutput array
                this.selectedRecordsOutput = event.detail.values;
                this.numberOfRecordsOutput = event.detail.values.length ? event.detail.values.length : 0;
                this.selectedRecordOutput = null;

                // Check number of records to maximumNumberOfSelectedRecords, if we equal set dissabled to true
                if (this.numberOfRecordsOutput === this.maximumNumberOfSelectedRecords) {
                    this.disabled = true;
                } else {
                    this.disabled = false;
                }

                // Check number of records to minimumNumberOfSelectedRecords, if we are less then set required to true
                if (this.numberOfRecordsOutput < this.minimumNumberOfSelectedRecords) {
                    this.required = true;
                } else {
                    this.required = false;
                }
            } else {
                this.value = event.detail.value;
                this.selectedRecordOutput = event.detail.value;
                this.numberOfRecordsOutput = event.detail.value ? 1 : 0;
                this.selectedRecordsOutput = null;
            }
            this.dispatchRecords();
        }
    
        handleCustomAction(event) {
            console.log('in handleCustomAction');
            console.log(event.detail);
            if (event.detail === ACTIONS.NEW_RECORD.value) {
                this.showNewRecordModal = true;
                // this.template.querySelector('.newRecordModal').open();
            }
        }
    
        handlewNewRecordSave(event) {
            const evt = new ShowToastEvent({
                title: 'Record Created',
                message: 'Record ID: ' + event.detail.id,
                variant: 'success',
            });
            this.dispatchEvent(evt);
            this.closeNewRecordModal();
        }
    
        closeNewRecordModal() {
            this.showNewRecordModal = false;
        }
    
        dispatchRecords() {
            let detail;
            if (this.allowMultiselect) {
                detail = {
                    values: this.values,
                    selectedRecords: this.selectedRecords
                }
            } else {
                detail = {
                    value: this.value,
                    selectedRecord: this.selectedRecord
                }
            }
            console.log('about to dispatch, ' + JSON.stringify(detail));
            this.dispatchEvent(new CustomEvent('recordchange', { detail: detail }));

            console.log('selectedRecordsOutput = ' + JSON.stringify(this.selectedRecordsOutput));
            console.log('selectedRecordOutput = ' + JSON.stringify(this.selectedRecordOutput));
            console.log('numberOfRecordsOutput = ' + this.numberOfRecordsOutput);
            this.dispatchEvent(new FlowAttributeChangeEvent('selectedRecordsOutput', this.selectedRecordsOutput));
            this.dispatchEvent(new FlowAttributeChangeEvent('selectedRecordOutput', this.selectedRecordOutput));
            this.dispatchEvent(new FlowAttributeChangeEvent('numberOfRecordsOutput', this.numberOfRecordsOutput));
        }
}