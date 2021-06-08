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
    
    _builderContext;
    _flowVariables;
    @api 
    get builderContext() {
        return this._builderContext;
    }

    set builderContext(context) {
        
        this._builderContext = context || {};
        if (this._builderContext) {
            const { variables } = this._builderContext;
            this._flowVariables = [...variables];
        }
    }
    
    get key(){
        return this.entity.key;
    }

    get value(){
        return this.entity.value;
    }

    get valueType() {
        if(!this.entity || !this.entity.value) {
            return 'String';
        }

        if(this.entity.value.startsWith('{!') && this.entity.value.endsWith('}')) {
            return 'reference';
        }

        return 'String';
    }
    
    get showButton() {
        return this.entity.order > 0;
    }

    changeinput(event) {
        let inputName = event.target.name;
        this.entity = JSON.parse(JSON.stringify(this.entity));
        if(inputName === 'key') {
            this.entity.key = event.detail.value;
        }

        if(inputName === 'value') {
            if(event && event.detail) {
                this.entity.value = event.detail.newValue;
                if(event.detail.newValueDataType === 'reference') {
                    this.entity.value = '{!' + this.entity.value + '}';
                }
            }
        }

        this.dispatchValueChangeEvent('changeinput', {entity : this.entity});
    }

    dispatchValueChangeEvent(eventName, detail) {
        const valueChangedEvent = new CustomEvent(eventName, {
            detail: detail
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