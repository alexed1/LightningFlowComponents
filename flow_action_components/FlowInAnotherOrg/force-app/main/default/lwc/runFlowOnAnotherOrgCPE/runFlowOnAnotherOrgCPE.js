import { LightningElement, track, api } from 'lwc';

export default class RunFlowOnAnotherOrgCPE extends LightningElement {
    @track inputValues = {};

    @api inputVariables;
    _builderContext;
    _flowVariables;
    _automaticOutputVariables;

    @api get automaticOutputVariables () {
        return this._automaticOutputVariables;
    }

    set automaticOutputVariables (value) {
        this._automaticOutputVariables = value;
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
   

    get baseOrgURL() {
        //return this.inputValues['Endpoint'];
        const param = this.inputVariables.find(({ name }) => name === 'baseOrgURL');
        return param && param.value;
    }

    get baseOrgURLType() {
        //return this.inputValues['Endpoint'];
        const param = this.inputVariables.find(({ name }) => name === 'baseOrgURL');
        return param && param.valueDataType;
    }

    get consumerKey() {
        //return this.inputValues['Method'];
        const param = this.inputVariables.find(({ name }) => name === 'consumerKey');
        return param && param.value;
    }
    get consumerKeyType() {
        //return this.inputValues['Method'];
        const param = this.inputVariables.find(({ name }) => name === 'consumerKey');
        return param && param.valueDataType;
    }

    get consumerSecret() {
        const param = this.inputVariables.find(({ name }) => name === 'consumerSecret');
        return param && param.value;
    }

    get consumerSecretType() {
        //return this.inputValues['Method'];
        const param = this.inputVariables.find(({ name }) => name === 'consumerSecret');
        return param && param.valueDataType;
    }

    get inputsJSON() {
        const param = this.inputVariables.find(({ name }) => name === 'inputsJSON');
        return param && param.value;
    }


    get useFutureMethod() {
        const param = this.inputVariables.find(({ name }) => name === 'useFutureMethod');
        return param && this.getFLowBooleanValue(param.value);
    }

    get username() {
        const param = this.inputVariables.find(({ name }) => name === 'username');
        return param && param.value;
    }

    get usernameType() {
        const param = this.inputVariables.find(({ name }) => name === 'username');
        return param && param.valueDataType;
    }

    get password() {
        const param = this.inputVariables.find(({ name }) => name === 'password');
        return param && param.value;
    }

    get passwordType() {
        const param = this.inputVariables.find(({ name }) => name === 'password');
        return param && param.valueDataType;
    }

    get flowName() {
        const param = this.inputVariables.find(({ name }) => name === 'flowName');
        return param && param.value;
    }

    get flowNameType() {
        const param = this.inputVariables.find(({ name }) => name === 'flowName');
        return param && param.valueDataType;
    }



    @track errors = [];
    
    get errorMessage() {
        return this.errors.join('; ');
    }
    get isError() {
        return this.errors.length > 0;
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

   

    changeInputsJSON(event) {
        this.dispatchFlowValueChangeEvent('inputsJSON', event.detail.value, 'String');
    }

    
    changeUseFutureMethod(event) {
        this.dispatchFlowValueChangeEvent('useFutureMethod', event.detail.checked ? event.detail.checked : null, 'Boolean');
    }



    handleFlowComboboxValueChange(event) {
        if(event && event.detail) {
            this.dispatchFlowValueChangeEvent(event.detail.id, event.detail.newValue, event.detail.newValueDataType);
        }

    }

    getFLowBooleanValue(value) {
        if(value === '$GlobalConstant.True' || value === true) {
            return true;
        } else if('$GlobalConstant.False') {
            return false;
        }

        return value;
    }
    
}