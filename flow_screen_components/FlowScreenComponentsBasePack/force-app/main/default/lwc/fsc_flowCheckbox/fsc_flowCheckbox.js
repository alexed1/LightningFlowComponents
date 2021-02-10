import { LightningElement, api } from 'lwc';

const CB_TRUE = 'CB_TRUE';
const CB_FALSE = 'CB_FALSE';

export default class FlowCheckbox extends LightningElement {
    @api label;
    @api name;
    @api checked;
    @api fieldLevelHelp;
    @api disabled;

    @api
    get isChecked() {
        return (this.checked == CB_TRUE) ? true : false;
    }

    cbClass = 'slds-p-top_xxx-small';

    handleCheckboxChange(event) {
        this.dispatchEvent(new CustomEvent('checkboxchanged', {
            // bubbles: true
            detail: {
                id: event.target.name,
                newValue: event.target.checked,
                newValueDataType: 'Boolean',
                newStringValue: event.target.checked ? CB_TRUE : CB_FALSE
            }
        }));
    }
}