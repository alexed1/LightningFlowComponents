import { LightningElement, track, api } from 'lwc';

const ICON_CATEGORY_OPTIONS = [
    { label: 'Standard', value: 'standard', default: true },
    { label: 'Custom', value: 'custom', default: true },
    { label: 'Utility', value: 'utility', default: true },
    { label: 'Action', value: 'action', default: false }
];

const DISPLAY_MODE_OPTIONS = [
    { label: 'Combobox', value: 'combobox' },
    { label: 'Accordion', value: 'accordion' },
    { label: 'Tab', value: 'tab' }
];

const DATA_TYPE = {
    STRING: 'String',
    BOOLEAN: 'Boolean',
    NUMBER: 'Number',
}

const DEFAULT_LABEL = 'Pick an Icon';
const MODE_REQUIRED_ERROR = 'A display mode is required, please select one of the modes.';

export default class Fsc_pickIconCpe extends LightningElement {

    @api builderContext;

    @api
    get inputVariables() {
        return this._values;
    }
    set inputVariables(value) {
        this._values = value;

        this.initializeValues();
    }
    _values;

    @track inputValues = {
        mode: { value: null, valueDataType: null, isCollection: false, label: 'Mode' },
        iconCategories: { value: null, valueDataType: null, isCollection: false, label: 'Available Icon Categories' },
        label: { value: DEFAULT_LABEL, valueDataType: null, isCollection: false, label: 'Label' },
        iconName: { value: null, valueDataType: null, isCollection: false, label: 'Icon Name' }
    };
    
    @track iconCategories = this.defaultCategories;

    initializeValues() {
        if (this._values && this._values.length) {
            this._values.forEach(curInputParam => {
                if (curInputParam.name && this.inputValues[curInputParam.name]) {
                    if (curInputParam.name == 'iconCategories') {
                        this.iconCategories = curInputParam.value.split(',');
                    } else {
                        this.inputValues[curInputParam.name].value = curInputParam.value;
                        this.inputValues[curInputParam.name].valueDataType = curInputParam.valueDataType;
                    }                    
                }
            });
        }
    }

    dispatchFlowValueChangeEvent(id, newValue, newValueDataType) {
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
        console.log('dispatched flow change event, detail: ' + JSON.stringify(valueChangedEvent.detail));
    }

    /* COMPONENT */

    iconCategoryOptions = ICON_CATEGORY_OPTIONS;
    displayModeOptions = DISPLAY_MODE_OPTIONS;

    get defaultCategories() {
        let defaults = [];
        for (let category of ICON_CATEGORY_OPTIONS) {
            if (category.default) {
                defaults.push(category.value);
            }
        };
        return defaults;
    }

    handleButtonClick(event) {
        let name = event.currentTarget.name;
        if (name) {
            let value = event.detail.values.join();
            if (value)
                this.template.querySelector('.modeToggle').errorMessage = null;
            this.dispatchFlowValueChangeEvent(name, value, DATA_TYPE.STRING);
        }
    }

    handleInputChange(event) {
        let name = event.currentTarget.name;
        if (name) {
            let value = event.detail.value;
            this.dispatchFlowValueChangeEvent(name, value, DATA_TYPE.STRING);
        }
    }

    @api validate() {
        const validity = [];
        if (!this.inputValues.mode.value) {
            this.template.querySelector('.modeToggle').errorMessage = MODE_REQUIRED_ERROR;
            validity.push({
                key: 'Display Mode Required',
                errorString: MODE_REQUIRED_ERROR,
            });
        }
        return validity;
    }
}