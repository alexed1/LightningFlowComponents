import { LightningElement, api, track, wire } from 'lwc';
import getObjectFields from '@salesforce/apex/usf3.FieldSelectorController.getObjectFields';

const CLASSES = {
    PREFIX: '.',
    DROPDOWN_TRIGGER: 'slds-dropdown-trigger',
    IS_OPEN: 'slds-is-open',
}

const LIGHTNING = {
    INPUT: 'lightning-input'
}

export default class FieldSelector extends LightningElement {
    @api objectName;
    @api publicStyle;
    @api label = 'Select Fields';
    @api hidePills;
    @api required;
    @api name;
    @api allowMultiselect;

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

    @track fields = [];
    @track _selectedFields = [];
    errorMessage;
    isLoading;
    noMatchString = 'No matches found';
    objectChangeCount = 0;

    @wire(getObjectFields, { objectName: '$objectName' })
    handleGetObjectFields({ error, data }) {
        if (!this.objectName) {
            this.placeholder = 'Select an object first'
            this.isLoading = false;
            return;
        }
        this.placeholder = null;
        this.isLoading = true;
        this.fields = [];
        // If the object is changed from the original value, clear any pre-selected fields
        if (this.objectChangeCount > 0) {
            this.selectedFields = [];
            this.dispatchFields();
        }
        this.errorMessage = null;
        if (error) {
            console.log('Error: ' + error.body.message);
            this.errorMessage = error.body.message;
        }
        if (data) {
            this.fields = this.shallowCloneArray(data);
            this.fields.sort((a, b) => {
                return a.label.toLowerCase() > b.label.toLowerCase() ? 1 : -1;
            });
            this.objectChangeCount++;

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
        }
        this.isLoading = false;
    }

    connectedCallback() {
        if (this.objectName)
            this.isLoading = true;
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

    filterOptions(searchText = '') {
        searchText = searchText.toLowerCase();
        for (let field of this.fields) {
            if (this.selectedFields.some(el => el.name === field.name))
                field.hidden = true;
            else {
                if (field.name.toLowerCase().includes(searchText) || field.label.toLowerCase().includes(searchText)) {
                    field.hidden = false;
                } else {
                    field.hidden = true;
                }
            }
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
        this.hideList();
        this.reportValidity();
    }

    handleFieldSelect(event) {
        let selectedIndex = event.currentTarget.dataset.index;
        if (this.allowMultiselect) {
            this.selectedFields.push(this.fields[selectedIndex]);
            this.inputElement.value = null;
        } else {
            this.selectedFields = [this.fields[selectedIndex]];
        }
        this.dispatchFields();
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
}