import { LightningElement, api, track } from 'lwc';

const ORIENTATION = {
    HORIZONTAL: 'horizontal',
    VERTICAL: 'vertical',
    get LIST() { return [this.HORIZONTAL, this.VERTICAL]; },
    get DEFAULT() { return this.HORIZONTAL; }
}
const ALIGNMENT = {
    RIGHT: 'right',
    LEFT: 'left',
    CENTER: 'center',
    get LIST() { return [this.RIGHT, this.LEFT, this.CENTER] },
    get DEFAULT() { return this.RIGHT; }
}

const BUTTON_STYLES = [
    { input: 'Neutral Button', value: 'slds-button_neutral', default: true },
    { input: 'Bare Button', value: null },
    { input: 'Brand Button', value: 'slds-button_brand' },
    { input: 'Outline Brand Button', value: 'slds-button_outline-brand' },
    { input: 'Destructive Button', value: 'slds-button_destructive' },
    { input: 'Text Destructive Button', value: 'slds-button_text-destructive' },
    { input: 'Success Button', value: 'slds-button_success' }
];

const BASE_BUTTON_CLASS = 'slds-button';

export default class FlowButtonBarCPE extends LightningElement {
    /* CUSTOM PROPERTY EDITOR SETTINGS */
    _builderContext;
    _values;

    @api get builderContext() {
        return this._builderContext;
    }

    set builderContext(value) {
        this._builderContext = value;
    }

    @api get inputVariables() {
        return this._values;
    }

    set inputVariables(value) {

        this._values = value;
        this.initializeValues();
    }

    @track inputValues = {
        alignment: {value: null, valueDataType: null, isCollection: false, label: 'Alignment'},
        orientation: {value: null, valueDataType: null, isCollection: false, label: 'Orientation'},        
        buttons: {value: null, valueDataType: null, isCollection: false, label: 'Buttons'},        
        groupAsToggle: {value: null, valueDataType: null, isCollection: false, label: 'Group as toggle'},
        includeLine: {value: null, valueDataType: null, isCollection: false, label: 'Display horizontal line above buttons'},
        doNotTransitionOnClick: {value: null, valueDataType: null, isCollection: false, label: 'Do not transition on click'}
    };

    initializeValues() {
        console.log('in initializeValues');
        if (this._values && this._values.length) {
            
            this._values.forEach(curInputParam => {
                this.log(curInputParam);
                if (curInputParam.name && this.inputValues[curInputParam.name]) {
                    if (curInputParam.name == 'buttons') {
                        this.buttons = JSON.parse(curInputParam.value);                        
                    } else {                        
                        this.inputValues[curInputParam.name].value = curInputParam.value;
                        this.inputValues[curInputParam.name].valueDataType = curInputParam.valueDataType;
                    }
                }
            });
        }
    }

    dispatchFlowValueChangeEvent(id, newValue, newValueDataType) {
        //console.log('in dispatch to flow: ', id, newValue, newValueDataType);
        const valueChangedEvent = new CustomEvent('configuration_editor_input_value_changed', {
            bubbles: true,
            cancelable: false,
            composed: true,
            detail: {
                name: id,
                newValue: newValue ? newValue : null,
                newValueDataType: newValueDataType
            }
        });
        this.dispatchEvent(valueChangedEvent);
    }

    /* COMPONENT ELEMENTS */

    @api maxNumButtons = 5;

    @api orientation;
    @api alignment;
    @api groupAsToggle;
    @api includeLine;
    @api testInputValue;

    @track buttons = [];
    @track selectedButton = this.newButton();
    //@track draggedButtonIndex = {};
    dragIsActive;
    //modalIsNewButton;

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

    showModal;
    showConfirmDelete;

    displayVariants;

    connectedCallback() {
        this.setDefaults();
    }

    setDefaults() {        
        this.inputValues.orientation.value = this.inputValues.orientation.value || ORIENTATION.DEFAULT;
        this.inputValues.alignment.value = this.inputValues.alignment.value || ALIGNMENT.DEFAULT;
        if (this.buttons.length === 0) {
            this.buttons.push(
               this.newButton('Previous', 'previous'),
               this.newButton('Next', 'previous'),
               this.newButton('Cancel', 'cancel'),
            );
            this.reorderButtons();
        }
    }

    /* GETTERS */
    get isVertical() { return this.inputValues.orientation.value === ORIENTATION.VERTICAL; }
    get isHorizontal() { return !this.isVertical; }

    get newButtonDisabled() { return this.buttons.length >= this.maxNumButtons; }

    get orientationOptions() {
        return ORIENTATION.LIST.map(el => {
            return { label: el, value: el }
        });
    }

    get alignmentOptions() {
        return ALIGNMENT.LIST.map(el => {
            return { label: el, value: el }
        });
    }

