import { LightningElement, api } from 'lwc';

export default class ParamsInput extends LightningElement {
    @api entity = {};

    get key(){
        return this.entity.key;
    }

    get value(){
        return this.entity.value;
    }

    get showButton() {
        return this.entity.order > 0;
    }
    changeKey(event) {
        this.entity = JSON.parse(JSON.stringify(this.entity));
        this.entity.key = event.detail.value;
        const valueChangedEvent = new CustomEvent('changeinput', {
            detail: {
                entity: this.entity,
            }
        });
        this.dispatchEvent(valueChangedEvent);
    }

    changeValue(event) {
        this.entity = JSON.parse(JSON.stringify(this.entity));
        this.entity.value = event.detail.value;
        const valueChangedEvent = new CustomEvent('changeinput', {
            detail: {
                entity: this.entity,
            }
        });
        this.dispatchEvent(valueChangedEvent);
    }

    remove() {
        const removeItemEvent = new CustomEvent('removeitem', {
            detail: {
                entity: this.entity,
            }
        });
        this.dispatchEvent(removeItemEvent);
    }

    
}