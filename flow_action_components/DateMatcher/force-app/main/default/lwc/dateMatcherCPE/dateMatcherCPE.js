
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
    };

    settings = {
        inputAttributePrefix: 'select_'
    }


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



    initializeValues(value) {
        if (this._values && this._values.length) {
            this._values.forEach(curInputParam => {
                if (curInputParam.name && this.inputValues[curInputParam.name]) {
                    this.inputValues[curInputParam.name].value = curInputParam.value;
                    this.inputValues[curInputParam.name].valueDataType = curInputParam.valueDataType;
                }
            });
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
