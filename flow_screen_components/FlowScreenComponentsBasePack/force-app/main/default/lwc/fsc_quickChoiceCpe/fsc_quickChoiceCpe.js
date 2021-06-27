import { api, track, LightningElement } from 'lwc';

export default class QuickChoiceCpe extends LightningElement {
    static delegatesFocus = true;

    _builderContext;
    _values;

    @api staticChoicesString;

    @track inputValues = {
        displayMode: { value: null, valueDataType: null, isCollection: false, label: 'Display the choices as:' },
        isResponsive: { value: null, valueDataType: null, isCollection: false, label: 'Make Card Size Responsive' },
        inputMode: { value: null, valueDataType: null, isCollection: false, label: 'Select datasource:' },
        allowNoneToBeChosen: { value: null, valueDataType: null, isCollection: false, label: 'Add a \'None\' choice' },
        sortList: { value: null, valueDataType: null, isCollection: false, label: 'Sort Picklist by Label' },
        required: { value: null, valueDataType: null, isCollection: false, label: 'Required' },
        masterLabel: { value: null, valueDataType: null, isCollection: false, label: 'Master Label' },
        value: { value: null, valueDataType: null, isCollection: false, label: 'Value (Default or Existing)' },
        style_width: { value: null, valueDataType: null, isCollection: false, label: 'Width (Pixels)' },
        numberOfColumns: { value: null, valueDataType: null, isCollection: false, label: 'Number of Columns' },
        includeIcons: { value: null, valueDataType: null, isCollection: false, label: 'Show Icons' },
        navOnSelect: { value: false, valueDataType: null, isCollection: false, label: 'InstantNavigation Mode' },
        choiceIcons: { value: null, valueDataType: null, isCollection: true, label: 'Choice Icons [Card Icons]' },
        iconSize: { value: null, valueDataType: null, isCollection: false, label: 'Icon Size' },
        objectName: { value: null, valueDataType: null, isCollection: false, label: 'Select Object' },
        fieldName: { value: null, valueDataType: null, isCollection: false, label: 'Select Field' },
        recordTypeId: { value: null, valueDataType: null, isCollection: false, label: 'Filter on Record Type ID:' },
        choiceLabels: { value: null, valueDataType: null, isCollection: true, label: 'Choice Labels [Card Titles]' },
        choiceValues: { value: null, valueDataType: null, isCollection: true, label: 'Choice Values [Card Descriptions]' },
        staticChoicesString: { value: null, valueDataType: null, isCollection: false, label: 'String of Static Choice (JSON)' }
    };

    settings = {
        displayModeVisualCards: 'Visual',
        displayModePicklist: 'Picklist',
        displayModeRadio: 'Radio',
        inputModePicklist: 'Picklist Field',
        inputModeDualCollection: 'Dual String Collections',
        inputModeSingleCollection: 'Single String Collection',
        inputModeStaticChoices: 'Static Choices',
        inputValueRecordTypeId: 'recordTypeId',
        choiceLabelsPicklistLabelsLabel: 'Choice Labels',
        choiceLabelsPicklistValuesLabel: 'Choice Values',
        choiceLabelsCardLabelsLabel: 'Card Titles (Labels)',
        choiceLabelsCardValuesLabel: 'Card Descriptions (Values)',
        attributeObjectName: 'objectName',
        attributeFieldName: 'fieldName',
        attributeInputMode: 'inputMode',
        flowDataTypeString: 'String',
        availableFieldTypesPicklist: 'Picklist',
        inputAttributePrefix: 'select_',
        singleColumn: '1'
    }

    displayChoicesAsOptions = [
        { label: 'Picklist', value: 'Picklist' },
        { label: 'Radio Button Group', value: 'Radio' },
        { label: 'Visual Cards', value: 'Visual' }
    ];

    numberOfColumnOptions = [
        { label: '1', value: '1' },
        { label: '2', value: '2' }
    ];

