import { LightningElement, api } from 'lwc';
import DATETIME_LABEL from '@salesforce/label/c.DATETIME_LABEL';
import FREQUENCY_INPUT_LABEL from '@salesforce/label/c.FREQUENCY_INPUT_LABEL';
import FREQUENCY_LABEL from '@salesforce/label/c.FREQUENCY_LABEL';
import CARD_TITLE from '@salesforce/label/c.CARD_TITLE';

const FREQUENCY_OPTION_LIST = [
    {value : 'Daily' , label: 'Daily'},
    {value : 'Weekly' , label: 'Weekly'},
    {value : 'Monthly' , label: 'Monthly'},
    {value : 'Yearly' , label: 'Yearly'},
    {value : 'Hourly' , label: 'Hourly'}
];

export default class DateTimePicker extends LightningElement {
    @api startDate;
    @api frequency = 'Daily';

    get frequencyUptionList() {
        return FREQUENCY_OPTION_LIST;
    }

    handleChange(event) {
        this.frequency = event.detail.value;
    }

    handleDatetimeChange(event) {
        this.startDate = event.detail.value;
    }

    get datetimeLabel() {
        return DATETIME_LABEL;
    }

    get frequencyInputLabel() {
        return FREQUENCY_INPUT_LABEL;
    }

    get frequencyLabel() {
        return FREQUENCY_LABEL;
    }

    get cardTitle() {
        return CARD_TITLE;
    }
}