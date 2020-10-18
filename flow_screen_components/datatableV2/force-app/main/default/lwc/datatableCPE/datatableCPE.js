import {LightningElement, track, api} from 'lwc';


const defaults = {
    apexDefinedTypeInputs: false,
    inputAttributePrefix: 'select_'

};

export default class DatatableCPE extends LightningElement {

    _builderContext;
    _values;

    

    @track inputValues = {
        isUserDefinedObject: {value: false, valueDataType: null, isCollection: false, label: 'Input Records are Apex-Defined Objects'},
        objectName: {value: null, valueDataType: null, isCollection: false, label: 'Select Object'},
        fieldName: {value: null, valueDataType: null, isCollection: false, label: 'Select Field'},

    };

    settings = { 
        attributeObjectName: 'objectName',
        attributeFieldName: 'fieldName'
    }


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
        this.handleDefaultAttributes();
    }

    handleDefaultAttributes() {
    
    }

    handleValueChange(event) {
        if (event.target) {
            let curAttributeName = event.target.name ? event.target.name.replace(defaults.inputAttributePrefix, '') : null;
            let value = event.detail ? event.detail.value : event.target.value
            let curAttributeValue = event.target.type === 'checkbox' ? event.target.checked : value;
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
            this.dispatchFlowValueChangeEvent(curAttributeName, curAttributeValue, curAttributeType);

        }
    }

    handleDynamicTypeMapping(event) { 

        console.log('handling a dynamic type mapping');
        console.log('event is ' + JSON.stringify(event));
        let typeValue = event.detail.objectType;
        let typeName = 'T'; //this is hardcoded, which is bad, and should be a lookup to a setting. 
        console.log('typeValue is: ' + typeValue);
        const dynamicTypeMapping = new CustomEvent('configuration_editor_generic_type_mapping_changed', {
            composed: true,
            cancelable: false,
            bubbles: true,
            detail: {
                typeName, 
                typeValue, 
            }
        });
        this.dispatchEvent(dynamicTypeMapping);
    
    }

    handleFlowComboboxValueChange(event) {
        if (event.target && event.detail) {
            let changedAttribute = event.target.name.replace(defaults.inputAttributePrefix, '');
            this.dispatchFlowValueChangeEvent(changedAttribute, event.detail.newValue, event.detail.newValueDataType);
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



    get isSObjectInput() {
        if (this.inputValues.isUserDefinedObject) {
            return this.inputValues.isUserDefinedObject.value === defaults.apexDefinedTypeInputs;
        }

    }

    
    handlePickObjectAndFieldValueChange(event) {
        if (event.detail) {

//need to set a dynamic type mapping here

            this.dispatchFlowValueChangeEvent(this.settings.attributeObjectName, event.detail.objectType, this.settings.flowDataTypeString);
            this.dispatchFlowValueChangeEvent(this.settings.attributeFieldName, event.detail.fieldName, this.settings.flowDataTypeString);
        }
    }

    //don't forget to credit https://www.salesforcepoint.com/2020/07/LWC-modal-popup-example-code.html
    @track openModal = false;
    showModal() {
        this.openModal = true;
    }
    closeModal() {
        this.openModal = false;
    }
    

}