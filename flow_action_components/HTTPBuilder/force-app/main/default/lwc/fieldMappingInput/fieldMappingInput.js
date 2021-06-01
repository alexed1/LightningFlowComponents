import { LightningElement, api } from 'lwc';
import Set_this_output_field from '@salesforce/label/c.Set_this_output_field';
import To_the_value_of_this_key from '@salesforce/label/c.To_the_value_of_this_key';

export default class FieldMappingInput extends LightningElement {
    @api entity = {};
    @api sobjectType;
    labels = {
        Set_this_output_field,
        To_the_value_of_this_key
    }    
    
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