    get styleOptions() {
        let defaultClasses = [BASE_BUTTON_CLASS];
        let options = BUTTON_STYLES.map(style => {
            return { 
                label: style.input,
                value: style.value,
                class: [...defaultClasses, style.value].join(' ')
            }
        });
        return options
    }

    /* ACTION FUNCTIONS */
    openModal() {
        this.showModal = true;
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
            this.buttons[i].num = (i + 1);
        }
        this.log(this.buttons);
        this.dispatchFlowValueChangeEvent('buttons', JSON.stringify(this.buttons), 'String');
    }

    confirmDelete() {
        this.showConfirmDelete = true;
    }

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


    /* EVENT HANDLERS */
    /* BUTTON CLICK EVENT HANDLERS */
    handleModalSaveClick() {
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
        this.openModal();
    }

    /* INPUT CHANGE EVENT HANDLERS */
    handleModalLabelChange(event) {
        this.selectedButton.label = event.detail.value;
    }
    handleModalLabelBlur() {
        this.setValueFromLabel();
    }
    handleModalValueChange(event) {
        this.selectedButton.value = event.detail.value;
    }
    handleModalDescriptionChange(event) {
        this.selectedButton.descriptionText = event.detail.value;
    }
    handleOrientationChange(event) {
        if (event.detail) {
            this.dispatchFlowValueChangeEvent('orientation', event.detail.value, 'String');
            //this.orientation = event.detail.value;
        }
    }
    handleAlignmentChange(event) {
        if (event.detail) {
            this.dispatchFlowValueChangeEvent('alignment', event.detail.value, 'String');
            //this.alignment = event.detail.value;
        }
    }

    handleInputValueChange(event) {
        if (event.detail && event.currentTarget.name) {
            let dataType = 'String';
            if (event.currentTarget.type == 'checkbox') dataType = 'Boolean';
            if (event.currentTarget.type == 'number') dataType = 'Number';

            let newValue = event.currentTarget.type === 'checkbox' ? event.currentTarget.checked : event.detail.value;

            this.dispatchFlowValueChangeEvent(event.currentTarget.name, newValue, dataType);
        }
    }

    /* DRAG AND DROP EVENT HANDLERS */
    handleDragStart(event) {
        let index = event.currentTarget.dataset.index;        
        event.dataTransfer.setData('text/plain', index);
    }

    handleButtonDragOver(event) {
        event.preventDefault();
        let rect = event.currentTarget.getBoundingClientRect();
        let mouseY = event.clientY - rect.top;
        let dzIndex = event.currentTarget.dataset.index;
        let isTopHalf = (mouseY / rect.height < 0.5);
        this.activeDropZoneIndex = Number(dzIndex) + isTopHalf ? 0 : 1;
    }

    handleDragLeave(event) {
        this.activeDropZoneIndex = null;
    }

    handleDragOver(event) {
        event.preventDefault();
        let dataset = event.currentTarget.dataset;
        let newActiveDropZoneIndex = dataset.index;
        if (!dataset.isDropzone) {
            let rect = event.currentTarget.getBoundingClientRect();
            let mouseY = event.clientY - rect.top;
            let isTopHalf = (mouseY / rect.height < 0.5);
            if (!isTopHalf)
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
        if (originIndex || originIndex == 0) {

        }
        console.log('in handleContainerDrop: moving '+ originIndex +' into dropzone #'+ this.activeDropZoneIndex);

        let draggedButton = this.buttons.splice(originIndex, 1);
        if (!draggedButton.length) {
            console.log('somethings weird, what? error');
        } else {
            this.buttons.splice(this.activeDropZoneIndex, 0, draggedButton[0]);
        }
        this.activeDropZoneIndex = null;
        this.reorderButtons();        
    }

    /* STYLE EVENT HANDLERS */
    handleStyleFocus(event) {
        this.displayVariants = true;
    }

    handleStyleBlur(event) {
        this.displayVariants = false;
    }

    handleStyleSelect(event) {
        this.selectedButton.style = {            
            label: event.currentTarget.dataset.label,
            value: event.currentTarget.dataset.value,
            class: event.currentTarget.className
        }
    }

    /* UTILITY FUNCTIONS */
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

    newButton(label, value, descriptionText, style) {
        return {
            label: label,
            value: value,
            descriptionText: descriptionText,
            style: this.newStyle(style),
        }
    }

    newStyle(style) {
        let s = this.getObjectFromInput(BUTTON_STYLES, style);
        return {
            label: s.input,
            value: s.value,
            get class() {
                return BASE_BUTTON_CLASS + (s.value ? ' '+ s.value : null)
            }
        }
    }

    p(str) {
        return JSON.parse(JSON.stringify(str));
    }

    log(str) {
        console.log(this.p(str));
    }
}