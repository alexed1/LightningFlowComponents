import { LightningElement, api, track, wire } from 'lwc';
import getObjectFields from '@salesforce/apex/usf3.FieldSelectorController.getObjectFields';

const CLASSES = {
    PREFIX: '.',
    DROPDOWN_TRIGGER: 'slds-dropdown-trigger',
    IS_OPEN: 'slds-is-open',
}

const ICONS = {
    CHEVRON: 'utility:chevronright',
    TEXT: 'utility:text',
    PICKLIST: 'utility:picklist_type',
    DATE: 'utility:date_input',
    DATETIME: 'utility:date_time',
    PERCENT: 'utility:percent',
    NUMBER: 'utility:topic2',
    CURRENCY: 'utility:currency',
    BOOLEAN: 'utility:crossfilter',
    IDENTITY: 'utility:identity'
}

const FIELD_TYPES = {
    BOOLEAN: 'boolean',
    CURRENCY: 'currency',
    STRING: 'string',
    DOUBLE: 'double',
    INTEGER: 'integer',
    DATE: 'date',
    DATETIME: 'datetime',
    PICKLIST: 'picklist',
    PERCENT: 'percent',
    TIME: 'time',
    ID: 'ID'
}

const LIGHTNING = {
    INPUT: 'lightning-input'
}

export default class FieldSelector extends LightningElement {
    //@api objectName;
    @api publicStyle;
    @api label = 'Select Fields';
    @api hidePills;
    @api required;
    @api name;
    @api allowMultiselect;
    @api allowLookups = false;
    @api fieldTypeFilter;

    @api placeholder;

    @api
    get selectedFields() {
        return this._selectedFields;
    }
    set selectedFields(fields) {
        this._selectedFields = this.shallowCloneArray(fields) || [];
        this.filterOptions();
    }
    
    @api
    get selectedField() {
        return this.selectedFields.length ? this.selectedFields[0] : null;
    }
    set selectedField(value) {
        this.selectedFields = value ? [value] : [];
    }

    @api
    get selectedValue() {
        // return (this.selectedField && this.selectedField.name) ? this.selectedField.name : null;
        return this.selectedField && this.selectedField.name;
    }

    @api preselectedValuesString;

    @api
    reportValidity() {
        if (!this.required)
            return true;
        let errorMessage = '';
        if (!this.selectedFields.length) {
            errorMessage = 'Please select at least one field.'
        } else {
            this.inputElement.value = ' ';  // used to still display the 'required' asterisk when required but not cause an error on an empty text box
        }
        this.inputElement.setCustomValidity(errorMessage);
        return this.inputElement.reportValidity();
    }

    @api get objectName(){
        return this._objectName;
    }
    set objectName(value) {
        console.log('setting objectName to '+ value);
        this._objectName = value;
        if (!this.objectName) {
            this.placeholder = 'Select an object first'
            this.isLoading = false;
            return;
        }
        this.placeholder = null;
        this.isLoading = true;
        // If the object is changed from the original value, clear any pre-selected fields
        if (this.objectChangeCount > 0) {
            this.selectedFields = [];
            this.dispatchFields();
        }
        this.getObjectFields(this._objectName);
    }

    @track fields = [];
    @track lookupFields = [];
    @track _selectedFields = [];
    @track _objectName;
    errorMessage;
    isLoading;
    noMatchString = 'No matches found';
    objectChangeCount = 0;


    @track lookupChain;

    // @wire(getObjectFields, { objectName: '$objectName' })
    // handleGetObjectFields({ error, data }) {
    //     if (!this.objectName) {
    //         this.placeholder = 'Select an object first'
    //         this.isLoading = false;
    //         return;
    //     }
    //     this.placeholder = null;
    //     this.isLoading = true;
    //     this.fields = [];
    //     // If the object is changed from the original value, clear any pre-selected fields
    //     if (this.objectChangeCount > 0) {
    //         this.selectedFields = [];
    //         this.dispatchFields();
    //     }
    //     this.errorMessage = null;
    //     if (error) {
    //         console.log('Error: ' + error.body.message);
    //         this.errorMessage = error.body.message;
    //     }
    //     if (data) {
    //         this.fields = this.shallowCloneArray(data);
    //         this.fields.sort((a, b) => {
    //             return a.label.toLowerCase() > b.label.toLowerCase() ? 1 : -1;
    //         });
    //         this.objectChangeCount++;

