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

export default class FlowButtonsCPE extends LightningElement {
    @api maxNumButtons = 5;

    @api orientation;
    @api alignment;
    @api groupAsToggle;
    @api includeLine;

    @track buttons = [];
    @track selectedButton = {};

    connectedCallback() {
        this.setDefaults();
    }

    setDefaults() {
        this.orientation = this.orientation || ORIENTATION.DEFAULT;
        this.alignment = this.alignment || ALIGNMENT.DEFAULT;
        if (this.buttons.length === 0) {

        }
    }

    addButton() {
        this.buttons.push({
            label: 'New button',
            value: 'newButton',
            index: this.buttons.length
        });
    }

    /* GETTERS */
    get isVertical() { return this.orientation === ORIENTATION.VERTICAL; }

    get newButtonDisabled() { return this.buttons.length >= this.maxNumButtons; }

    get orientationOptions() {
        return ORIENTATION.LIST.map(el => { 
            return { label: el, value: el}
        });
    }

    get alignmentOptions() {
        return ALIGNMENT.LIST.map(el => { 
            return { label: el, value: el}
        });
    }

    /* EVENT HANDLERS */
    handleButtonClick(event) {
        let index = event.currentTarget.dataset.index;
        // If the current selected button is being clicked again, deselect it. Otherwise, select the button that was just clicked
        this.selectedButton = (index == this.selectedButton.index) ? {} : this.buttons[index];    

        console.log('selectedButton = '+ JSON.stringify(this.selectedButton));
    }

    handleNewButtonClick() {
        this.addButton();
    }

    handleOrientationChange(event) {
        this.orientation = event.detail.value;
    }

    handleAlignmentChange(event) {
        this.alignment = event.detail.value;
    }
} 