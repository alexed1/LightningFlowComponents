import { LightningElement, api, track } from 'lwc';

const ORIENTATIONS = {
    HORIZONTAL: { label: 'Horizontal', value: 'horizontal', default: true },
    VERTICAL: { label: 'Vertical', value: 'vertical' }
}

const ALIGNMENTS = {
    LEFT: { label: 'Left', value: 'left' },
    CENTER: { label: 'Center', value: 'center' },
    RIGHT: { label: 'Right', value: 'right', default: true }
}

const SHOW_LINES = {
    ABOVE: { label: 'Above', value: 'above' },
    BELOW: { label: 'Below', value: 'below' },
    BOTH: { label: 'Both', value: 'both' },
    NEITHER: { label: 'Neither', value: 'neither', default: true }
}

const VARIANTS = {
    NEUTRAL: { label: 'Neutral Button', value: 'neutral', default: true },
    BASE: { label: 'Base Button', value: 'base' },
    OUTLINE_BRAND: { label: 'Outline Brand Button', value: 'brand-outline' },
    BRAND: { label: 'Brand', value: 'brand' },
    DESTRUCTIVE: { label: 'Destructive Button', value: 'destructive' },
    TEXT_DESTRUCTIVE: { label: 'Text Destructive Button', value: 'destructive-text' },
    SUCCESS: { label: 'Success Button', value: 'success' },
}

const YES_NO = {
    YES: { label: 'Yes', value: 'yes' },
    NO: { label: 'No', value: '', default: true },
}

const ACTION_MODES = {
    NAVIGATION: { label: 'Navigation', value: 'navigation', default: true },
    SELECTION: { label: 'Selection', value: 'selection' }
}

const CLICK_ACTIONS = [
    { input: 'Yes', value: 'yes' },
    { input: 'No', value: '', default: true },
]

const DATA_TYPE = {
    STRING: 'String',
    BOOLEAN: 'Boolean',
    NUMBER: 'Number'
}

const FLOW_EVENT_TYPE = {
    DELETE: 'configuration_editor_input_value_deleted',
    CHANGE: 'configuration_editor_input_value_changed'
}

const ERROR_MESSAGES={
    REQUIRED_FIELD: 'Required field, please select an option.'
}

export default class FlowButtonBarCPE extends LightningElement {
    @track variants = this.getConstant(VARIANTS);
    @track orientations = this.getConstant(ORIENTATIONS);
    @track alignments = this.getConstant(ALIGNMENTS);
    @track showLines = this.getConstant(SHOW_LINES);
    @track actionModes = this.getConstant(ACTION_MODES);
    @track yesNo = this.getConstant(YES_NO);

    /* CUSTOM PROPERTY EDITOR SETTINGS */
    _builderContext;
    _values;

    @api builderContext;

    @api
    get inputVariables() {
        return this._values;
    }
    set inputVariables(value) {
        this._values = value;
        this.initializeValues();
    }

    @track inputValues = {
        buttons: { value: null, valueDataType: DATA_TYPE.STRING, isCollection: false, label: 'Buttons' },
        label: { value: null, valueDataType: DATA_TYPE.STRING, isCollection: false, label: 'Label' },
        cssString: { value: null, valueDataType: DATA_TYPE.STRING, isCollection: false, label: 'CSS String' },
        alignment: { value: this.alignments.default.value, valueDataType: DATA_TYPE.STRING, isCollection: false, label: 'Alignment' },
        orientation: { value: this.orientations.default.value, valueDataType: DATA_TYPE.STRING, isCollection: false, label: 'Orientation' },
        showLines: { value: this.showLines.default.value, valueDataType: DATA_TYPE.STRING, isCollection: false, label: 'Display horizontal line(s)' },
        actionMode: { value: this.actionModes.default.value, valueDataType: DATA_TYPE.STRING, isCollection: false, label: 'Action mode' },
        required: { value: this.yesNo.default.value, valueDataType: DATA_TYPE.STRING, isCollection: false, label: 'Required' },
        multiselect: { value: this.yesNo.default.value, valueDataType: DATA_TYPE.STRING, isCollection: false, label: 'Multi-select' },
        defaultValue: { value: null, valueDataType: DATA_TYPE.STRING, isCollection: false, label: 'Default value' }
    };

    newInputValue(label, value, defaultValue, valueDataType, isCollection) {
        let inputValue = {
            label: label,
            defaultValue: defaultValue,
            value: value,
            valueDataType: valueDataType,
            isCollection: !!isCollection,    // convert to boolean
            dispatchDefaultIfNecessary() {
                if (!this.value && this.defaultValue) {
                    //this.value
                }
            }
        };


        return inputValue;
    }

