import {LightningElement, api} from 'lwc';

export default class SelectedFields extends LightningElement {
    @api chooseFieldsLabel;
    @api removeAllLabel;
    @api selectedFields;

    handleFieldRemove(event) {
        const removeFieldEvent = new CustomEvent('removefield', {
            detail: {value: event.target.label}
        });
        this.dispatchEvent(removeFieldEvent);
        this.dispatchRenderFinishedEvent();
    }

    handleRemoveAll() {
        const removeAllEvent = new CustomEvent('removeall', {});
        this.dispatchEvent(removeAllEvent);
    }

    dispatchRenderFinishedEvent() {
        const renderFinishedEvent = new CustomEvent('renderfinished', {});
        this.dispatchEvent(renderFinishedEvent);
    }

    renderedCallback() {
        this.dispatchRenderFinishedEvent();
    }
}