// Style from: https://www.lightningdesignsystem.com/components/combobox
import { LightningElement, api, track } from 'lwc';
import { KEYS, setValuesFromMultipleInput, setValuesFromSingularInput } from 'c/df_comboboxUtils';

const VARIANTS = {
    BASE: 'base',
    STANDARD: 'standard'
}

const LOAD_COUNT = 50;

export default class OptionSelector extends LightningElement {
    /* PUBLIC PROPERTIES */
    @api publicStyle;
    @api publicClass;
    @api label;
    @api name;
    @api customSearchHandler;   // Custom function to be executed by handleSearchChange, passed in from a parent component.
    @api messageWhenValueMissing = 'Please select at least one option.';
    @api iconSize = 'x-small';
    @api placeholder = 'Select an option';
    @api noMatchString = 'No matches found';
    @api valueDelimiter = ',';
    @api rightIcon = 'utility:down';    // Icon to be displayed on the right side of the search input
    @api fieldLevelHelp;
    @api errorMessage;
    @api required = false;
    @api disabled = false;
    @api isLoading = false;
    @api allowMultiselect = false;
    // @api variant = VARIANTS.STANDARD;   // RESERVED FOR FUTURE USE If set to 'base', when allowMultiselect is false, when the combobox has a value set it will appear like a base combobox rather than as an autocomplete 
    @api hidePills = false; // If true, list of selected pills in multiselect mode will not be displayed (generally because a parent component wants to display them differently).
    @api excludeSublabelInFilter = false;   // If true, the 'sublabel' text of an option is not included when determining if an option is a match for a given search text.
    @api includeValueInFilter = false;  // If true, the 'value' text of an option is included when determining if an option is a match for a given search text.
    @api filterActions = false; // If true, action items will be filtered along with selection items. By default, action items are always visible
    @api showSelectedCount = false; // If true, when allowMultiselect is true, the component label will show the number of selected values in parentheses
    @api hideSelectedValues = false;    // Reserved for future use

    /* PRIVATE PROPERTIES */
    @track _options = [];
    @track _values = [];
    @track _groupings = [];
    @track onRender = {};   // Used to manage actions on render
    @track onLoad = [];
    pillsNotFittingCount = 0;
    numOptionsDisplayed = LOAD_COUNT;
    pillContainerIsExpanded = false;
    pillsGoMultiLine = false;
    pillTops = [];
    debounceTimer;
    showList;
    _highlightedOptionIndex;

    /* PUBLIC GETTERS & SETTERS */
    @api
    get debounceDelay() {
        return this._debounceDelay;
    }
    set debounceDelay(delay) {
        this._debounceDelay = parseInt(delay) || 0;
    }
    _debounceDelay = 0;

    @api
    get options() {
        return this._options || [];
    }
    set options(options) {
        let groupings = [];
        if (Array.isArray(options)) {
            this._options = options.map((option, index) => {
                if (option.grouping && !groupings.includes(option.grouping)) {
                    groupings.push(option.grouping);
                }
                return this.getComboboxOption(option, index);
            });

            if (groupings.length) {
                let newIndex = 0;
                let groupedOptions = [];
                this._options.filter(option => !option.grouping).forEach(groupingOption => {
                    groupingOption.index = newIndex;
                    groupedOptions.push(groupingOption);
                    newIndex++;
                });

                groupings.forEach(grouping => {
                    groupedOptions.push({ label: grouping, isGrouping: true, index: newIndex });
                    newIndex++;
                    this._options.filter(option => option.grouping == grouping).forEach(groupingOption => {
                        groupingOption.index = newIndex;
                        groupedOptions.push(groupingOption);
                        newIndex++;
                    });
                })
                this._options = groupedOptions;
            }
            this.filterOptions();
        } else {
            this._options = [];
        }
    }

    @api
    get values() {
        return this._values || [];
    }
    set values(values) {
        this._values = setValuesFromMultipleInput(values);
        // if (!values) {
        //     this._values = [];
        // } else {
        //     this._values = Array.isArray(values) ? [...values] : [values];
        // }
    }

    @api
    get value() {
        return this.values.join(this.valueDelimiter);
    }
    set value(value) {
        this.values = setValuesFromSingularInput(value, this.valueDelimiter, this.allowMultiselect);
        // if (!value) {
        //     this.values = [];
        // } else {
        //     this.values = this.allowMultiselect ? value.split(this.valueDelimiter).map(val => val.trim()) : [value];
        // }
    }

