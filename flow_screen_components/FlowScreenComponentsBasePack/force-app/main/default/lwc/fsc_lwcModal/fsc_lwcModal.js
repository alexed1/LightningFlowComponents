import { LightningElement, api, track } from 'lwc';
const KEYS = {
    ESC: { CODE: 27, STRING: 'Escape' },
    TAB: { CODE: 9, STRING: 'Tab' },
    ENTER: { CODE: 13, STRING: 'Enter' }
}
const CLASSES = {
    CUSTOM_BUTTON: 'customButton',
    CANCEL_BUTTON: 'cancelButton',
    CONFIRM_BUTTON: 'confirmButton',
    MODAL_HEADER: 'slds-modal__header',
    MODAL_HEADER_EMPTY: 'slds-modal__header_empty',
    MODAL_SIZE_PREFIX: 'slds-modal_',
}
const DEFAULTS = {
    CANCEL_BUTTON_LABEL: 'Cancel',
    CONFIRM_BUTTON_LABEL: 'Confirm',
    CONFIRM_BUTTON_VARIANT: 'brand'
}
const LIGHTNING_BUTTON = 'lightning-button';
const LIGHTNING_COMPONENT_PREFIX = 'lightning-';
const CANCEL = 'cancel';
const CONFIRM = 'confirm';
const VALIDATEABLE_COMPONENTS = ['input', 'combobox', 'checkbox', 'dual-listbox', 'radio-group', 'slider'];

export default class LwcModal extends LightningElement {
    static delegatesFocus = true; // Does this do anything? https://developer.salesforce.com/docs/component-library/documentation/lwc/create_components_focus.html

    /* PUBLIC PROPERTIES */
    @api showModal; // Boolean to show/hide the modal
    @api focusIndex = 0;    // Index of the currently focused element, ranging from 0 to the number of input elements

    /* Modal properties */
    @api header;    // Modal header text
    @api bodyText;  // Modal body text
    @api cancelButtonLabel = DEFAULTS.CANCEL_BUTTON_LABEL;   // Label of the Cancel button
    @api confirmButtonLabel;    // Label of the Confirm button
    @api confirmButtonVariant = DEFAULTS.CONFIRM_BUTTON_VARIANT;  // Label of the Confirm button
    @api validateOnConfirm; // Boolean that controls whether the modal runs validation on slotted input components before dispatching the Confirm action
    @api size;  // Controls modal size. Valid values are small, medium and large
    @api customButtons; // Reserved for future use
    @api isDefault; // Reserved for future use
    @api focusSelectorString; // Reserved for future use
    
    // @api isConfirmationModal; // No longer used

    /* PUBLIC GETTERS/SETTERS */
    @api
    get confirmation() {
        return this._confirmation || {};
    }
    set confirmation(confirmation) {
        this._confirmation = confirmation;
        if (confirmation) {
            // Inherit modal properties from the confirmation object. Use defaults where none are supplied.
            this.header = confirmation.header;
            this.bodyText = confirmation.text;
            this.confirmButtonLabel = confirmation.confirmButtonLabel || DEFAULTS.CONFIRM_BUTTON_LABEL;
            this.confirmButtonVariant = confirmation.confirmButtonVariant || DEFAULTS.CONFIRM_BUTTON_VARIANT;
            this.cancelButtonLabel = confirmation.cancelButtonLabel || DEFAULTS.CANCEL_BUTTON_LABEL;
            // Open the modal
            if (!this.showModal)
                this.open();
        } else {
            // If confirmation is falsy and showModal is true, close the modal
            if (this.showModal)
                this.close();
        }
    }

    /* PUBLIC FUNCTIONS */
    @api open() {
        this.rendered = false;
        this.showModal = true;
    }

    @api close() {
        this.showModal = false;
        if (this.confirmation)
            this.confirmation = null;
    }

    @api
    focusElement(el) {
        if (el) {
            el.focus();
            return true;
        }
        return false;
    }

    // Run reportValidity() on all lightning-[inputType] elements in the markup, where [inputType] is any of the input components named in VALIDATEABLE_COMPONENTS
    @api validate() {
        let allValid = true;
        for (let tagName of VALIDATEABLE_COMPONENTS) {
            for (let el of this.querySelectorAll(LIGHTNING_COMPONENT_PREFIX + tagName)) {
                allValid = allValid && el.reportValidity();
            }
        }
        return allValid;
    }

    @api
    focusSelector(selector) {
        this.updateFocusableElements();
        console.log('In focusSelector, selector = ' + selector);
        const selectedElement = this.querySelector(selector);
        console.log('selectedElement = ' + selectedElement);
        if (selectedElement && selectedElement.tabIndex >= 0 && !selectedElement.disabled) {
            selectedElement.focus();
            return true;
        }
        return false;
    }


    /* PRIVATE PROPERTIES */
    _confirmation = {};
    _size;
    @track focusableElements = [];
    @track buttons = [];
    cancelValue = CANCEL;
    confirmValue = CONFIRM;
    rendered;

    get modalHeaderClass() {
        let modalClasses = [CLASSES.MODAL_HEADER];
        if (!this.header) {
            modalClasses.push(CLASSES.MODAL_HEADER_EMPTY)
        }
        return modalClasses.join(' ');
    }