    iconSizeOptions = [
        { label: 'x-small', value: 'x-small' },
        { label: 'small', value: 'small' },
        { label: 'medium', value: 'medium' },
        { label: 'large', value: 'large' }
    ];

    selectDataSourceOptions = [
        { label: 'A Picklist field', value: this.settings.inputModePicklist },
        { label: 'Two String Collections (Labels and Values)', value: this.settings.inputModeDualCollection },
        { label: 'One String Collection (Values)', value: this.settings.inputModeSingleCollection },
        { label: 'Static Choices', value: this.settings.inputModeStaticChoices }
    ];

    useValuesOptions = [
        { label: 'Yes', value: 'true' },
        { label: 'No', value: null }
    ]
    useValues;
    get disableLabels() { return !this.useValues; }
    handleUseValuesClick(event) {
        this.useValues = event.detail.value;
    }

    @api get builderContext() {
        return this._builderContext;
    }

    set builderContext(value) {
        this._builderContext = value;
    }

    @api get inputVariables() {
        return this._values;
    }

    @track staticChoices = [this.newChoice()];
    @track tempStaticChoices = [];

    set inputVariables(value) {
        this._values = value;
        this.initializeValues();
    }

    get isVisualCards() {
        return this.inputValues.displayMode.value === this.settings.displayModeVisualCards;
    }

    get isSingleColumn() {
        return this.inputValues.numberOfColumns.value === this.settings.singleColumn;
    }

    get isDatasourcePicklist() {
        return this.inputValues.inputMode.value === this.settings.inputModePicklist;
    }

    get isDatasourceDualCollection() {
        return this.inputValues.inputMode.value === this.settings.inputModeDualCollection;
    }

    get isNavOnSelect() {
        return this.inputValues.inputMode.value === this.settings.navOnSelect;
    }

    get isDatasourceSingleOrDualCollection() {
        return this.inputValues.inputMode.value === this.settings.inputModeSingleCollection || this.inputValues.inputMode.value === this.settings.inputModeDualCollection;
    }

    get isDatasourceStaticChoices() {
        return this.inputValues.inputMode.value === this.settings.inputModeStaticChoices;
    }

    get staticChoicesModal() {
        return this.template.querySelector('c-lwc-modal');
    }

    initializeValues(value) {
        if (this._values && this._values.length) {

            this._values.forEach(curInputParam => {
                if (curInputParam.name && this.inputValues[curInputParam.name]) {
                    this.inputValues[curInputParam.name].value = curInputParam.value;
                    this.inputValues[curInputParam.name].valueDataType = curInputParam.valueDataType;
                    if (curInputParam.name === 'staticChoicesString') {
                        // console.log('The current input param is staticChoicesString, so we parse it into our staticChoices variable.');
                        this.staticChoices = JSON.parse(curInputParam.value);
                    }

                }
            });
        }
        this.setInputMode();
        this.setChoiceLabels();
    }

    setChoiceLabels() {
        if (this.inputValues.displayMode.value === this.settings.displayModeVisualCards &&
            this.inputValues.choiceLabels.label !== this.settings.choiceLabelsCardLabelsLabel) {
            this.inputValues.choiceLabels.label = this.settings.choiceLabelsCardLabelsLabel;
            this.inputValues.choiceValues.label = this.settings.choiceLabelsCardValuesLabel;
        }
        if (this.inputValues.displayMode.value !== this.settings.displayModeVisualCards &&
            this.inputValues.choiceLabels.label !== this.settings.choiceLabelsPicklistLabelsLabel) {
            this.inputValues.choiceLabels.label = this.settings.choiceLabelsPicklistLabelsLabel;
            this.inputValues.choiceValues.label = this.settings.choiceLabelsPicklistValuesLabel;
        }
    }

    setInputMode() {
        if (this.inputValues.displayMode.value === this.settings.displayModeVisualCards && this.inputValues.inputMode.value !== this.settings.inputModeDualCollection) {
            this.dispatchFlowValueChangeEvent(this.settings.attributeInputMode, this.settings.inputModeDualCollection, this.settings.flowDataTypeString);
        }
    }