    @api
    get groupings() {
        return this._groupings || [];
    }
    set groupings(value) {
        this._groupings = value.map(grouping => {
            return {
                value: grouping.value,
                label: grouping.label
            }
        })
        let groupedOptions = [];
        value.forEach(grouping => {
            let currentGroupingOptions = grouping.options.map(option => {
                return {
                    ...option,
                    grouping: grouping.label
                }
            });
            groupedOptions.push(...currentGroupingOptions);
        });
        this.options = groupedOptions;
    }

    @api
    get selectedOptions() {
        let selectedOptions = [];
        this.values.forEach(value => {
            const option = this.options.find(option => option.value === value);
            if (option) {
                selectedOptions.push(option);
            }
        });
        return selectedOptions;
    }

    get selectedOption() {
        return this.selectedOptions.length ? this.selectedOptions[0] : null;
    }

    /* PUBLIC FUNCTIONS */
    @api
    reportValidity() {
        if (!this.required || this.selectedOptions.length) {
            this.errorMessage = '';
        } else {
            this.errorMessage = this.messageWhenValueMissing;
        }
        return this.errorMessage === '';
    }

    @api
    validate() {
        if (this.reportValidity()) {
            return { isValid: true };
        } else {
            return {
                isValid: false,
                errorMessage: this.errorMessage
            }
        }
    }

    /* LIFECYCLE HOOKS */
    connectedCallback() {
        window.addEventListener("resize", () => { this.resizePillContainer() });

    }

    renderedCallback() {
        if (this.onRender.inputFocus) {
            this.onRender.inputFocus = false;
            this.inputElement?.focus();
            // this.inputElement ? this.inputElement.focus() : this.template.querySelector('.slds-combobox__input').focus();
        }
        if (this.onRender.highlightOption) {
            this.onRender.highlightOption = false;
            const highlightedOption = this.template.querySelector('[data-has-focus="true"]');
            this.scrollIntoViewIfNeeded(highlightedOption, this.listboxElement);
        }

        // Check to see if the arrangement of pills has changed since last render
        let newPillTops = [...this.pillElements].map(pill => pill.offsetTop);
        if (!(this.pillTops.length == newPillTops.length && this.pillTops.every((val, index) => val === newPillTops[index]))) {
            this.pillTops = newPillTops;
            this.resizePillContainer();
        }
    }

    /* PRIVATE GETTERS AND SETTERS */
    get highlightedOptionIndex() {
        return this._highlightedOptionIndex;
    }
    set highlightedOptionIndex(value) {
        this._highlightedOptionIndex = value;
        this.options.forEach(option => option.hasFocus = option.index === this.highlightedOptionIndex); // Update the hasFocus property for all options
    }

    /* DOM ELEMENT GETTERS */
    get inputElement() {
        return this.template.querySelector('input');
    }

    get listboxElement() {
        return this.template.querySelector('[role="listbox"]');
    }

    get pillElements() {
        return this.template.querySelectorAll('lightning-pill');
    }

    /* COMPUTED LOGIC VALUES */
    get displayedOptions() {
        return this.options.slice(0, this.numOptionsDisplayed);
    }

    get isInputDisabled() {
        return this.disabled || this.isLoading;
    }

    get noMatchFound() {
        return this.options.every(option => option.hidden || option.isAction);
    }

    get showSelectedValue() {
        // return !this.allowMultiselect && this.value;
        return !this.allowMultiselect && this.selectedOption;
    }

    get showPills() {
        return this.allowMultiselect && !this.hidePills && this.values.length;
    }

    get computedLabel() {
        return this.label + ((this.allowMultiselect && this.showSelectedCount) ? ' (' + this.values.length + ')' : '');
    }

    get isBaseVariant() {
        return this.variant === VARIANTS.BASE;
    }

    /* COMPUTED CSS CLASS STRINGS */
    get computedSelectedValueClass() {
        return 'slds-combobox__form-element slds-input-has-icon' + (this.selectedOption?.icon ? ' slds-input-has-icon_left-right' : ' slds-input-has-icon_right');
    }

    get computedFormElementClass() {
        return 'slds-form-element' + (this.errorMessage ? ' slds-has-error' : '');
    }

    get computedComboboxContainerClass() {
        return 'slds-combobox_container' + ((this.value && !this.isBaseVariant) ? ' slds-has-selection' : '');
    }

    get computedComboboxClass() {
        return 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click' + (this.showList ? ' slds-is-open' : '');
    }

