import {api, track, LightningElement} from 'lwc';

export default class QuickChoiceCpe extends LightningElement {
    _builderContext;
    _values;

    @track inputValues = {
        displayMode: {value: null, valueDataType: null, isCollection: false, label: 'Display the choices as:'},
        inputMode: {value: null, valueDataType: null, isCollection: false, label: 'Select datasource:'},
        allowNoneToBeChosen: {value: null, valueDataType: null, isCollection: false, label: 'Add a \'None\' choice'},
        sortList: {value: null, valueDataType: null, isCollection: false, label: 'Sort Picklist by Label'},
        required: {value: null, valueDataType: null, isCollection: false, label: 'Required'},
        masterLabel: {value: null, valueDataType: null, isCollection: false, label: 'Master Label'},
        value: {value: null, valueDataType: null, isCollection: false, label: 'Value (Default or Existing)'},
        style_width: {value: null, valueDataType: null, isCollection: false, label: 'Width (Pixels)'},
        numberOfColumns: {value: null, valueDataType: null, isCollection: false, label: 'Number of Columns'},
        includeIcons: {value: null, valueDataType: null, isCollection: false, label: 'Show Icons'},
        navOnSelect: {value: false, valueDataType: null, isCollection: false, label: 'InstantNavigation Mode'},
        choiceIcons: {value: null, valueDataType: null, isCollection: true, label: 'Choice Icons [Card Icons]'},
        iconSize: {value: null, valueDataType: null, isCollection: false, label: 'Icon Size'},
        objectName: {value: null, valueDataType: null, isCollection: false, label: 'Select Object'},
        fieldName: {value: null, valueDataType: null, isCollection: false, label: 'Select Field'},
        recordTypeId: {value: null, valueDataType: null, isCollection: false, label: 'Filter on Record Type ID:'},
        choiceLabels: {value: null, valueDataType: null, isCollection: true, label: 'Choice Labels [Card Titles]'},
        choiceValues: {value: null, valueDataType: null, isCollection: true, label: 'Choice Values [Card Descriptions]'},
    };

    settings = {
        displayModeVisualCards: 'Visual',
        displayModePicklist: 'Picklist',
        displayModeRadio: 'Radio',
        inputModePicklist: 'Picklist Field',
        inputModeDualCollection: 'Dual String Collections',
        inputModeSingleCollection: 'Single String Collection',
        inputValueRecordTypeId: 'recordTypeId',
        choiceLabelsPicklistLabelsLabel: 'Choice Labels',
        choiceLabelsPicklistValuesLabel: 'Choice Values',
        choiceLabelsCardLabelsLabel: 'Card Titles',
        choiceLabelsCardValuesLabel: 'Card Descriptions',
        attributeObjectName: 'objectName',
        attributeFieldName: 'fieldName',
        attributeInputMode: 'inputMode',
        flowDataTypeString: 'String',
        availableFieldTypesPicklist: 'Picklist',
        inputAttributePrefix: 'select_'
    }

    displayChoicesAsOptions = [
        {label: 'Picklist', value: 'Picklist'},
        {label: 'Radio Button Group', value: 'Radio'},
        {label: 'Visual Cards', value: 'Visual'}
    ];

    numberOfColumnOptions = [
        {label: '1', value: '1'},
        {label: '2', value: '2'}
    ];

    iconSizeOptions = [
        {label: 'x-small', value: 'x-small'},
        {label: 'small', value: 'small'},
        {label: 'medium', value: 'medium'},
        {label: 'large', value: 'large'}
    ];

    selectDataSourceOptions = [
        {label: 'A Picklist field', value: this.settings.inputModePicklist},
        {label: 'Two String Collections (Labels and Values)', value: this.settings.inputModeDualCollection},
        {label: 'One String Collection (Values)', value: this.settings.inputModeSingleCollection}
    ];

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

    get isVisualCards() {
        return this.inputValues.displayMode.value === this.settings.displayModeVisualCards;
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

    initializeValues(value) {
        if (this._values && this._values.length) {
            this._values.forEach(curInputParam => {
                if (curInputParam.name && this.inputValues[curInputParam.name]) {
                    this.inputValues[curInputParam.name].value = curInputParam.value;
                    this.inputValues[curInputParam.name].valueDataType = curInputParam.valueDataType;
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
