import {LightningElement, api} from 'lwc';

export default class ers_comboboxColumnType extends LightningElement {
    @api editable;
    @api fieldName;
    @api keyField;
    @api keyFieldValue;
    @api picklistValues;
    @api value;
    cellClass;

    get options() {
        let _options = [];
        for(const key in this.picklistValues) {
            let option = {};
            option.label = this.picklistValues[key];
            option.value = key;
            _options.unshift(option);
        }
        return _options
    }

    handleChange(event) {
        this.value = event.detail.value;
        //Fire event so that main component can handle the value change
        //We will mimic the standard oncellchange event from lightning datatable
        let draftValue = {};
        let draftValues = [];
        draftValue[this.fieldName] = this.value;
        draftValue[this.keyField] = this.keyFieldValue;
        draftValues.push(draftValue);

        const customEvent = CustomEvent('combovaluechange', {
            composed: true,
            bubbles: true,
            cancelable: true,
            detail: {
                draftValues: draftValues
            },
        });
        this.dispatchEvent(customEvent)

        //set isChanged so that cell is highlighted
        //this.cellClass = 'isChanged'; removed. highlighting controlled by manipulating fieldValues on the datatable
    }
}
