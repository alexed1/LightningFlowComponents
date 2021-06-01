import { LightningElement, api, track } from 'lwc';
import { FlowAttributeChangeEvent, FlowNavigationNextEvent, FlowNavigationBackEvent, FlowNavigationFinishEvent } from 'lightning/flowSupport';

const BUTTON_GROUP_CLASS = 'slds-button-group';
const VERTICAL_CLASS = 'slds-grid slds-grid_vertical';
const VERTICAL = 'vertical';
const BUTTON_PROPERTIES = ['Label', 'Value', 'DescriptionText'];

const ALIGNMENTS = [
    { input: 'left', value: 'slds-float_left' },
    { input: 'center', value: 'slds-align_absolute-center' },
    { input: 'right', value: 'slds-float_right', default: true }
];

/* Not in use yet
const COLOUR_VARIANTS = [
    { input: 'red', value: 'destructive' },
    { input: 'blue', value: 'brand' },
    { input: 'green', value: 'success' },
    { input: 'neutral', value: 'neutral', default: true }
];
*/

export default class FlowButtons2 extends LightningElement {
    /* SYSTEM INPUTS */
    @api availableActions = [];

    /* PUBLIC PROPERTIES */
    @api maxNumButtons = 5;

    @api button1Label;
    @api button1Value;
    @api button1DescriptionText;
    @api button2Label;
    @api button2Value;
    @api button2DescriptionText;
    @api button3Label;
    @api button3Value;
    @api button3DescriptionText;
    @api button4Label;
    @api button4Value;
    @api button4DescriptionText;
    @api button5Label;
    @api button5Value;
    @api button5DescriptionText;

    @api alignment;
    @api orientation;
    @api groupAsToggle;
    @api includeLine;

    @api doNotTransitionOnClick;

    @api
    get selectedValue() {
        return this._selectedValue;
    }
    set selectedValue(value) {
        this._selectedValue = value;
        this.selectedButton = this.buttons.find(el => el.Value === value) || {};
        this.toggleButtons();
    }

    /* PRIVATE VARIABLES */
    @track _selectedValue;
    @track selectedButton = {};
    rendered;

    /* GETTERS */
    get isVertical() { return this.orientation === VERTICAL; }

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

    get buttons() {
        let buttons = [];
        for (let i = 0; i < this.maxNumButtons; i++) {
            if (this['button' + (i + 1) + 'Label']) {
                let button = {
                    index: buttons.length
                }
                for (let property of BUTTON_PROPERTIES) {
                    button[property] = this['button' + (i + 1) + property];
                }
                if (!button.Value && button.Label)
                    button.Value = button.Label;
                buttons.push(button);
            }
        }
        return buttons;
    }

    /* LIFECYCLE HOOKS */
    renderedCallback() {
        if (this.rendered) return;
        this.rendered = true;
        this.toggleButtons();
    }

    /* EVENT HANDLERS */
    handleButtonClick(event) {
        let index = event.currentTarget.dataset.index;
        // If the current selected button is being clicked again, deselect it. Otherwise, select the button that was just clicked
        this.selectedButton = (index == this.selectedButton.index) ? {} : this.buttons[index];
        
        this.dispatchEvent(new FlowAttributeChangeEvent('selectedValue', this.selectedButton.Value));
        if (this.doNotTransitionOnClick) {
            this.toggleButtons();
        } else {
            // NAVIGATING            
            if (this.selectedButton.Value.toLowerCase() === 'previous') {
                this.dispatchEvent(new FlowNavigationBackEvent());
            } else {
                if (this.availableActions.find(action => action === 'FINISH')) {
                    this.dispatchEvent(new FlowNavigationFinishEvent());
                } else {
                    this.dispatchEvent(new FlowNavigationNextEvent());
                }
            }
        }
    }

    /* ACTION FUNCTIONS */
    toggleButtons() {
        for (let buttonEl of this.template.querySelectorAll('button')) {
            if (buttonEl.dataset.index == this.selectedButton.index) {
                buttonEl.classList.add('slds-button_brand');
                buttonEl.classList.remove('slds-button_neutral');
            } else {
                buttonEl.classList.add('slds-button_neutral');
                buttonEl.classList.remove('slds-button_brand');
            }
        }
    }

    /* UTILITY FUNCTIONS */
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
}