    defaultValues = {
        alignment: this.alignments.default.value,
        orientation: this.orientations.default.value,
        showLines: this.showLines.default.value,
        actionMode: this.actionModes.default.value,
        // required: this.yesNo.default.value,
        // multiselect: this.yesNo.default.value
    }


    initializeValues() {
        if (this._values && this._values.length) {
            this._values.forEach(curInputParam => {
                let inputValue = this.inputValues[curInputParam.name];
                if (curInputParam.name && inputValue) {
                    if (curInputParam.name == 'buttons') {
                        this.buttons = JSON.parse(curInputParam.value);
                    } else {
                        inputValue.value = curInputParam.value;
                        inputValue.valueDataType = curInputParam.valueDataType;
                    }
                }
            });
        }
    }

    dispatchFlowValueChangeEvent(id, newValue, newValueDataType) {
        // console.log('in CPE dispatch to flow: ', id, newValue, newValueDataType);
        const valueChangedEvent = new CustomEvent(FLOW_EVENT_TYPE.CHANGE, {
            bubbles: true,
            cancelable: false,
            composed: true,
            detail: {
                name: id,
                newValue: newValue ? newValue : null,
                newValueDataType: newValueDataType || DATA_TYPE.STRING
            }
        });
        this.dispatchEvent(valueChangedEvent);
    }

    /* COMPONENT ELEMENTS */
    @api validate() {
        const validity = [];
        for (let buttonBarInput of this.template.querySelectorAll('c-fsc_flow-button-bar')) {
            if (buttonBarInput.required && !(buttonBarInput.values && buttonBarInput.values.length)) {
                buttonBarInput.errorMessage = ERROR_MESSAGES.REQUIRED_FIELD;
                validity.push({
                    key: 'Required Field',
                    errorString: ERROR_MESSAGES.REQUIRED_FIELD,
                });
    
            }
        }
        return validity;
    }

    @api maxNumButtons = 5;

    // @api groupAsToggle;
    // @api includeLine;
    // @api testInputValue;

    @track buttons = [];
    @track selectedButton = this.newButton();
    // dragIsActive;



    get activeDropZoneIndex() {
        return this._activeDropZoneIndex;
    }
    set activeDropZoneIndex(dzIndex) {
        this._activeDropZoneIndex = dzIndex;
        for (let dz of this.template.querySelectorAll('.dropzone')) {
            if (dzIndex >= 0 && dz.dataset.index == dzIndex) {
                dz.classList.add('dropzone_active');
            } else {
                dz.classList.remove('dropzone_active');
            }
        }
    }
    _activeDropZoneIndex;

    accordionSections = ['buttons', 'settings'];
    _openAccordionSections = this.accordionSections;//, 'settings'];
    get openAccordionSections() {
        return this._openAccordionSections;
    }
    set openAccordionSections(value) {
        this._openAccordionSections = value;
        //this.dispatchFlowValueChangeEvent()
    }

    showModal;
    showPreviewModal;
    showConfirmDelete; // Reserved for future use

    displayVariants;

    // Used for icon position
    positionOptions = [
        { label: 'Left', value: 'left' },
        { label: 'Right', value: 'right' }
    ];

    /* GETTERS */
    get isVertical() {
        return this.inputValues.orientation.value === ORIENTATIONS.VERTICAL.value;
    }
    get isHorizontal() {
        return !this.isVertical;
    }
    get isSelectionMode() {
        return this.inputValues.actionMode.value !== ACTION_MODES.NAVIGATION.value;
    }

    get newButtonDisabled() {
        return this.buttons.length >= this.maxNumButtons;
    }

    get selectedButtonVariantLabel() {
        return this.variants.findFromValue(this.selectedButton.variant).label;
    }

    get defaultValueOptions() {
        let noDefault = { label: '--No default option--', value: null };
        return [noDefault, ...this.buttons];
    }


    /* LIFECYCLE HOOKS */
    connectedCallback() {
        this.setDefaults();
    }

    // TODO: Defaults are wonky, need to fix them
    setDefaults() {
        // this.inputValues.orientation.value = this.inputValues.orientation.value || this.orientations.default.value;
        // this.inputValues.alignment.value = this.inputValues.alignment.value || this.alignments.default.value;
        // this.inputValues.showLines.value = this.inputValues.showLines.value || this.showLines.default.value;
        // this.actionModes.default.value = this.actionModes.default.value || this.actionModes.default.value;

        for (let [name, value] of Object.entries(this.inputValues)) {
            // if (this.defaultValues[name]) {
            if (value) {
                let hadValueSet = !this._values.some(_value => {
                    return _value.name === name;
                });
                if (hadValueSet) {
                    this.inputValues[name].value = this.defaultValues[name];
                    this.updateInputValue(name, this.defaultValues[name]);
                }
            }
        }

    }

