import { LightningElement, api, track } from 'lwc';
import { FlowAttributeChangeEvent, FlowNavigationNextEvent, FlowNavigationBackEvent, FlowNavigationFinishEvent } from 'lightning/flowSupport';

const VERTICAL = 'vertical';

const ALIGNMENTS = [
    { input: 'left', value: 'slds-float_left', default: true },
    { input: 'center', value: 'slds-align_absolute-center' },
    { input: 'right', value: 'slds-float_right' }
];

const ALIGNMENTS2 = {
    LEFT: { label: 'left', value: 'slds-float_left', default: true },
    CENTER: { label: 'center', value: 'slds-align_absolute-center' },
    RIGHT: { label: 'right', value: 'slds-float_right' }
}

const ACTION_MODES = {
    NAVIGATION: 'navigation',
    SELECTION: 'selection'
}

const VARIANTS = {
    UNSELECTED: 'neutral',
    SELECTED: 'brand'
}

export default class FlowButtonBar extends LightningElement {
    /* SYSTEM INPUTS */
    @api availableActions = [];

    /* PUBLIC PROPERTIES */
    @api maxNumButtons = 5;

    // 'Navigation mode'-oriented properties
    @api alignment;
    @api orientation;    
    @api showLines;

    // 'Selection mode'-oriented properties
    @api label;
    @api helpText;
    @api multiselect = '';
    @api required = '';
    @api errorMessage;
    @api defaultValue;

    @api previewMode;   // Reserved for future use

    @api cssString; // add style for buttons

    // @api includeLine; replaced by showLines    
    // @api groupAsToggle;  replaced by actionMode
    // @api doNotTransitionOnClick;   replaced by actionMode

    /* PUBLIC GETTERS AND SETTERS */
    // buttons expects either an array of button objects (defined in the CPE) or a JSON string that parses into an array of buttons
    @api
    get buttons() {
        return this._buttons;
    }
    set buttons(buttons) {
        if (Array.isArray(buttons)) {
            this._buttons = buttons;
        } else {
            this._buttons = JSON.parse(buttons);
        }
        if (!this.value && this.defaultValue) {
            this.value = this.defaultValue;
        }
        this.updateSelected();
    }
    _buttons = [];

    // options is simply another way of setting buttons. Meant as a convenience for developers using this component as an input element, to more closely parallel the native components.
    @api
    get options() {
        return this._options;
    }
    set options(options) {
        this._options = options;
        this.buttons = options;
    }
    _options = [];

    @api
    get actionMode() {
        return this._actionMode;
    }
    set actionMode(mode) {
        this._actionMode = mode;
        // if (!this.isSelectionMode) {
        //     this.required = false;
        //     this.multiselect = false;
        // }
    }
    _actionMode;

    @api
    get value() {
        return this.values[0] || null;
    }
    set value(value) {
        this.values = [value];
    }

    @api
    get values() {
        return this._values;
    }
    set values(values) {
        // console.log('setting values, ' + JSON.stringify(values));
        this._values = values ? [...values] : []; // using spread operator to create a shallow clone of the array for mutability
        this.updateSelected();
    }
    _values = [];    




    /* Replaced by value and values
    @api
    get selectedValue() {
        return this._selectedValue;
    }
    set selectedValue(value) {
        this._selectedValue = value;
        this.selectedButton = this.buttons.find(el => el.value == value) || {};
        this.toggleButtons();
    }
    */



    /* PRIVATE VARIABLES */
    // @track _selectedValue;
    @track selectedButton = {};

    @track alignments = this.transformConstantObject(ALIGNMENTS2);

    rendered;

    /* PRIVATE GETTERS AND SETTERS */
    get isVertical() { return this.orientation === VERTICAL; }
    get isSelectionMode() { return this.actionMode !== ACTION_MODES.NAVIGATION; }

    get alignmentClass() {
        //let alignment = this.getValueFromInput(ALIGNMENTS, this.alignment);
        let alignment = this.alignments.findFromLabel(this.alignment).value;
        if (!this.isSelectionMode)
            return alignment + ' notToggle';
        return alignment;
    }

    get lineAbove() {
        return this.showLines == 'above' || this.showLines == 'both';
    }

    get lineBelow() {
        return this.showLines == 'below' || this.showLines == 'both';
    }

    /* LIFECYCLE HOOKS */
    renderedCallback() {
        if (this.rendered) 
            return;
        this.rendered = true;
        this.updateSelected();
    }

