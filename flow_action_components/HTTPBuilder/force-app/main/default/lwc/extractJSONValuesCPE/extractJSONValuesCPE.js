import { LightningElement, api, track } from 'lwc';
import Extract_JSON_Values from '@salesforce/label/c.Extract_JSON_Values';
//import HTTP_Method from '@salesforce/label/c.HTTP_Method';
import Input_JSON_String from '@salesforce/label/c.Input_JSON_String';
import Specify_the_keys_that_you_want_to_extract from '@salesforce/label/c.Specify_the_keys_that_you_want_to_extract';
import Add_Target_Key from '@salesforce/label/c.Add_Target_Key';
//import HTTP_Method from '@salesforce/label/c.HTTP_Method';


export default class ExtractJSONValuesCPE extends LightningElement {
    labels = {
        Extract_JSON_Values,
        Input_JSON_String,
        Specify_the_keys_that_you_want_to_extract,
        Add_Target_Key
    }
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
    
    @api get automaticOutputVariables () {
        return this._automaticOutputVariables;
    }

    set automaticOutputVariables (value) {
        this._automaticOutputVariables = value;
    }

    @api inputVariables;

    get inputJSONString() {
        //return this.inputValues['Endpoint'];
        const param = this.inputVariables.find(({ name }) => name === 'inputJSONString');
        return param && param.value;
    }

    get inputJSONStringType() {
        //return this.inputValues['Endpoint'];
        const param = this.inputVariables.find(({ name }) => name === 'inputJSONString');
        return param && param.valueDataType;
    }

    get keysToExtract() {
        //return this.inputValues['Endpoint'];
        const param = this.inputVariables.find(({ name }) => name === 'keysToExtract');
        return param && param.value;
    }
    _builderContext;
    _flowVariables;

    handleFlowComboboxValueChange(event) {
        if(event && event.detail) {
            this.dispatchFlowValueChangeEvent(event.detail.id, event.detail.newValue, event.detail.newValueDataType);
        }

    }

    changekeysToExtract(event) {
        this.dispatchFlowValueChangeEvent('keysToExtract', event.detail.value, 'String');

    }

    dispatchFlowValueChangeEvent(id, newValue, newValueDataType) {
        const valueChangedEvent = new CustomEvent('configuration_editor_input_value_changed', {
            bubbles: true,
            cancelable: false,
            composed: true,
            detail: {
                name: id,
                newValue: newValue,
                newValueDataType: newValueDataType
            }
        });
        this.dispatchEvent(valueChangedEvent);
    }
}