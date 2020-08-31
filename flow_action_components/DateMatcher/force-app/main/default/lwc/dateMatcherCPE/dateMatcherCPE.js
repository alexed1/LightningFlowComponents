
import {api, track, LightningElement} from 'lwc';

export default class DateMatcherCPE extends LightningElement {
    _builderContext;
    _values;

    @track inputValues = {
        weekOfMonthNumber: {value: null, valueDataType: null, isCollection: false, label: 'Select Week:'},
        dayOfWeekNumber: {value: null, valueDataType: null, isCollection: false, label: 'Day of Week:'},
        monthOfYearNumber: {value: null, valueDataType: null, isCollection: false, label: 'Month of Year:'},
        testType: {value: null, valueDataType: null, isCollection: false, label: 'Test Type:'},
        dayOfMonthNumber: {value: null, valueDataType: null, isCollection: false, label: 'Day of Month:'},

        displayMode: {value: null, valueDataType: null, isCollection: false, label: 'Display the choices as:'},
        inputMode: {value: null, valueDataType: null, isCollection: false, label: 'Select datasource:'},
        allowNoneToBeChosen: {value: null, valueDataType: null, isCollection: false, label: 'Add a \'None\' choice'},
        required: {value: null, valueDataType: null, isCollection: false, label: 'Required'},
        masterLabel: {value: null, valueDataType: null, isCollection: false, label: 'Master Label'},
        value: {value: null, valueDataType: null, isCollection: false, label: 'Value (Default or Existing)'},
        style_width: {value: null, valueDataType: null, isCollection: false, label: 'Width (Pixels)'},
        includeIcons: {value: null, valueDataType: null, isCollection: false, label: 'Show Icons'},
        choiceIcons: {value: null, valueDataType: null, isCollection: true, label: 'Choice Icons [Card Icons]'},
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

    weekOfMonthNumber = [
        {label: '1st', value: '1'},
        {label: '2nd', value: '2'},
        {label: '3rd', value: '3'},
        {label: '4th', value: '4'},
        {label: '5th', value: '5'},
    ];

    testType = [
        {label: 'NthWeekdayOfAnyMonth ("the third Wednesday each month")', value: 'NthWeekdayOfAnyMonth'},
        {label: 'NthWeekdayOfSpecificMonth ("the third Wednesday in August")', value: 'NthWeekdayOfSpecificMonth'},
        {label: 'NthDayOfMonth ("the 23rd of August")', value: 'NthDayOfMonth'}
    ];

    dayOfWeekNumber = [
        {label: 'Monday', value: '1'},
        {label: 'Tuesday', value: '2'},
        {label: 'Wednesday', value: '3'},
        {label: 'Thursday', value: '4'},
        {label: 'Friday', value: '5'},
        {label: 'Saturday', value: '6'},
        {label: 'Sunday', value: '7'},
    ];

    dayOfMonthNumber = [
        {label: '1', value: '1'},
        {label: '2', value: '2'},
        {label: '3', value: '3'},
        {label: '4', value: '4'},
        {label: '5', value: '5'},
        {label: '6', value: '6'},
        {label: '7', value: '7'},
        {label: '8', value: '8'},
        {label: '9', value: '9'},
        {label: '10', value: '10'},
        {label: '11', value: '11'},
        {label: '12', value: '12'},
        {label: '13', value: '13'},
        {label: '14', value: '14'},
        {label: '15', value: '15'},
        {label: '16', value: '16'},
        {label: '17', value: '17'},
        {label: '18', value: '18'},
        {label: '19', value: '19'},
        {label: '20', value: '20'},
        {label: '21', value: '21'},
        {label: '22', value: '22'},
        {label: '23', value: '23'},
        {label: '24', value: '24'},
        {label: '25', value: '25'},
        {label: '26', value: '26'},
        {label: '27', value: '27'},
        {label: '28', value: '28'},
        {label: '29', value: '29'},
        {label: '30', value: '30'},
        {label: '31', value: '31'},
    ];

    monthOfYearNumber = [
        {label: 'January', value: '1'},
        {label: 'February', value: '2'},
        {label: 'March', value: '3'},
        {label: 'April', value: '4'},
        {label: 'May', value: '5'},
        {label: 'June', value: '6'},
        {label: 'July', value: '7'},
        {label: 'August', value: '8'},
        {label: 'September', value: '9'},
        {label: 'October', value: '10'},
        {label: 'November', value: '11'},
        {label: 'December', value: '12'}
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
            console.log('attribute name,value,type: ' + curAttributeName + ' ' + curAttributeValue + ' ' + curAttributeType);
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

    get isTestTypeNthWeekdayOfAnyMonth() {
        return this.inputValues.testType.value === 'NthWeekdayOfAnyMonth';
    }

    get isTestTypeNthWeekdayOfSpecificMonth() {
        return this.inputValues.testType.value === 'NthWeekdayOfSpecificMonth';
    }

    get isTestTypeNthDayOfMonth() {
        return this.inputValues.testType.value === 'NthDayOfMonth';
    }
}