    newChoice(label, value) {
        return {
            label: label,
            value: value,
            // I don't know why, but I kept getting an error when I used the variable name 'value', so I'm reflecting it like Medusa's gaze
            // get safeValue() { return this.value; },
            // set safeValue(value) { this.value = value; },

            // valuex: null
        }
    }

    handlePickObjectAndFieldValueChange(event) {
        if (event.detail) {
            this.dispatchFlowValueChangeEvent(this.settings.attributeObjectName, event.detail.objectType, this.settings.flowDataTypeString);
            this.dispatchFlowValueChangeEvent(this.settings.attributeFieldName, event.detail.fieldName, this.settings.flowDataTypeString);
        }
    }

    handleFlowComboboxValueChange(event) {
        if (event.target && event.detail) {
            this.dispatchFlowValueChangeEvent(event.target.name.replace(this.settings.inputAttributePrefix, ''), event.detail.newValue, event.detail.newValueDataType);
        }
    }

    handleValueChange(event) {
        if (event.target) {
            let curAttributeName = event.target.name ? event.target.name.replace(this.settings.inputAttributePrefix, '') : null;
            let curAttributeValue = event.target.type === 'checkbox' ? event.target.checked : event.detail.value;
            let curAttributeType;
            switch (event.target.type) {
                case "checkbox":
                    curAttributeType = 'Boolean';
                    break;
                case "number":
                    curAttributeType = 'Number';
                    break;
                default:
                    curAttributeType = 'String';
            }
            this.dispatchFlowValueChangeEvent(curAttributeName, curAttributeValue, curAttributeType);
        }
    }

    // Static Choice event handlers
    
    handleStaticChoiceFocus(event) {
        if (event.currentTarget) {
            let value = event.currentTarget.value;
            if (value && value.length) {
                event.currentTarget.selectionStart = 0;
                event.currentTarget.selectionEnd = value.length;
            }
        }
    }

    /*
    // Goal is to have the Value autopopulate from the Label after a user blurs from label
    handleStaticChoiceBlur(event) {
        let propertyName = event.currentTarget.dataset.property;
        if (propertyName === 'label') {
            let valueInput = this.template.querySelector('.staticChoiceRow lightning-input[data-property="value"][data-index="' + event.currentTarget.dataset.index + '"]');
            if (!valueInput || !valueInput.value) {
                valueInput.value = event.currentTarget.value;
            }
        }
    }
    */

    handleStaticChoiceChange(event) {
        console.log('in handleStaticChoiceChange');
        const index = event.currentTarget.dataset.index;
        const value = event.currentTarget.value;
        let propertyName = event.currentTarget.dataset.property;
        console.log('index = ' + index, 'value = ' + value, 'propertyName = ' + propertyName);
        console.log('changedChoice = ' + JSON.stringify(this.tempStaticChoices[index]));
        // changedChoice[propertyName] = value;
        this.tempStaticChoices[index][propertyName] = value;
        console.log('changedChoice = ' + JSON.stringify(this.tempStaticChoices[index]));
    }

    handleAddChoiceClick() {
        // console.log('in handleAddChoiceClick');
        let newChoice = this.newChoice();
        console.log('newChoice = ' + JSON.stringify(newChoice));
        this.tempStaticChoices.push(newChoice);
        console.log('tempStaticChoices = ' + JSON.stringify(this.tempStaticChoices), 'length = '+ this.tempStaticChoices.length);
        let newIndex = this.tempStaticChoices.length - 1;
        console.log('newIndex = '+ newIndex);
        // let focusSelectorString = '.staticChoiceRow lightning-input[data-index="'+ (this.tempStaticChoices.length - 1) +'"]';
        let focusSelectorString = '.staticChoiceRow lightning-input[data-index="'+ newIndex +'"]';


        this.staticChoicesModal.focusSelectorString = focusSelectorString;
        console.log('this.staticChoicesModal.focusSelectorString = '+ this.staticChoicesModal.focusSelectorString);
        return;
        

        console.log('focusSelectorString = '+ focusSelectorString);
        let inputs = this.template.querySelectorAll(focusSelectorString);
        console.log('inputs = '+ JSON.stringify(inputs) +' there are '+ inputs.length +' inputs');
        if (inputs.length) {
            let firstInput = inputs[0];            
            console.log('firstInput = '+ firstInput);
            this.staticChoicesModal.focusElement(firstInput);
        }
        //let focusSuccess = this.staticChoicesModal.focusSelector(focusSelectorString);
        // console.log('focus success = '+ focusSuccess);

        // this.staticChoicesModal.focusIndex = (this.tempStaticChoices.length * 2 - 2);   // TODO: Focus doesn't work properly right now
    }