    //         if (this.preselectedValuesString) {
    //             // console.log('preselectedValuesString = '+ this.preselectedValuesString);
    //             let preselectedFields = [];
    //             for (let value of this.preselectedValuesString.split(',')) {
    //                 value = value.trim();
    //                 let matchingField = this.fields.find(field => field.name === value);
    //                 if (matchingField) {
    //                     preselectedFields.push(matchingField);
    //                 }
    //             }        
    //             this.selectedFields = preselectedFields;
    //         }
    //     }
    //     this.isLoading = false;
    // }

    // @wire(getObjectFields, { objectName: '$objectName' })
    // handleGetObjectFields({ error, data }) {
    //     console.log('in setFields for object: '+ this.objectName);
    //     this.isLoading = true;
    //     this.placeholder = null;
    //     this.fields = [];
    //     this.lookupFields = [];
    //     this.errorMessage = null;

    //     // If the object is not set then add placeholder
    //     if (!this.objectName) {
    //         this.placeholder = 'Select an object first'
    //         this.isLoading = false;
    //         return;
    //     }

    //     if (error) {
    //         console.log('Error: ' + error.body.message);
    //         this.errorMessage = error.body.message;
    //         return;
    //     }

    //     // If the object is changed from the original value, clear any pre-selected fields
    //     if (this.objectChangeCount > 0) {
    //         this.selectedFields = [];
    //         this.dispatchFields();
    //     }

    //     if (data) {
    //         this.fields = this.shallowCloneArray(data);
    //         let lookupFields = [];
    //         for (let field of this.fields) {
    //             if (field.parentObjectName) {
    //                 let lookupField = {
    //                     ...field,
    //                     isLookup: true
    //                 }
    //                 lookupField.sublabel = lookupField.relationshipName;
    //                 lookupField.rightIcon = ICONS.CHEVRON;
    //                 // console.log('pushing lookupField ' + JSON.stringify(lookupField));
    //                 lookupFields.push(lookupField);
    //             } else {
    //                 field.sublabel = field.name;
    //                 field.leftIcon = this.getIconFromFieldType(field.type);
    //             }
    //         }
    //         lookupFields.sort((a, b) => {
    //             return a.label.toLowerCase() < b.label.toLowerCase() ? -1 : 1;
    //         });
    //         this.fields.sort((a, b) => {
    //             return a.label.toLowerCase() < b.label.toLowerCase() ? -1 : 1;
    //         });

    //         // Remove duplicate fields from the lookupFields and fields arrays
    //         for (let lookupField of lookupFields) {
    //             let matchingField = this.fields.find(field => field.name === lookupField.name);
    //             if (matchingField) {
    //                 this.fields.splice(this.fields.indexOf(matchingField), 1);
    //             }
    //         }

    //         this.objectChangeCount++;

    //         if (this.preselectedValuesString) {
    //             // console.log('preselectedValuesString = '+ this.preselectedValuesString);
    //             let preselectedFields = [];
    //             for (let value of this.preselectedValuesString.split(',')) {
    //                 value = value.trim();
    //                 let matchingField = this.fields.find(field => field.name === value);
    //                 if (matchingField) {
    //                     preselectedFields.push(matchingField);
    //                 }
    //             }        
    //             this.selectedFields = preselectedFields;
    //         }

    //         this.fields = [...lookupFields, ...this.fields];
    //         this.isLoading = false;
    //         console.log('fields = ' + JSON.stringify(this.fields));
    //         console.log('finished setfields, fields.length = ' + this.fields.length);
    //     }

    // }