    /* ACTION FUNCTIONS */
    openModal(isNew) {
        this.showModal = true;
        this.modalIsNewButton = isNew;
    }

    closeModal() {
        this.selectedButton = this.newButton();
        this.showModal = false;
    }

    setValueFromLabel() {
        let sb = this.selectedButton;
        if (sb.label && !sb.value) {
            sb.value = sb.label
        }
    }

    reorderButtons() {
        for (let i = 0; i < this.buttons.length; i++) {
            this.buttons[i].index = i;
        }
        this.dispatchFlowValueChangeEvent('buttons', JSON.stringify(this.buttons), DATA_TYPE.STRING);
    }

    confirmDelete() {
        this.showConfirmDelete = true;
    }

    // TODO: Implement this
    validateModal() {
        let fields = this.template.querySelectorAll('.slds-modal lightning-input');
        let allValid = true;
        for (let field of fields) {
            //if (!field.reportValidity())
            //allValid = false;
        }
    }

    deleteButton(index) {
        this.buttons.splice(index, 1);
        this.reorderButtons();
    }

    updateInputValue(name, value) {
        if (this.inputValues[name]) {
            this.dispatchFlowValueChangeEvent(name, value, this.inputValues[name].valueDataType || DATA_TYPE.STRING);
        }
    }

    updatePreviewButtonBar(attribute, value) {
        if (value) {
            this.template.querySelector('previewButtonBar').setAttribute(attribute, value);
        } else {
            this.template.querySelector('previewButtonBar').removeAttribute(attribute);
        }
    }


    /* EVENT HANDLERS */
    /* BUTTON CLICK EVENT HANDLERS */
    handleModalSaveClick() {
        // TODO: VALIDATION
        if (this.selectedButton.label && this.selectedButton.value) {

            // Determine whether the modal is saving an existing button or a new one
            let existingButton = this.buttons.find(button => {
                return button.index === this.selectedButton.index;
            });

            if (existingButton) {
                this.buttons[existingButton.index] = Object.assign({}, this.selectedButton);
            } else {
                this.buttons.push(Object.assign({}, this.selectedButton));
            }
            this.reorderButtons();
            this.closeModal();
        } else {
            let allValid = true;
            for (let requiredField of this.template.querySelectorAll('.slds-modal [required]')) {
                let fieldValid = requiredField.reportValidity();
                if (!fieldValid)
                    allValid = false;
            }
        }
    }

    handleModalCancelClick() {
        this.closeModal();
    }

    handleButtonOpenClick(event) {
        let index = event.currentTarget.dataset.index;
        this.selectedButton = Object.assign({}, this.buttons[index]);
        this.openModal();
    }

    handleButtonDeleteClick(event) {
        //this.confirmDelete(); TODO
        let buttonIndex = event.currentTarget.dataset.index || this.selectedButton.index;
        this.deleteButton(buttonIndex);
        this.closeModal();
    }

    handleNewButtonClick() {
        this.openModal(true);
    }

    handleShowPreviewClick() {
        this.showPreviewModal = true;
    }

    handlePreviewModalClose() {
        this.showPreviewModal = false;
    }

    /* INPUT CHANGE EVENT HANDLERS */
    handleModalLabelChange(event) {
        this.selectedButton.label = event.currentTarget.value;
    }
    handleModalLabelBlur(event) {
        this.selectedButton.label = event.currentTarget.value;
        this.setValueFromLabel();
    }
    handleModalValueChange(event) {
        this.selectedButton.value = event.currentTarget.value;
    }
    handleModalDescriptionChange(event) {
        this.selectedButton.descriptionText = event.currentTarget.value;
    }

    handleComboboxChange(event) {
        if (event.detail) {
            this.dispatchFlowValueChangeEvent(event.currentTarget.name, event.detail.value, DATA_TYPE.STRING);
        }
    }

    handleButtonClick(event) {
        // console.log('in CPE handleButtonClick');
        let name = event.currentTarget.name;
        if (name) {
            let value = event.detail.value;
            // console.log('in handleButtonClick, name = '+ name, 'value = '+ value);
            this.inputValues[name].value = value;
            this.dispatchFlowValueChangeEvent(name, value, DATA_TYPE.STRING);

            // // Update preview button bar
            // if (name == 'required' || name == 'multiselect') {
            //     this.updatePreviewButtonBar(name, value);
            // }

            if (name == 'actionMode' && this.isSelectionMode) {
                for (let button of this.buttons) {
                    button.variant = this.variants.default.value;//this.getObjectFromInput(BUTTON_STYLES).value;
                }
                this.reorderButtons();
                this.updateInputValue('orientation', this.orientations.list.HORIZONTAL.value);
                this.updateInputValue('alignment', this.alignments.list.LEFT.value);
            }
        }
    }