    handleClearAllChoicesClick() {
        this.tempStaticChoices = [this.newChoice()];
        this.staticChoices.focusSelectorString = '.staticChoiceRow lightning-input';
        // this.staticChoicesModal.updateFocusElements();
    }

    handleStaticChoicesOpen() {
        // console.log('opening modal');
        this.tempStaticChoices = this.staticChoices.map(choice => { return Object.assign({}, choice); });
        // if (!this.tempStaticChoices.length)
        //     this.tempStaticChoices = [this.newChoice()];
        this.staticChoicesModal.open();
    }

    handleStaticChoiceMoveUp(event) {
        console.log('in handleStaticChoiceMoveUp');
        let index = event.currentTarget.dataset.index;
        if (index) {// this includes index of 0, which can't be moved up
            const movingChoice = this.tempStaticChoices.splice(index, 1);
            this.tempStaticChoices.splice(index - 1, 0, ...movingChoice);
        }
    }

    handleStaticChoiceMoveDown(event) {
        console.log('in handleStaticChoiceMoveDown');
        let index = event.currentTarget.dataset.index;
        if (index && this.index != this.tempStaticChoices.length - 1) { // this includes the final index, which can't be moved down
            const movingChoice = this.tempStaticChoices.splice(index, 1);
            index++;
            this.tempStaticChoices.splice(index, 0, ...movingChoice);
        }
    }


    handleStaticChoicesSave() {
        console.log('in handleStaticChoicesSave');
        // this.staticChoices = this.tempStaticChoices.map(choice => { return choice; } );
        let isValid = true;
        let inputs = this.template.querySelectorAll('c-lwc-modal lightning-input');
        if (!inputs.length || !this.tempStaticChoices.length) {
            console.log('Error: Cannot save an empty set of choices');
            return;
        }
        // console.log('Checking each input field to see if it\'s valid (i.e. not blank), and communicating to the user any blank fields.');
        for (let input of inputs) {
            isValid = input.reportValidity() && isValid;
        }
        if (isValid) {
            this.staticChoices = this.tempStaticChoices.map(choice => {
                return { label: choice.label, value: choice.value }
            })
            console.log('on save, staticChoices = '+ JSON.stringify(this.staticChoices));
            this.tempStaticChoices = [];
            this.staticChoicesModal.close();
            this.inputValues.staticChoicesString.value = JSON.stringify(this.staticChoices);
            this.dispatchFlowValueChangeEvent('staticChoicesString', this.inputValues.staticChoicesString.value, this.settings.flowDataTypeString);
        }
    }

    handleStaticChoiceDelete(event) {
        const index = event.currentTarget.dataset.index;
        this.tempStaticChoices.splice(index, 1);
        if (this.tempStaticChoices.length === 0) {
            this.tempStaticChoices.push(this.newChoice());
            // this.setFocus(0);
        }
    }

    handleDropzoneDrop(event) {
        console.log('initial list = ' + JSON.stringify(this.tempStaticChoices))
        this.tempStaticChoices = event.detail.reorderedList;
        console.log('reorderedList = ' + JSON.stringify(this.tempStaticChoices));
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
    }
}