    getObjectFields(objectName, showList = false) {
        console.log('in getObjectFields for object: '+ objectName);
        this.isLoading = true;
        this.placeholder = null;
        this.fields = [];
        this.lookupFields = [];
        this.errorMessage = null;

        // If the object is changed from the original value, clear any pre-selected fields
        if (this.objectChangeCount > 0) {
            console.log('objectChangeCount > 0, clearing selectedFields');
            this.selectedFields = [];
            this.dispatchFields();
        }

        getObjectFields({ objectName: objectName })
            .then(result => {
                console.log('result = ' + JSON.stringify(result));
                this.fields = this.shallowCloneArray(result);
                let lookupFields = [];
                for (let field of this.fields) {
                    if (field.parentObjectName && this.allowLookups) {
                        let lookupField = {
                            ...field,
                            isLookup: true
                        }
                        lookupField.sublabel = lookupField.relationshipName;
                        lookupField.rightIcon = ICONS.CHEVRON;
                        // console.log('pushing lookupField ' + JSON.stringify(lookupField));
                        lookupFields.push(lookupField);
                    } else {
                        field.sublabel = field.name;
                        field.leftIcon = this.getIconFromFieldType(field.type);
                    }
                }
                lookupFields.sort((a, b) => {
                    return a.label.toLowerCase() < b.label.toLowerCase() ? -1 : 1;
                });
                this.fields.sort((a, b) => {
                    return a.label.toLowerCase() < b.label.toLowerCase() ? -1 : 1;
                });
    
                // Remove duplicate fields from the lookupFields and fields arrays
                for (let lookupField of lookupFields) {
                    let matchingField = this.fields.find(field => field.name === lookupField.name);
                    if (matchingField) {
                        this.fields.splice(this.fields.indexOf(matchingField), 1);
                    }
                }

                console.log('fieldTypeFilter = ' + this.fieldTypeFilter);
                // Is fieldTypeFilter set?
                if (this.fieldTypeFilter) {
                    // Remove fields that don't match the fieldTypeFilter
                    console.log('fieldTypeFilter = ' + this.fieldTypeFilter);
                    let filteredFields = [];
                    for (let field of this.fields) {
                        if (field.type.toLowerCase() === this.fieldTypeFilter.toLowerCase()) {
                            filteredFields.push(field);
                        }
                    }
                    // Set the fields to the filtered fields
                    this.fields = filteredFields;
                    console.log('filteredFields = ' + JSON.stringify(filteredFields));
                }
    
                if (this.preselectedValuesString) {
                    // console.log('preselectedValuesString = '+ this.preselectedValuesString);
                    let preselectedFields = [];
                    for (let value of this.preselectedValuesString.split(',')) {
                        value = value.trim();
                        let matchingField = this.fields.find(field => field.name === value);
                        if (matchingField) {
                            preselectedFields.push(matchingField);
                        }
                    }        
                    this.selectedFields = preselectedFields;
                }
    
                this.fields = [...lookupFields, ...this.fields];
                this.isLoading = false;
                //console.log('fields = ' + JSON.stringify(this.fields));
                console.log('finished getObjectFields, fields.length = ' + this.fields.length);
            })
            .catch(error => {
                console.log('Error: ' + error.body.message);
                this.errorMessage = error.body.message;
                return;
            });

        if(showList === true) this.showList();
    }


    connectedCallback() {
        if (this.objectName) {
            this.isLoading = true;
            //this.getObjectFields(this.objectName);
        } else {
            this.placeholder = 'Select an object first';
        }
    }

    get dropdownTrigger() {
        return this.template.querySelector(CLASSES.PREFIX + CLASSES.DROPDOWN_TRIGGER) || {};
    }

    get inputElement() {
        return this.template.querySelector(LIGHTNING.INPUT);
    }

    get searchLabelCounter() {
        let label = this.label;
        if (this.allowMultiselect)
            label += ' (' + this.selectedFields.length + ')';
        return label;
    }

    get isInputDisabled() {
        return !this.objectName || this.isLoading;
    }

    get noMatchFound() {
        return this.fields.every(field => field.hidden);
    }

    get showSelectedValue() {
        return !this.allowMultiselect && this.selectedValue;
    }

    get showPills() {
        return this.allowMultiselect && !this.hidePills && this.selectedFields.length;
    }

    /* ACTION FUNCTIONS */
    showList() {
        this.dropdownTrigger.classList.add(CLASSES.IS_OPEN);
    }

    hideList() {
        this.dropdownTrigger.classList.remove(CLASSES.IS_OPEN);
    }

    // filterOptions(searchText = '') {
    //     searchText = searchText.toLowerCase();
    //     for (let field of this.fields) {
    //         if (this.selectedFields.some(el => el.name === field.name))
    //             field.hidden = true;
    //         else {
    //             if (field.name.toLowerCase().includes(searchText) || field.label.toLowerCase().includes(searchText)) {
    //                 field.hidden = false;
    //             } else {
    //                 field.hidden = true;
    //             }
    //         }
    //     }
    // }

    filterOptions(searchText = '') {
        console.log('in filterOptions, searchText = ' + searchText);
        searchText = searchText.toLowerCase();
        for (let field of this.fields) {
            if (this.selectedFields.some(el => el.name === field.name))
                field.hidden = true;
            else {
                //console.log('field = ' + JSON.stringify(field));
                if (field.name.toLowerCase().includes(searchText) || field.label.toLowerCase().includes(searchText)) {
                    field.hidden = false;
                } else {
                    field.hidden = true;
                }
            }
        }
    }

    resetSearch() {
        if (this.lookupChain) {
            console.log('resetting search');
            this.lookupChain = null;
            this.hideList();
            this.getObjectFields(this.objectName);
        }
    }