    /* EVENT HANDLERS */
    handleButtonClick(event, externalValue) {
        let clickedValue = externalValue || event.currentTarget.value;
        let curIndex = this.values.findIndex(value => value == clickedValue);
        if (curIndex >= 0) {
            // Don't unselect a button if it is both required and the only selected button
            if (!this.required || this.values.length > 1)
                this.values.splice(curIndex, 1);
        } else {
            if (this.multiselect) {
                this.values.push(clickedValue);
            } else {
                this.value = clickedValue;
            }
        }

        this.dispatchClickEvent();
        if (!this.isSelectionMode) {
            this.navigateFlow();
        }
    }

    /* ACTION FUNCTIONS */
    dispatchClickEvent() {
        this.dispatchEvent(new FlowAttributeChangeEvent('value', this.value));
        this.dispatchEvent(new FlowAttributeChangeEvent('values', this.values));
        this.dispatchEvent(new CustomEvent('buttonclick', {
            detail: {
                value: this.value,
                values: this.values
            }
        }));
    }

    updateSelected() {
        
        if (this.isSelectionMode) {
            for (let button of this.template.querySelectorAll('lightning-button')) {
                button.variant = this.values.includes(button.value) ? VARIANTS.SELECTED : VARIANTS.UNSELECTED;
            }
        }
    }

    navigateFlow() {
        if (this.value && this.value.toLowerCase() === 'previous' && this.availableActions.find(action => action === 'BACK')) {
            this.dispatchEvent(new FlowNavigationBackEvent());
        } else {
            if (this.availableActions.find(action => action === 'FINISH')) {
                this.dispatchEvent(new FlowNavigationFinishEvent());
            } else {
                this.dispatchEvent(new FlowNavigationNextEvent());
            }
        }
    }

    @api
    pressButton(buttonIndex) {
        //const button = this.buttons[buttonIndex];
        this.handleButtonClick(null, buttonIndex);
    }

    /* UTILITY FUNCTIONS */
    transformConstantObject(constant) {
        return {
            list: constant,
            get options() { return Object.values(this.list); },
            get default() { return this.options.find(option => option.default); },
            findFromValue: function (value) {
                let entry = this.options.find(option => option.value == value);
                return entry || this.default;
            },
            findFromLabel: function (label) {
                let entry = this.options.find(option => option.label == label);
                return entry || this.default;
            }
        }
    }


    /* DEAD CODE GRAVEYARD */
    /*
    get buttonGroupClass() {
        let classList = [];
        if (this.isVertical) {
            classList.push(VERTICAL_CLASS);
        } else {
            if (this.groupAsToggle) {
                classList.push(BUTTON_GROUP_CLASS);
            }
            classList.push(this.getValueFromInput(ALIGNMENTS, this.alignment));
        }
        return classList.join(' ');
    }
    */

    /*
    // Helper function used to map user-friendly input to a corresponding value
    // If no input or invalid input was found, look for a default value
    // Used for the colourVariants and alignments arrays above
    // valueMap: a list of objects containing two properties each that map a user-friendly value to a system value. Up to 1 object in the list can also have a boolean property with value true to indicate it is the default mapping
    // input: the user-friendly value selected by the user
    // inputParam: name of the property on each object that stores the input value. Default value provided
    // valueParam: name of the property on each object that stores the corresponding system value. Default value provided
    // defaultParam: name of the boolean property for which at most 1 object in the list can have a value of true. Default value provided
    getValueFromInput(valueMap, input, inputParam = 'input', valueParam = 'value', defaultParam = 'default') {
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
        return returnValue[valueParam];
    }
    */

        /* No longer in use
    handleButtonClick(event) {
        if (this.previewMode) {
            return;
        }

        let index = event.currentTarget.dataset.index;
        // console.log('in handleButtonClick, index = ', index);
        // If the current selected button is being clicked again, deselect it. Otherwise, select the button that was just clicked
        this.selectedButton = (index == this.selectedButton.index) ? {} : this.buttons[index];

        this.dispatchEvent(new FlowAttributeChangeEvent('selectedValue', this.selectedButton.value));

        if (this.doNotTransitionOnClick) {
            // console.log('not transitioning');
            this.toggleButtons();
        } else {
            // console.log('navigating');
            // NAVIGATING            
        }
    }
    */
}