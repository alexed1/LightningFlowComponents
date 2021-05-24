import { LightningElement,api, track } from 'lwc';

export default class MapJSONArrayCPE extends LightningElement {
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

    @api inputVariables;
    @api genericTypeMappings;
    @track errors = [];
    //sobjectTypeForValidate;
    get inputJSONString() {
        //return this.inputValues['Endpoint'];
        const param = this.inputVariables.find(({ name }) => name === 'inputJSONString');
        return param && param.value;
    }

    get keysToExtract() {

        const param = this.inputVariables.find(({ name }) => name === 'keysToExtract');
        return param && param.value;
    }

    get sObjectType() {
        //return this.inputValues['Endpoint'];
        const param = this.genericTypeMappings.find(({ typeName }) => typeName === 'U__sobjectList');
        return param && param.typeValue;
    }

    get sObjectTypeForValidate() {
        //return this.inputValues['Endpoint'];
        const param = this.inputVariables.find(({ name }) => name === 'sobjectType');
        return param && param.value;
    }

    get errorMessage() {
        return this.errors.join('; ');
    }

    get isError() {
        return this.errors.length > 0;
    }

    __builderContext;
    _flowVariables;

    @api validate() {
        let validity = [];
        this.errors = [
        ];

    if(this.sObjectType !== this.sObjectTypeForValidate) { 
        this.errors = [
            'Target Object Type and Confirm Object Type are not equal'
        ];
        validity.push({ 
            key: 'Sobject type',
            errorString: 'Target Object Type and Confirm Object Type are not equal',
        }); 
    } 

        return validity;
}
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

    dispatchFlowGenericTypeChangeEvent(typeName, typeValue) {
        const valueChangedEvent = new CustomEvent('configuration_editor_generic_type_mapping_changed', {
            bubbles: true,
            cancelable: false,
            composed: true,
            detail: {
                typeName: typeName,
                typeValue: typeValue
            }
        });
        this.dispatchEvent(valueChangedEvent);
    }

    changeSObjectType(event) {
        if(event && event.detail && this.sObjectType !== event.detail.objectType) {
            this.dispatchFlowGenericTypeChangeEvent('U__sobjectList', event.detail.objectType);
            this.dispatchFlowValueChangeEvent('keysToExtract', '', 'String');
            //this.dispatchFlowValueChangeEvent('sobjectType', event.detail.objectType, 'String');
        }

    }

    changeSObjectTypeForValidate(event) {
            this.dispatchFlowValueChangeEvent('sobjectType', event.detail.objectType, 'String');

    }

    get isSObjectSelected() {
        return this.sObjectType;
    }
}