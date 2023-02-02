import { LightningElement, api, track } from 'lwc';
import { FlowAttributeChangeEvent } from 'lightning/flowSupport';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import search from '@salesforce/apex/fsc_lookupController.search';
import getRecentlyViewed from '@salesforce/apex/fsc_lookupController.getRecentlyViewed';
import getRecordsFromIds from '@salesforce/apex/fsc_lookupController.getRecordsFromIds';
import getObjectIcon from '@salesforce/apex/fsc_lookupController.getObjectIcon';
import getRecords from '@salesforce/apex/fsc_lookupController.getRecords';
import getRecordDetail from '@salesforce/apex/fsc_lookupController.getRecordDetail';

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

        // Check to see it _fieldsToDisplay is a array then parse it. If string do nothing
        // Depending if the user typed in the fields or used the picklist we need to account for both
        if (!value.includes('[')) {
            this.visibleFields_ToDisplayNames = value.replaceAll('"', '');
            this.fieldCollection_toDisplay = value.replaceAll('"', '');
        } else {
            this.visibleFields_ToDisplayNames = JSON.parse(value).map(field => field.name).join();
            this.fieldCollection_toDisplay = JSON.parse(value).map(field => field.name);
        }
        console.log('set this.fieldCollection_toDisplay: ' + JSON.stringify(this.fieldCollection_toDisplay));
        console.log('set this.visibleFields_ToDisplayNames: ' + JSON.stringify(this.visibleFields_ToDisplayNames));
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
    @api whereClause;
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
    showNewRecordModal;

    /* OUTPUT PROPERTIES */
    @track _selectedRecordIdsOutput = []; // Ids of selected records
    @track _selectedRecordIdOutput; // Id of selected record
    @track _selectedRecordsOutput; // Selected records ( full record detail )
    @track _selectedRecordOutput; // Selected record ( full record detail )
    @track _numberOfRecords = 0;

    @api
    get selectedRecordIdsOutput() {
        return this._selectedRecordIdsOutput;
    }

    set selectedRecordIdsOutput(value) {
        this._selectedRecordIdsOutput = value;
        this.handleEventChanges('selectedRecordIdsOutput', value);

        // Get the full details of the selected records
        getRecordDetail({objectName: this.objectName, recordIds: value})
            .then(result => {
                this.selectedRecordsOutput = result;
                this.handleEventChanges('selectedRecordsOutput', selectedRecordsOutput);
            });
    }

    @api get numberOfRecordsOutput() {
        console.log('in get numberOfRecordsOutput');
        console.log(this._numberOfRecords);
        return this._numberOfRecords;
    }

    set numberOfRecordsOutput(value) {
        console.log('in set numberOfRecordsOutput');
        console.log(value);
        this._numberOfRecords = value;
        this.handleEventChanges('numberOfRecordsOutput', value);
    }

    @api get selectedRecordIdOutput() {
        return this._selectedRecordIdOutput;
    }

    set selectedRecordIdOutput(value) {
        this._selectedRecordIdOutput = value;
        this.handleEventChanges('selectedRecordIdOutput', value);

        // Get the full details of the selected records
        getRecordDetail({objectName: this.objectName, recordIds: value})
            .then(result => {
                this.selectedRecordOutput = result;
                this.handleEventChanges('selectedRecordOutput', selectedRecordOutput);
            });
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

    @api get selectedRecordOutput() {
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

    @api
    validate() {
        // If the minimumNumberOfSelectedRecords not equal to 0, check to see if the number of records selected is less than the minimum
        // If it is not valid then return error message and isValid = false
        if ( this.minimumNumberOfSelectedRecords !== 0 ) {
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
        console.log('in lookup connectedcallback');
        // Get the object's icon from getObjectIcon and set iconName
        getObjectIcon({ objectName: this.objectName })
        .then(result => {
            this.iconName = result;

            // If defaultValueInput is set, we want to ignore the values passed in and set the default value
            if ( this.defaultValueInput ) {
                console.log('using default value input');
                this.values = this.defaultValueInput;
            // Else if whereClause is set, we want to ignore the values passed in and set the whereClause
            } else if ( this.whereClause ) {
                console.log('using where clause');
                this.getRecords();
            // Else get the recently viewed records
            } else {
                console.log('using recently viewed');
                this.getRecentlyViewed();
            }

            // Set Custom Labels
            // If the minimumNumberOfSelectedRecords is set, set the custom label)
            if ( this.minimumNumberOfSelectedRecords !== 0 ) {
                this._showMinimumNumberOfSelectedRecordsMessage = true;
                this._minimumNumberOfSelectedRecordsMessage = this.minimumNumberOfSelectedRecordsMessage.replace('{0}', this.minimumNumberOfSelectedRecords);
            }
            // If the maximumNumberOfSelectedRecords is set, set the custom label
            console.log('this.maximumNumberOfSelectedRecords = ' + this.maximumNumberOfSelectedRecords);
            if ( this.maximumNumberOfSelectedRecords !== 0 ) {
                this._showMaximumNumberOfSelectedRecordsMessage = true;
                this._maximumNumberOfSelectedRecordsMessage = this.maximumNumberOfSelectedRecordsMessage.replace('{0}', this.maximumNumberOfSelectedRecords);
                console.log('this._maximumNumberOfSelectedRecordsMessage = ' + this._maximumNumberOfSelectedRecordsMessage);
            }
        });
    }

    // Get the recently viewed records
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

    // Get the records from the whereClause
    // This will then populate the dropdown with the records that match the whereClause
    getRecords() {
        this.isLoading = true;
        console.log('in getRecords');
        getRecords({ objectName: this.objectName, fieldsToReturn: this.visibleFields_ToDisplayNames, numRecordsToReturn: DEFAULTS.NUM_RECENTLY_VIEWED, whereClause: this.whereClause })
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
                console.log('records = ' + JSON.stringify(this.records));
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
        let displayFields, labelField, sublabel, searchValue;
        if (this.visibleFields_ToDisplayNames) {
            console.log('parseFields this.visibleFields_ToDisplayNames = ' + this.visibleFields_ToDisplayNames)
            displayFields = this.visibleFields_ToDisplayNames.split(',');
            labelField = displayFields.splice(0, 1);
        }

        console.log('Start labelField = ' + labelField);


        return apexResults.map(record => {
            if (!labelField) {
                let nonIdFields = Object.keys(record).filter(fieldName => fieldName != 'Id');
                console.log('nonIdFields = ' + JSON.stringify(nonIdFields));
                if (nonIdFields.length !== 1) {
                    // THROW ERROR
                    console.log('Error: expected exactly one other field');
                }
                labelField = nonIdFields[0];
                console.log('labelField = ' + labelField);

                // Check if the label is a lookup field
                if (labelField.includes('.')) {
                    labelField = this.parseRelationshipFields(label,record);
                    console.log('labelField = ' + labelField);
                }
            }

            // Go through the displayFields and build the sublabel
            // If the field is a lookup, parse the relationship fields
            if (displayFields) {
                console.log('displayFields = ' + displayFields);
                sublabel = displayFields.map(fieldName => {
                    console.log('fieldName = ' + fieldName);
                    if (fieldName.includes('.')) {
                        return this.parseRelationshipFields(fieldName, record);
                    } else {
                        return record[fieldName];
                    }
                }).join(' - ');
            }
            console.log('sublabel = ' + sublabel);


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
            this.records.unshift(ACTIONS.NEW_RECORD);
        }
    }

    // Parse the relationship fields
    // Define the key fields for the relationship and remove them from the list of fields to return
    parseRelationshipFields(fieldName, record) {
        console.log('in parseRelationshipFields for ' + fieldName);
        // console.log('record = ' + JSON.stringify(record));
        // fieldName is set like this Account.CreatedBy.FirstName
        let relationshipFields = fieldName.split('.');
        let relationshipField = relationshipFields[1];
        let field = relationshipFields[2];
        // Value is set like this "CreatedBy":{"FirstName":"Andy","Id":"0055e000001mKpCAAU"}
        // Set new object 
        let relationshipObject = record[relationshipField];
        // console.log('relationshipObject = ' + JSON.stringify(relationshipObject));
        // "CreatedBy.FirstName":"Andy"
        let keyFieldValue = relationshipObject[field];
        // console.log('keyFieldValue = ' + keyFieldValue);

        return keyFieldValue;
        
    }

    handleComboboxChange(event) {
        console.log('in handleComboboxChange');
        let detail;
        if (this.allowMultiselect) {
            this.values = event.detail.values;

            // For each record that was selected map to Id and the value the value to the selectedRecordIdsOutput array
            this.selectedRecordIdsOutput = event.detail.values;
            this.numberOfRecordsOutput = event.detail.values.length ? event.detail.values.length : 0;
            this.selectedRecordIdOutput = null;

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
            this.selectedRecordIdOutput = event.detail.value;
            this.numberOfRecordsOutput = event.detail.value ? 1 : 0;
            this.selectedRecordIdsOutput = null;                
            detail = {
                value: this.value,
                selectedRecord: this.selectedRecord
            }
        }
        this.dispatchEvent(new CustomEvent('recordchange', { detail: detail }));
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

    handleEventChanges(apiName, value) {
        const attributeChangeEvent = new FlowAttributeChangeEvent(apiName, value);
        this.dispatchEvent(attributeChangeEvent);
    }
}