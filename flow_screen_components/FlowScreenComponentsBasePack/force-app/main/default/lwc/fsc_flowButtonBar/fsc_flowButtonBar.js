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

export default class fsc_FlowButtonBar extends LightningElement {
    /* SYSTEM INPUTS */
    @api availableActions = [];

    /* PUBLIC PROPERTIES */
    @api maxNumButtons = 5;

    /*
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
    */


    @api
    get buttons() {
        return this._buttons;
    }
    set buttons(value) {
        // console.log(JSON.parse(JSON.stringify(value)));
        // for (let button of JSON.parse(JSON.stringify(value))) {
        //     console.log('looping through button: ', button);
        // }
        if (Array.isArray(value)) {
            this._buttons = value;
        } else {
            this._buttons = JSON.parse(value);
        }
        // console.log(this._buttons);
    }
    _buttons;

    @api alignment;
    @api orientation;
    @api groupAsToggle;
    @api includeLine;
    @api showLines;

    @api doNotTransitionOnClick;

    @api previewMode;

    @api
    get selectedValue() {
        return this._selectedValue;
    }
    set selectedValue(value) {
        this._selectedValue = value;
        this.selectedButton = this.buttons.find(el => el.value === value) || {};
        this.toggleButtons();
    }

    /* PRIVATE VARIABLES */
    @track _selectedValue;
    @track selectedButton = {};
    rendered;

    /* GETTERS */
    get isVertical() { return this.orientation === VERTICAL; }

    get alignmentClass() {
        let alignment = this.getValueFromInput(ALIGNMENTS, this.alignment);
        if (!this.groupAsToggle)
            return alignment + ' notToggle';
        return alignment;
    }

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

    get lineAbove() {
        return this.showLines == 'above' || this.showLines == 'both';
    }

    get lineBelow() {
        return this.showLines == 'below' || this.showLines == 'both';
    }

    /* LIFECYCLE HOOKS */
    renderedCallback() {
        if (this.rendered) return;
        this.rendered = true;
        this.toggleButtons();
        //this.groupAsToggle = true;
        // console.log('groupAsToggle = ' + this.groupAsToggle);
        // console.log('doNotTransitionOnClick = ' + this.doNotTransitionOnClick);
        // console.log('availableActions = ' + this.availableActions);
    }

    /* EVENT HANDLERS */
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
            if (this.selectedButton.value.toLowerCase() === 'previous') {
                this.dispatchEvent(new FlowNavigationBackEvent());
            } else {
                if (this.availableActions.find(action => action === 'FINISH')) {
                    // console.log('finishing');
                    this.dispatchEvent(new FlowNavigationFinishEvent());
                } else {
                    // console.log('nexting');
                    this.dispatchEvent(new FlowNavigationNextEvent());
                }
            }
        }
    }

    /* ACTION FUNCTIONS */
    toggleButtons() {
        if (this.doNotTransitionOnClick) {
            for (let buttonEl of this.template.querySelectorAll('lightning-button')) {
                if (buttonEl.dataset.index == this.selectedButton.index) {
                    buttonEl.variant = 'brand';
                } else {
                    buttonEl.variant = 'neutral';
                }
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