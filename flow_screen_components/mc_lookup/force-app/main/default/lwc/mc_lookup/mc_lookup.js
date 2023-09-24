import { LightningElement, api, track } from 'lwc';
import { FlowAttributeChangeEvent } from 'lightning/flowSupport';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import newRecordModal from 'c/mc_newRecordModal';
import search from '@salesforce/apex/mc_lookupController.search';
import getRecentlyViewed from '@salesforce/apex/mc_lookupController.getRecentlyViewed';
import getRecordsFromIds from '@salesforce/apex/mc_lookupController.getRecordsFromIds';
import getObjectIcon from '@salesforce/apex/mc_lookupController.getObjectIcon';
import getRecords from '@salesforce/apex/mc_lookupController.getRecords';
import getRecordDetail from '@salesforce/apex/mc_lookupController.getRecordDetail';
import canCreateRecord from '@salesforce/apex/mc_lookupController.canCreateRecord';

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

export default class Mc_lookup extends NavigationMixin(LightningElement) {
    // For Debuging only
    @api componentName;

    debugLog(message) {
        console.log(this.componentName + ' : ' + message);
    }

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
        this.debugLog('in set fieldsToSearch');
        this.debugLog(value);
        this._fieldsToSearch = value;
        this.visibleFields_ToSearchNames = JSON.parse(value).map(field => field.name).join();
        this.fieldCollection_toSearch = JSON.parse(value).map(field => field.name);
        this.debugLog('this.fieldCollection_toSearch: ' + JSON.stringify(this.fieldCollection_toSearch));
        this.debugLog('this.visibleFields_ToSearchNames: ' + JSON.stringify(this.visibleFields_ToSearchNames));
    }
    @track _fieldsToSearch;
    @api visibleFields_ToSearchNames;
    @api fieldCollection_toSearch = [];

    @api get fieldsToDisplay() {
        return this._fieldsToDisplay;
    };
    set fieldsToDisplay(value) {
        this.debugLog('in set fieldsToDisplay');
        this.debugLog(value);
        this._fieldsToDisplay = value;

        // Check to see it _fieldsToDisplay is a array then parse it. If string do nothing
        // Depending if the user typed in the fields or used the picklist we need to account for both
        if (!value.includes('[')) {
            this.visibleFields_ToDisplayNames = value.replaceAll('"', '');
            this.fieldCollection_toDisplay = value.replaceAll('"', '');
        } else {
            this.visibleFields_ToDisplayNames = JSON.parse(value).map(field => field.name).join();
            this.fieldCollection_toDisplay = JSON.parse(value).map(field => field.name);
        }
        this.debugLog('set this.fieldCollection_toDisplay: ' + JSON.stringify(this.fieldCollection_toDisplay));
        this.debugLog('set this.visibleFields_ToDisplayNames: ' + JSON.stringify(this.visibleFields_ToDisplayNames));
    }
    @track _fieldsToDisplay;
    @api visibleFields_ToDisplayNames;
    @api fieldCollection_toDisplay = [];


    @api get iconName() {
        return this._iconName;
    };
    set iconName(value) {
        this._iconName = value;
    }
    @track _iconName;
    @api leftIconName = 'utility:search';
    @api rightIconName = 'utility:down';
    @api placeholder;
    @api noMatchString = 'No matches found';
    @api fieldLevelHelp;
    @api isLoading = false;
    @api showNewRecordAction = false;
    @api excludeSublabelInFilter = false;   // If true, the 'sublabel' text of an option is included when determining if an option is a match for a given search text.
    @api includeValueInFilter = false;  // If true, the 'value' text of an option is not included when determining if an option is a match for a given search text.
    @api orderByClause; // Reserved for future use
    @api disabled = false;
    @api _defaultValueInput;

    // Custom Labels for number of records selected
    @api minimumNumberOfSelectedRecords = 0;
    @api maximumNumberOfSelectedRecords = 0;

    @api minimumNumberOfSelectedRecordsMessage = 'Please select at least {0} records';
    @api maximumNumberOfSelectedRecordsMessage = 'Please select no more than {0} records';

    @track _minimumNumberOfSelectedRecordsMessage;
    @track _maximumNumberOfSelectedRecordsMessage;

    @track _showMinimumNumberOfSelectedRecordsMessage = false;
    @track _showMinimumNumberOfSelectedRecordsErrorMessage = false;
    @track _showMaximumNumberOfSelectedRecordsMessage = false;

    /* PRIVATE PROPERTIES */
    @track recentlyViewedRecords = [];
    @track records = [];
    @track showNewRecordModal; // Deprecated 2023-05-24 Andy Haas

    /* OUTPUT PROPERTIES */
    @track _selectedRecordIdsOutput = []; // Ids of selected records
    @track _selectedRecordIdOutput; // Id of selected record
    @track _selectedRecordsOutput; // Selected records ( full record detail )
    @track _selectedRecordOutput; // Selected record ( full record detail )
    @track _numberOfRecords = 0;

    @api
    get whereClause() {
        this.debugLog('in get whereClause' + this._whereClause);
        return this._whereClause;
    }

    set whereClause(value) {
        this.debugLog('whereClause: ' + value);
        this._whereClause = value;
        // If the where clause is changed then we need to reset the records
        this.loadRecords();
    }

    @track _whereClause;

    @api
    get selectedRecordIdsOutput() {
        return this._selectedRecordIdsOutput;
    }

    set selectedRecordIdsOutput(value) {
        this._selectedRecordIdsOutput = value ? value : [];
        this.debugLog('in set selectedRecordIdsOutput value: ' + this._selectedRecordIdsOutput);
        // If value is set then get the full record details
        if (this._selectedRecordIdsOutput) {
            // Convert value to string if it is an array
            if (Array.isArray(this._selectedRecordIdsOutput)) {
                this._selectedRecordIdsOutput = this._selectedRecordIdsOutput.toString();
            }
            // Get the full details of the selected records
            getRecordDetail({objectName: this.objectName, recordIds: this._selectedRecordIdsOutput})
                .then(result => {
                    this.selectedRecordsOutput = result ? result : [];
                    this.debugLog('in set selectedRecordIdsOutput result: ' + JSON.stringify(result));
                });
        }
    }

    @api 
    get numberOfRecordsOutput() {
        this.debugLog('in get numberOfRecordsOutput');
        this.debugLog(this._numberOfRecords);
        return this._numberOfRecords;
    }

    set numberOfRecordsOutput(value) {
        this.debugLog('in set numberOfRecordsOutput');
        this.debugLog(value);
        this._numberOfRecords = value;
        this.handleEventChanges('numberOfRecordsOutput', value);
    }

    @api 
    get selectedRecordIdOutput() {
        return this._selectedRecordIdOutput;
    }

    set selectedRecordIdOutput(value) {
        this._selectedRecordIdOutput = value;

        // Dispatch the selectedRecordId 
        this.debugLog('in set selectedRecordIdOutput value: ' + this._selectedRecordIdOutput);

        // If value is set then get the full record details
        if (value) {
            // Get the full details of the selected records
            getRecordDetail({objectName: this.objectName, recordIds: this._selectedRecordIdOutput})
                .then(result => {
                    // Dispatch the entire record details
                    this.selectedRecordOutput = result ? result[0] : {};
                    this.debugLog('in set selectedRecordIdOutput result: ' + JSON.stringify(result));
                });
        }
    }

    @api 
    get defaultValueInput() {
        return this._defaultValueInput;
    }

    @api get selectedRecordsOutput() {
        return this._selectedRecordsOutput;
    }

    set selectedRecordsOutput(value) {
        this._selectedRecordsOutput = value;
        this.handleEventChanges('selectedRecordsOutput', value);
    }

    @api 
    get selectedRecordOutput() {
        return this._selectedRecordOutput;
    }

    set selectedRecordOutput(value) {
        this._selectedRecordOutput = value;
        this.handleEventChanges('selectedRecordOutput', value);
    }

    set defaultValueInput(value) {
        this._defaultValueInput = value;
        // If defaultValueInput is set, then we need to set the selectedRecordIdsOutput if allowMultiSelect is true
        // Else set the selectedRecordIdOutput
        if (this.allowMultiSelect) {
            this.selectedRecordIdsOutput = value;

            // Set numberOfRecordsOutput count number of records in value string of strings
            if (value) {
                this.numberOfRecordsOutput = value.split(',').length;
            }
        } else {
            this.selectedRecordIdOutput = value;
            // Set numberOfRecordsOutput if value is set
            value ? this.numberOfRecordsOutput = 1 : this.numberOfRecordsOutput = 0;
        }
        this.handleEventChanges('defaultValueInput', value);
    }


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
            this.debugLog('in set values');
            let unqueriedValues = this.values.filter(value => !this.records.some(record => record.value == value));
            this.debugLog('unqueried values: ' + JSON.stringify(unqueriedValues));
            if (unqueriedValues.length) {
                // String objectName, String fieldsToReturn, List<String> idsToRetrieve
                getRecordsFromIds({
                    objectName: this.objectName,
                    fieldsToReturn: this.visibleFields_ToDisplayNames,
                    idsToRetrieve: unqueriedValues
                }).then(result => {
                    this.debugLog('got result');
                    this.debugLog(JSON.stringify(result));
                    this.records = [...this.records, ...this.parseFields(result)];
                    this.addNewRecordAction();
                    this.debugLog('finished get getRecordsFromIds result');
                }).catch(error => {
                    this.debugLog('in getRecordsFromIds error');
                    this.debugLog(JSON.stringify(error));
                }).finally(() => {
                    this.debugLog('finished search change, setting isloading to false');
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

    @api
    validate() {
        // If the minimumNumberOfSelectedRecords not equal to 0, check to see if the number of records selected is less than the minimum
        // If it is not valid then return error message and isValid = false
        if( this.required && !this.values.length ) {
            return {
                isValid: false,
                errorMessage: this.messageWhenValueMissing
            }
        } else if ( this.minimumNumberOfSelectedRecords !== 0 ) {
            if ( this.selectedRecords.length < this.minimumNumberOfSelectedRecords ) {
                this._showMinimumNumberOfSelectedRecordsErrorMessage = true;
                return {
                    isValid: false,
                    errorMessage: this._minimumNumberOfSelectedRecordsMessage
                }
            } else {
                return { isValid: true };
            }
        }
    }

    // Lifecycle hooks
    connectedCallback() {
        this.debugLog('in lookup connectedcallback');
        
        // Load the inital values and icon
        this.loadRecords();
    }

    loadRecords() {
        // Get the object's icon from getObjectIcon and set iconName
        getObjectIcon({ objectName: this.objectName })
        .then(result => {
            this.iconName = result;

            // If defaultValueInput is set, we want to ignore the values passed in and set the default value
            if ( this.defaultValueInput ) {
                this.debugLog('using default value input');
                this.values = this.defaultValueInput;
            // Else if whereClause is set, we want to ignore the values passed in and set the whereClause
            } else if ( this._whereClause ) {
                this.debugLog('using where clause');
                this.getRecords();
            // Else get the recently viewed records
            } else {
                this.debugLog('using recently viewed');
                this.getRecentlyViewed();
            }

            // Set Custom Labels
            // If the minimumNumberOfSelectedRecords is set, set the custom label)
            if ( this.minimumNumberOfSelectedRecords !== 0 ) {
                this._showMinimumNumberOfSelectedRecordsMessage = true;
                this._minimumNumberOfSelectedRecordsMessage = this.minimumNumberOfSelectedRecordsMessage.replace('{0}', this.minimumNumberOfSelectedRecords);
            }
            // If the maximumNumberOfSelectedRecords is set, set the custom label
            this.debugLog('this.maximumNumberOfSelectedRecords = ' + this.maximumNumberOfSelectedRecords);
            if ( this.maximumNumberOfSelectedRecords !== 0 ) {
                this._showMaximumNumberOfSelectedRecordsMessage = true;
                this._maximumNumberOfSelectedRecordsMessage = this.maximumNumberOfSelectedRecordsMessage.replace('{0}', this.maximumNumberOfSelectedRecords);
                this.debugLog('this._maximumNumberOfSelectedRecordsMessage = ' + this._maximumNumberOfSelectedRecordsMessage);
            }
        });
    }

    // Get the recently viewed records
    getRecentlyViewed() {
        this.isLoading = true;
        getRecentlyViewed({ objectName: this.objectName, fieldsToReturn: this.visibleFields_ToDisplayNames, numRecordsToReturn: DEFAULTS.NUM_RECENTLY_VIEWED, whereClause: this._whereClause })
            .then(result => {
                this.debugLog('getRecentlyViewed result = ' + JSON.stringify(result));
                this.recentlyViewedRecords = this.parseFields(result);
                if (!this.records.length) {
                    this.resetRecentlyViewed();
                }
            })
            .catch(error => {
                this.debugLog('ERROR: ' + JSON.stringify(error));
            }).finally(() => {
                this.isLoading = false;
            })
    }

    // Get the records from the whereClause
    // This will then populate the dropdown with the records that match the whereClause
    getRecords() {
        this.isLoading = true;
        this.debugLog('in getRecords');
        this.debugLog('this.visibleFields_ToDisplayNames = ' + this.visibleFields_ToDisplayNames);
        getRecords({ objectName: this.objectName, fieldsToReturn: this.visibleFields_ToDisplayNames, numRecordsToReturn: DEFAULTS.NUM_RECENTLY_VIEWED, whereClause: this._whereClause })
            .then(result => {
                this.debugLog('getRecords result = ' + JSON.stringify(result));
                this.records = this.parseFields(result);
                this.addNewRecordAction();
            })
            .catch(error => {
                this.debugLog('ERROR: ' + JSON.stringify(error));
            }).finally(() => {
                this.debugLog('in finally for getRecords');
                this.isLoading = false;
            })
    }

    handleSearchChange = (searchText) => {
        this.debugLog('in handleSearchChange for ' + searchText);
        if (!searchText) {
            this.resetRecentlyViewed();
        } else {
            this.isLoading = true;
            search({
                searchTerm: searchText,
                objectName: this.objectName,
                fieldsToSearch: this.visibleFields_ToSearchNames || (this.excludeSublabelInFilter ? null : this.visibleFields_ToDisplayNames),
                fieldsToReturn: this.visibleFields_ToDisplayNames,
                whereClause: this._whereClause,
                orderByClause: this.orderByClause,
                numRecordsToReturn: 0
            }).then(result => {
                this.debugLog('got result');
                this.debugLog(JSON.stringify(result));
                this.records = this.parseFields(result);
                this.debugLog('records = ' + JSON.stringify(this.records));
                this.addNewRecordAction();
                this.debugLog('finished get result');
            }).catch(error => {
                this.debugLog('in error');
                this.debugLog(JSON.stringify(error));
            }).finally(() => {
                this.debugLog('finished search change, setting isloading to false');
                this.isLoading = false;
            })
        }
    }

    parseFields(apexResults) {
        this.debugLog('in parseFields');
        let displayFields, labelField, sublabel, searchValue;

        // If visibleFields_ToDisplayNames is set, use that to parse the fields
        if (this.visibleFields_ToDisplayNames) {
            this.debugLog('parseFields this.visibleFields_ToDisplayNames = ' + this.visibleFields_ToDisplayNames)
            displayFields = this.visibleFields_ToDisplayNames.split(',');
            labelField = displayFields.splice(0, 1);
        }

        this.debugLog('Start labelField = ' + labelField);


        return apexResults.map(record => {
            if (!labelField) {
                let nonIdFields = Object.keys(record).filter(fieldName => fieldName != 'Id');
                this.debugLog('nonIdFields = ' + JSON.stringify(nonIdFields));
                if (nonIdFields.length !== 1) {
                    // THROW ERROR
                    this.debugLog('Error: expected exactly one other field');
                }
                labelField = nonIdFields[0];
                this.debugLog('labelField = ' + labelField);

                // Check if the label is a lookup field
                if (labelField.includes('.')) {
                    labelField = this.parseRelationshipFields(label,record);
                    this.debugLog('labelField = ' + labelField);
                }
            }

            // Go through the displayFields and build the sublabel
            // If the field is a lookup, parse the relationship fields
            if (displayFields && displayFields.length > 0) {
                this.debugLog('displayFields = ' + displayFields);
                sublabel = displayFields.map(fieldName => {
                    this.debugLog('fieldName = ' + fieldName);
                    if (fieldName.includes('.')) {
                        return this.parseRelationshipFields(fieldName, record);
                    } else {
                        this.debugLog('record: ' + JSON.stringify(record));
                        this.debugLog('record[fieldName] = ' + record[fieldName]);
                        return record[fieldName];
                    }
                }).join(' - ');

            }


            // if visibleFields_ToSearchNames is set, join the values and set as searchField
            if (this.visibleFields_ToSearchNames) {
                let searchFields = this.visibleFields_ToSearchNames.split(',');
                let searchFieldValues = [];
                for (let searchField of searchFields) {
                    if (record[searchField]) {
                        searchFieldValues.push(record[searchField]);
                    }
                }
                searchValue = searchFieldValues.join('');
            }

            return {
                label: record[labelField],
                value: record.Id,
                sublabel: sublabel,
                icon: this.iconName,
                searchValue: searchValue
            }
        });
    }

    resetRecentlyViewed() {
        this.records = this.recentlyViewedRecords.map(rec => Object.assign({}, rec));
        this.addNewRecordAction();
    }

    addNewRecordAction() {
        if (this.showNewRecordAction) {
            // Check to see if the ACTION.NEW_RECORD is already in the list
            let newRecordAction = this.records.find(record => record.value === ACTIONS.NEW_RECORD.value);
            if (!newRecordAction)
            {
                // Check if the user has create access
                if(!this.canCreateRecord){
                    // Add the new record action to the top of the list
                    this.records.unshift(ACTIONS.NEW_RECORD);
                }
            }
        }
    }

    // Parse the relationship fields
    // Define the key fields for the relationship and remove them from the list of fields to return
    parseRelationshipFields(fieldName, record) {
        this.debugLog('in parseRelationshipFields for ' + fieldName);
        // this.debugLog('record = ' + JSON.stringify(record));
        // fieldName is set like this Account.CreatedBy.FirstName
        let relationshipFields = fieldName.split('.');
        let relationshipField = relationshipFields[1];
        let field = relationshipFields[2];
        // Value is set like this "CreatedBy":{"FirstName":"Andy","Id":"0055e000001mKpCAAU"}
        // Set new object 
        let relationshipObject = record[relationshipField];
        // this.debugLog('relationshipObject = ' + JSON.stringify(relationshipObject));
        // "CreatedBy.FirstName":"Andy"
        let keyFieldValue = relationshipObject[field];
        // this.debugLog('keyFieldValue = ' + keyFieldValue);

        return keyFieldValue;
        
    }

    handleComboboxChange(event) {
        this.debugLog('in handleComboboxChange');
        let detail;
        if (this.allowMultiselect) {
            this.values = event.detail.values;

            // For each record that was selected map to Id and the value the value to the selectedRecordIdsOutput array
            this._selectedRecordIdsOutput = event.detail.values;
            this._numberOfRecordsOutput = event.detail.values.length ? event.detail.values.length : 0;
            this._selectedRecordIdOutput = null;

            // Check number of records to maximumNumberOfSelectedRecords, if we equal set dissabled to true
            if (this.numberOfRecordsOutput === this.maximumNumberOfSelectedRecords) {
                this.disabled = true;
            } else {
                this.disabled = false;
            }
            detail = {
                values: this.values,
                selectedRecords: this.selectedRecords
            }
        } else {
            this.value = event.detail.value;
            this._selectedRecordIdOutput = event.detail.value;
            this._numberOfRecordsOutput = event.detail.value ? 1 : 0;
            this._selectedRecordIdsOutput = null;                
            detail = {
                value: this.value,
                selectedRecord: this.selectedRecord
            }
        }
        this.dispatchEvent(new CustomEvent('recordchange', { detail: detail }));
        this.handleEventChanges('selectedRecordIdOutput', this._selectedRecordIdOutput);
        this.handleEventChanges('selectedRecordIdsOutput', this._selectedRecordIdsOutput);
        this.handleEventChanges('numberOfRecordsOutput', this._numberOfRecordsOutput);
    }

    handleCustomAction(event) {
        this.debugLog('in handleCustomAction: ', JSON.stringify(event.detail));
        this.debugLog(event.detail);
        if (event.detail === ACTIONS.NEW_RECORD.value) {
            // Call the new record modal
            newRecordModal.open({
                size: 'large',
                description: 'Create a new ' + this.objectName,
                objectApiName: this.objectName,
                modalTitle: 'New ' + this.objectName,
            })
            .then(result => {
                this.debugLog('new record modal result = ' + JSON.stringify(result));

                // If the modal is closed with success, then get the record details and set the selectedRecordIdOutput
                if (result.status === 'success') {
                    this.debugLog('result = ' + JSON.stringify(result));
                    this.debugLog('result.id = ' + result.id);

                    // Set the selectedRecordIdOutput
                    this.value = result.id;
                    this._selectedRecordIdOutput = result.id;
                    this._numberOfRecordsOutput = 1;
                    this._selectedRecordIdsOutput = null;

                    let detail = {
                        value: this.value,
                        selectedRecord: this.selectedRecord
                    }
                    this.dispatchEvent(new CustomEvent('recordchange', { detail: detail }));
                    this.handleEventChanges('selectedRecordIdOutput', this._selectedRecordIdOutput);
                    this.handleEventChanges('selectedRecordIdsOutput', this._selectedRecordIdsOutput);
                    this.handleEventChanges('numberOfRecordsOutput', this._numberOfRecordsOutput);
                }
            }).catch(error => {
                this.debugLog('error = ' + JSON.stringify(error));
            });

            // Template way of opening modal
            // this.showNewRecordModal = true;
            // Old way of opening modal
            // this.template.querySelector('.newRecordModal').open();
        }
    }

    handleEventChanges(apiName, value) {
        const attributeChangeEvent = new FlowAttributeChangeEvent(apiName, value);
        this.dispatchEvent(attributeChangeEvent);
    }
}