    get computedListboxSelectionGroupClass() {
        return 'slds-listbox_selection-group' + (this.pillContainerIsExpanded ? ' slds-is-expanded' : '');
    }

    get computedFauxInputClass() {
        return 'slds-input_faux slds-combobox__input slds-combobox__input-value' + (this.disabled ? ' slds-theme_shade disabledCursor' : '');
    }

    /* ACTION FUNCTIONS */
    openList() {
        this.showList = true;
        this.onRender.inputFocus = true;
    }

    closeList() {
        this.showList = false;
        this.highlightedOptionIndex = undefined;
        this.numOptionsDisplayed = LOAD_COUNT;
        if (this.listboxElement)
            this.listboxElement.scrollTop = 0;
    }

    resetSearch() {
        this.inputElement.value = '';
        this.filterOptions();
    }

    filterOptions() {
        let searchText = (this.inputElement?.value || '').toLowerCase();
        // console.log('in filterOptions', searchText);
        let numDisplayedCount = 0;
        for (let option of this.options) {
            if (numDisplayedCount > this.numOptionsDisplayed) {
                option.hidden = true;
            } else if (searchText && option.isGrouping) {
                option.hidden = true;
            } else if (this.values.includes(option.value)) {
                // If the option has already been selected, hide it from the list of available options
                option.hidden = true;
            }
            else {
                // If the option's label matches the search text, display it. Also optionally check the option's sublabel and value.
                if (option.label.toLowerCase().includes(searchText)
                    || (this.includeValueInFilter && option.value.toLowerCase().includes(searchText))
                    || (!this.excludeSublabelInFilter && option.sublabel && option.sublabel.toLowerCase().includes(searchText))) {
                    option.hidden = false;
                    if (option.grouping) {
                        this.options.find(grouping => grouping.isGrouping && grouping.label == option.grouping).hidden = false;
                    }
                } else {
                    option.hidden = true;
                }
            }

            if (!option.hidden) {
                numDisplayedCount++;
            }
        }
    }

    selectOption(index) {
        let selectedOption = this.options[index];
        // console.log('selecting '+ JSON.stringify(selectedOption));
        // console.log('value before adding: '+ this.value);
        // console.log('values before adding: '+ JSON.stringify(this.values) +', length: '+ this.values.length);
        if (!selectedOption) {
            return;
        }
        if (selectedOption.isAction) {
            this.dispatchEvent(new CustomEvent('customaction', { detail: selectedOption.value }));
        } else {            
            this.values.push(selectedOption.value);
            this.values = this.values;
            // this.values = [...this.values, selectedOption.value];   // using spread instead of values.push to trigger the setter
            this.resetSearch();
            this.dispatchOptions();
            this.onRender.inputFocus = true;
        }
    }

    unselectOption(index) {
        this.values = [...this.values.slice(0, index), ...this.values.slice(Number(index) + 1)];
        console.log(JSON.stringify(this.values));
        this.dispatchOptions();
    }

    dispatchOptions() {
        let detail = {
            value: this.value,
            values: this.values,
            //selectedOptions: this.selectedOptions
        }
        console.log('dispatching '+ JSON.stringify(detail));
        this.dispatchEvent(new CustomEvent('change', { detail }));
    }

    highlightNextOption(startIndex) {
        if (!startIndex || startIndex >= this.options.length) {
            startIndex = 0;
        }
        if (this.options[startIndex].hidden || this.options[startIndex].isGrouping) {
            this.highlightNextOption(Number(startIndex) + 1);
        } else {
            this.highlightOption(startIndex);
        }
    }

    highlightPreviousOption(startIndex) {
        if ((startIndex !== 0 && !startIndex) || startIndex < 0) {
            startIndex = this.options.length - 1;
        }
        if (this.options[startIndex].hidden || this.options[startIndex].isGrouping) {
            this.highlightPreviousOption(Number(startIndex) - 1);
        } else {
            this.highlightOption(startIndex);
        }
    }

    highlightOption(index) {
        this.highlightedOptionIndex = index;
        this.onRender.highlightOption = true;
    }

    resizePillContainer() {
        let notFittingCount = 0;
        this.pillElements.forEach((pill) => {
            if (pill.offsetTop > this.pillElements[0].offsetTop + this.pillElements[0].getBoundingClientRect().height) {
                notFittingCount += 1;
            }
        });
        this.pillsNotFittingCount = notFittingCount;
    }