    renderedCallback() {
        if (!this.rendered && this.showModal) {
            this.rendered = true;
            this.loadModal();
        } else {
            if (this.focusSelectorString) {
                this.focusSelector(this.focusSelectorString);
                this.focusSelectorString = null;
            }
        }
    }

    loadModal() {
        this.focusIndex = 0;
        this.updateFocusableElements();
        this.setFocus();
        if (this.size) {
            this.template.querySelector('section').classList.add(CLASSES.MODAL_SIZE_PREFIX + this.size);
        }
    }

    isFocusable(el) {
        return el.tabIndex >= 0 && !el.disabled;
    }

    updateFocusableElements() {
        const focusableElements = [...this.querySelectorAll('*')].filter(el => this.isFocusable(el));   // Select all slot elements that can receive focus (tabIndex >= 0) and are not disabled
        const slotContentElements = focusableElements.filter(el => !el.classList.contains(CLASSES.CUSTOM_BUTTON));    // Select the ones not marked with the custom button class
        const slotCustomButtons = focusableElements.filter(el => el.classList.contains(CLASSES.CUSTOM_BUTTON));   // Select the ones marked as custom buttons
        const standardButtons = this.template.querySelectorAll(LIGHTNING_BUTTON);   // Select the standard buttons: cancel and (if present) confirm
        this.buttons = [...standardButtons, ...slotCustomButtons];  // Append any custom buttons after the standard buttons
        this.focusableElements = [...slotContentElements, ...this.buttons]; // Ordering focusable elements so the tab order is: slot content elements, standard buttons, slot custom buttons. This way 'cancel' always appears as the leftmost button.
        // console.log('Finished updateFocusableElements. There are '+ standardButtons.length +' standard buttons, '+ slotCustomButtons.length +' custom buttons, and '+ slotContentElements.length +' focusable slot elements');
        this.addButtonListeners();
        this.addFocusListeners();
    }

    addFocusListeners() {
        let index = 0;
        for (let el of this.focusableElements) {
            el.dataset.focusIndex = index;
            index++;
            el.removeEventListener('focus', this.handleElementFocus);   // Make sure we're not duplicating event listeners if it already exists
            el.addEventListener('focus', this.handleElementFocus);
        }
    }

    addButtonListeners() {
        for (let el of this.buttons) {
            el.removeEventListener('click', this.handleButtonClick);   // Make sure we're not duplicating event listeners if it already exists
            el.addEventListener('click', this.handleButtonClick);
        }
    }

    setFocus() {
        if (this.focusableElements[this.focusIndex])
            this.focusableElements[this.focusIndex].focus();
    }

    // Single event handler for any standard and custom buttons in the modal's footer
    handleButtonClick = (event) => {
        let buttonValue = event.currentTarget.value;
        // Validate if applicable
        if (buttonValue === CONFIRM && this.validateOnConfirm && !this.validate()) {
            return null; // Validation failed
        }

        // First we dispatch the generic buttonclick event
        this.dispatchEvent(new CustomEvent('buttonclick', { detail: buttonValue }));

        // Then dispatch a 'cancel' or 'confirm' event if it wasn't a custom button being clicked, and close the modal
        if (buttonValue === CANCEL || buttonValue === CONFIRM) {
            this.dispatchEvent(new CustomEvent(buttonValue));
            this.close();
        }
    }

    handleElementFocus = (event) => {
        this.focusIndex = event.currentTarget.dataset.focusIndex;
    }

    cancel() {
        this.dispatchEvent(new CustomEvent(this.cancelValue));
        this.close();
    }

    handleKeyDown(event) {
        if (event.keyCode === KEYS.ESC.CODE || event.code === KEYS.ESC.STRING) {
            event.stopPropagation();
            event.preventDefault();
            this.cancel();
        } else if (event.keyCode === KEYS.TAB.CODE || event.code === KEYS.TAB.STRING) {
            event.stopPropagation();
            event.preventDefault();
            let newIndex = Number(this.focusIndex) + (event.shiftKey ? -1 : 1); // If user is holding the shift key, we cycle through focusableElements backwards instead of forwards, so the index decreases instead of increasing
            if (newIndex >= this.focusableElements.length) {
                newIndex = 0;   // If index exceeds array length, reset to 0
            } else if (newIndex < 0) {
                newIndex = this.focusableElements.length - 1; // If index becomes negative, set to last element
            }
            this.focusIndex = newIndex;
            this.setFocus();
        } else if (event.keyCode === KEYS.ENTER.CODE || event.code === KEYS.ENTER.STRING) {
            // TODO: Confirm modal on enter press
        }
    }

    handleSlotChange(e) {
        // console.log("New slotted content has been added or removed!");
    }


    /* No in use yet/anymore */
    /*
    handleModalFocus(event) {
        // console.log('in handleModalFocus');
        // console.log('currentTarget = '+ event.currentTarget.tagName, 'target = '+ event.target.tagName);
    }

    dispatchButtonclick(buttonValue) {
        this.dispatchEvent(new CustomEvent('buttonclick', { detail: buttonValue }));
    }

    */

}