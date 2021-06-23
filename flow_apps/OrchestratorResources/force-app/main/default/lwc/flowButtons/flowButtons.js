import { LightningElement, api, wire, track } from 'lwc';
import { FlowAttributeChangeEvent, FlowNavigationNextEvent, FlowNavigationBackEvent, FlowNavigationFinishEvent } from 'lightning/flowSupport';

const colourVariants = [
    { input: 'red', value: 'destructive' },
    { input: 'blue', value: 'brand' },
    { input: 'green', value: 'success' },
    { input: 'neutral', value: 'neutral', default: true }
];
const alignments = [
    { input: 'left', value: 'slds-float_left' },
    { input: 'center', value: 'slds-align_absolute-center' },
    { input: 'right', value: 'slds-float_right', default: true }
];
const delim = ',';
const defaultButtonLabelString = 'Previous, Next';  // Duplicated from the xml file

export default class FlowButtons extends LightningElement {
    @api availableActions = [];

    // Public variable buttonLabelString. When set, call the updateLabels() function
    @api
    get buttonLabelString() {
        return this._buttonLabelString;
    }
    set buttonLabelString(value) {
        this._buttonLabelString = value;
        this.updateLabels();
    }
    _buttonLabelString;

    // Public variable buttonLabelString. When set, call the updateColours() function
    @api
    get buttonColourString() {
        return this._buttonColourString;
    }
    set buttonColourString(value) {
        this._buttonColourString = value;
        this.updateColours();
    }
    _buttonColourString;

    // Public variable floatLeft that controls the float direction of the buttons. It's boolean, with false meaning left and true meaning right
    @api alignment;
    // Evaluates the proper class for button alignment based on the user's input
    get floatClass() {
        return this.getValueFromInput(alignments, this.alignment);
    }

    // Public variable that shows or hides a horizontal line above the buttons
    @api includeLine;

    // Send selectedValue back to Flow
    @api selectedValue;

    // Array of buttons, to be populated by parsing the passed in strings
    @track buttons = [];

    connectedCallback() {
        if (!this.buttonLabelString)
            this.buttonLabelString = defaultButtonLabelString;
    }

    updateLabels() {
        this.buttons = [];
        for (let label of this.buttonLabelString.split(delim)) {
            label = label.trim();
            let newButton = {
                label: label
            };
            this.buttons.push(newButton);
        }
        this.updateColours();
    }

    updateColours() {
        if (this.buttonColourString) {
            let colours = this.buttonColourString.toLowerCase().split(delim);
            if (colours) {
                // Hopefully the user has provided equal numbers of button labels and button colours, but if not we simply take the lower number
                let maxIndex = Math.min(colours.length, this.buttons.length);
                // Loop through the buttons and assign the proper colour to the button. If no valid colour was entered, assign the default
                for (let i = 0; i < maxIndex; i++) {
                    let colour = colours[i].trim().toLowerCase();
                    this.buttons[i].variant = this.getValueFromInput(colourVariants, colour);
                }
            }
        }
    }

    handleButtonClick(event) {
        let value = event.currentTarget.label;
        this.selectedValue = value;
        this.dispatchEvent(new FlowAttributeChangeEvent('selectedValue', value));
        if (value.toLowerCase() === 'previous') {
            this.dispatchEvent(new FlowNavigationBackEvent());
        } else {          
            if (this.availableActions.find(action => action === 'FINISH')) {
                this.dispatchEvent(new FlowNavigationFinishEvent());
            } else {
                this.dispatchEvent(new FlowNavigationNextEvent());
            }            
        }
    }

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