    /* EVENT HANDLERS */
    handleSearchChange(event) {
        let searchText = event.target.value;
        this.openList();
        this.debounce(
            () => this.customSearchHandler ? this.customSearchHandler(searchText) : this.filterOptions(),
            this.debounceDelay
        );
    }

    handleSearchClick() {
        this.handleSearchFocus();
        this.openList();
    }

    handleSearchFocus() {
        this.filterOptions();
        this.errorMessage = '';
    }

    handleSearchBlur(event) {
        this.closeList();
        this.reportValidity();
    }

    handleSearchKeydown(event) {
        if (this.disabled) {
            return;
        }
        if (event.key === KEYS.DOWN || event.key === KEYS.UP || event.key === KEYS.ENTER) {
            if (!this.showList) {
                this.openList();
                event.key === KEYS.UP ? this.highlightPreviousOption(this.highlightedOptionIndex) : this.highlightNextOption(this.highlightedOptionIndex);
            } else {
                if (this.options.some(option => !option.hidden)) {
                    if (event.key === KEYS.ENTER) {
                        this.selectOption(this.highlightedOptionIndex);
                        this.resetSearch();
                        this.closeList();
                    } else {
                        event.preventDefault();
                        event.stopPropagation();
                        event.key === KEYS.UP ? this.highlightPreviousOption(Number(this.highlightedOptionIndex) - 1) : this.highlightNextOption(Number(this.highlightedOptionIndex) + 1);
                    }
                }
            }
        }

        if (event.key === KEYS.ESCAPE) {
            event.preventDefault();
            event.stopPropagation();
            if (this.showSelectedValue) {
                this.handleClearClick();
            } else {
                this.resetSearch();
                this.closeList();
            }
        }
    }

    handleOptionSelect(event) {
        this.selectOption(event.currentTarget.dataset.index);
    }

    handleOptionUnselect(event) {
        this.unselectOption(event.target.dataset.index);
    }

    handleOptionMouseenter(event) {
        this.highlightedOptionIndex = event.currentTarget.dataset.index;
    }

    handleOptionMouseleave() {
        this.highlightedOptionIndex = undefined;
    }

    handleClearClick() {
        if (!this.disabled) {
            this.values = [];
            this.dispatchOptions();
            this.openList();    
        }
    }

    handleSelectedValueClick() {
        if (this.isBaseVariant) {
            this.openList();
            this.highlightOption(this.selectedOption.index);
        }
    }

    handleCollapsePillContainer() {
        this.pillContainerIsExpanded = false;
        this.resizePillContainer();
    }

    handleExpandPillContainer() {
        this.pillContainerIsExpanded = true;
        this.resizePillContainer();
    }

    handleListboxScroll(event) {
        if (!event.target)
            return;
        const lastDisplayedOption = this.template.querySelector('.slds-listbox__item:last-child');
        const ul = this.template.querySelector('.slds-listbox');
        let ot = lastDisplayedOption?.offsetTop
        if (event.target.scrollTop + event.target.offsetHeight > ot) {
            this.numOptionsDisplayed += LOAD_COUNT;
            this.filterOptions();
        }

    }

    /* UTILITY FUNCTIONS */
    debounce(fn, wait) {
        clearTimeout(this.debounceTimer);
        this.debounceTimer = setTimeout(fn, wait);
    }

    getComboboxOption(option, index) {
        return {
            ...option,
            index,
            get comboboxClass() {
                return 'slds-media slds-media_center slds-listbox__option slds-listbox__option_has-meta slds-listbox__option_plain' + (this.hasFocus ? ' slds-has-focus' : '');
            }
        }
    }

    // Lovingly "borrowed" from https://github.com/salesforce/base-components-recipes/blob/83b87d3772557a22de16f74a047a087a51c4934c/force-app/main/default/lwc/baseCombobox/baseCombobox.js#L836
    scrollIntoViewIfNeeded(element, scrollingParent) {
        const parentRect = scrollingParent.getBoundingClientRect();
        const findMeRect = element.getBoundingClientRect();
        if (findMeRect.top <= parentRect.top) {
            if (element.offsetTop + findMeRect.height < parentRect.height) {
                scrollingParent.scrollTop = 0;
            } else {
                scrollingParent.scrollTop = element.offsetTop;
            }
        } else if (findMeRect.bottom >= parentRect.bottom) {
            scrollingParent.scrollTop += findMeRect.bottom - parentRect.bottom;
        }
    }
}