    dispatchFields() {
        this.dispatchEvent(new CustomEvent('fieldupdate', { detail: { 
            value: this.selectedFields,
            values: this.selectedFields,
            selectedField: this.selectedField
        } }));
    }

    /* EVENT HANDLERS */
    handleSearchChange() {
        this.filterOptions(this.inputElement.value);
    }

    handleSearchFocus(event) {
        this.filterOptions(this.inputElement.value);
        this.showList();
    }

    handleSearchBlur(event) {
        console.log('in handleSearchBlur');
        console.log('this.lookupChain = ' + this.lookupChain);
        // If the user clicks on a isLookup field, we want to keep the list open
        if (this.lookupChain !== null && this.lookupChain !== undefined) {
            console.log('isLookup field clicked');
            return;
        } else {
            console.log('isLookup field not clicked');
            this.resetSearch();
            this.reportValidity();
            this.hideList();
        }
    }

    // handleFieldSelect(event) {
    //     let selectedIndex = event.currentTarget.dataset.index;
    //     if (this.allowMultiselect) {
    //         this.selectedFields.push(this.fields[selectedIndex]);
    //         this.inputElement.value = null;
    //     } else {
    //         this.selectedFields = [this.fields[selectedIndex]];
    //     }
    //     this.dispatchFields();
    // }

    handleFieldSelect(event) {
        let selectedIndex = this.fields[event.currentTarget.dataset.index];
        console.log('selectedIndex = ' + JSON.stringify(selectedIndex));
        if (selectedIndex.isLookup) {
            event.preventDefault();
            console.log('relationship field clicked');
            if (!this.lookupChain) {
                this.lookupChain = this.objectName + '.';
            }
            this.lookupChain += selectedIndex.relationshipName;
            console.log('lookupChain = ' + this.lookupChain);
            //this.inputElement.value = this.lookupChain;
            this.getObjectFields(selectedIndex.parentObjectName, true);
        } else {
            console.log('non-relationship field clicked');
            console.log('lookupChain = ' + this.lookupChain);
            if (this.lookupChain) {
                console.log('adding lookupField');
                let lookupField = Object.assign({}, selectedIndex);
                lookupField.name = this.lookupChain + '.' + lookupField.name;
                lookupField.label = this.lookupChain + '.' + lookupField.label;
                console.log('adding lookupField: '+ JSON.stringify(lookupField));

                // If allowMultiselect is true push to array otherwise set selectedFields to array with one element
                if (this.allowMultiselect) {
                    this.selectedFields.push(lookupField);
                } else {
                    this.selectedFields = [lookupField];
                }
            } else {
                console.log('adding non-lookupField');
                // If allowMultiselect is true push to array otherwise set selectedFields to array with one element
                if (this.allowMultiselect) {
                    this.selectedFields.push(selectedIndex);
                } else {
                    this.selectedFields = [selectedIndex];
                }
            }
            //this.inputElement.value = null;
            console.log('selectedFields = ' + JSON.stringify(this.selectedFields));
            this.dispatchFields();
            this.resetSearch();
        }
    }

    handleFieldUnselect(event) {
        this.selectedFields.splice(event.currentTarget.dataset.index, 1);
        this.dispatchFields();
    }

    handleClearClick(event) {
        console.log('in handleClearClick');
        this.selectedFields = [];
        this.dispatchFields();
        // These don't work, I think because the input hasn't rerendered yet
        // this.filterOptions();
        // this.showList();
    }

    /* UTILITY FUNCTIONS */
    shallowCloneArray(arrayToClone) {
        if (!Array.isArray(arrayToClone))
            return null;

        let newArray = [];
        for (let el of arrayToClone) {
            newArray.push(Object.assign({}, el));
        }
        return newArray;
    }

    getIconFromFieldType(fieldType) {
        switch (fieldType.toLowerCase()) {
            case FIELD_TYPES.INTEGER:
            case FIELD_TYPES.DOUBLE:
                return ICONS.NUMBER;
            case FIELD_TYPES.BOOLEAN:
                return ICONS.BOOLEAN;
            case FIELD_TYPES.CURRENCY:
                return ICONS.CURRENCY;
            case FIELD_TYPES.PICKLIST:
                return ICONS.PICKLIST;
            case FIELD_TYPES.PERCENT:
                return ICONS.PERCENT;
            case FIELD_TYPES.DATETIME:
            case FIELD_TYPES.TIME:
                return ICONS.DATETIME;
            case FIELD_TYPES.DATE:
                return ICONS.DATE;
            default:
                return ICONS.TEXT;
        }
    }
}