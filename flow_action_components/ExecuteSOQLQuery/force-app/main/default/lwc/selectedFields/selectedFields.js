import {LightningElement, api} from 'lwc';
import {
    flashElement
} from 'c/fieldSelectorUtils';

export default class SelectedFields extends LightningElement {
    @api chooseFieldsLabel;
    @api removeAllLabel;
    @api selectedFields;

    @api
    highlightField(fieldName){
        flashElement(this, '[data-fieldvalue=' + fieldName.replace('.', '\\.') + ']', 'slds-has-error', 2, 400);
    }

    handleFieldRemove(event) {
        const removeFieldEvent = new CustomEvent('removefield', {
            detail: {value: event.target.label}
        });
        this.dispatchEvent(removeFieldEvent);
    }

    handleRemoveAll() {
        const removeAllEvent = new CustomEvent('removeall', {});
        this.dispatchEvent(removeAllEvent);
        this.dispatchRenderFinishedEvent();
    }

    dispatchRenderFinishedEvent() {
        const renderFinishedEvent = new CustomEvent('renderfinished', {});
        this.dispatchEvent(renderFinishedEvent);
    }

    renderedCallback() {
        this.dispatchRenderFinishedEvent();
    }
}