    handleInputValueChange(event) {
        if (event.detail && event.currentTarget.name) {
            let dataType = DATA_TYPE.STRING;
            if (event.currentTarget.type == 'checkbox') dataType = DATA_TYPE.BOOLEAN;
            if (event.currentTarget.type == 'number') dataType = DATA_TYPE.NUMBER;

            let newValue = event.currentTarget.type === 'checkbox' ? event.currentTarget.checked : event.currentTarget.value;
            this.dispatchFlowValueChangeEvent(event.currentTarget.name, newValue, dataType);
        }
    }

    /* DRAG AND DROP EVENT HANDLERS */
    handleDragStart(event) {
        let index = event.currentTarget.dataset.index;
        event.dataTransfer.setData('text/plain', index);
    }

    // Anytime the drag leaves an element, set activeDropZoneIndex to null. (If it leaves the element for another dropzone-triggering element, the active dropzone will be reset.)
    handleDragLeave() {
        this.activeDropZoneIndex = null;
    }

    handleRowContainerDragOver(event) {
        event.preventDefault();
        let newActiveDropZoneIndex = event.currentTarget.dataset.index;
        if (newActiveDropZoneIndex && !this.isMouseInTopHalf(event)) {
            newActiveDropZoneIndex++;
        }
        this.activeDropZoneIndex = newActiveDropZoneIndex;
    }

    handleDropzoneDragOver(event) {
        event.preventDefault();
        this.activeDropZoneIndex = event.currentTarget.dataset.index;
    }

    handleContainerDrop(event) {
        event.preventDefault();
        let originIndex = event.dataTransfer.getData('text/plain');
        let dzIndex = this.activeDropZoneIndex;
        if (originIndex == dzIndex || originIndex == (dzIndex - 1)) {
            // ignore, it's not actually moving
        } else {
            let draggedButton = this.buttons.splice(originIndex, 1);
            let startPos = dzIndex;
            // insert at dzIndex. -1 if origin < dzIndex
            if (originIndex < dzIndex) {
                startPos--;
            }
            if (draggedButton.length) {
                this.buttons.splice(startPos, 0, draggedButton[0]);
            }
            this.reorderButtons();
        }
        this.activeDropZoneIndex = null;
    }

    /* STYLE EVENT HANDLERS */
    handleStyleFocus(event) {
        this.displayVariants = true;
    }

    handleStyleBlur(event) {
        this.displayVariants = false;
    }

    handleStyleSelect(event) {
        this.selectedButton.variant = this.variants.findFromValue(event.currentTarget.variant).value;
    }

    handleSelectIcon(event) {
        this.selectedButton.iconName = event.detail;
    }

    handleIconPositionChange(event) {
        this.selectedButton.iconPosition = event.detail.value;
    }

    /* UTILITY FUNCTIONS */
    getConstant(constant) {
        return {
            list: constant,
            get options() { return Object.values(this.list); },
            get default() { return this.options.find(option => option.default); },
            findFromValue: function (value) {
                let entry = this.options.find(option => option.value === value);
                return entry || this.default;
            },
            findFromLabel: function (label) {
                let entry = this.options.find(option => option.label === label);
                return entry || this.default;
            }
        }
    }

    newButton(label, value, descriptionText) {
        let newButton = {
            label: label,
            value: value,
            descriptionText: descriptionText,
            iconPosition: 'left',   // TODO: un-hard code this
            variant: this.variants.default.value
        }
        return newButton;
    }

    isMouseInTopHalf(event) {
        let rect = event.currentTarget.getBoundingClientRect();
        let mouseY = event.clientY - rect.top;
        let isTopHalf = (mouseY / rect.height < 0.5);
        return isTopHalf;
    }

    /*
        getObjectFromInput(valueMap, input, inputParam = 'input', valueParam = 'value', defaultParam = 'default') {
        if (!valueMap)
            return null;

        let returnValue;
        if (input) {
            returnValue = valueMap.find(el => {
                return el[inputParam].toLowerCase() === input.toLowerCase();
            });
        }
        if (!returnValue) {
            returnValue = valueMap.find(el => {
                return el[defaultParam];
            });
        }
        if (!returnValue)
            return null;
        return returnValue;
    }
    */
}