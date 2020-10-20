import {LightningElement, track, api} from 'lwc';

const defaults = {
    apexDefinedTypeInputs: false,
    inputAttributePrefix: 'select_'
};

export default class DatatableCPE extends LightningElement {

    _inputVariables = [];
    _builderContext = [];
    _elementInfo = {};
    // _typeMappings = [];

    selectedSObject;

    _flowVariables;
    _elementType;
    _elementName;

    /* array of complex object containing name-value of a input parameter.
     * eg: [{
     *       name: 'prop1_name',
     *       value: 'value',
     *       valueDataType: 'string'
     *     }]
     */

    @track inputValues = {
        isUserDefinedObject: {value: false, valueDataType: null, isCollection: false, label: 'Input Records are Apex-Defined Objects'},
        objectName: {value: null, valueDataType: null, isCollection: false, label: 'Select Object'},
        recordCollection: {value: null, valueDataType: 'reference', isCollection: true, label: 'Datatable Record Collection'},
        fieldName: {value: null, valueDataType: null, isCollection: false, label: 'Select Field'},
    };

    settings = { 
        attributeObjectName: 'objectName',
        attributeFieldName: 'fieldName'
    }

    @api flowParams = [{
        name: 'vSObject',
        type: 'String',
        value: null
    }]

    @api 
    get inputVariables() {
        return this._inputVariables;
    }

    set inputVariables(variables) {
        this._inputVariables = variables || [];
        this.initializeValues();
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

    /* contains the information about the LWC or Action in which
   * the configurationEditor is defined.
   * eg: {
   *       apiName: 'CreateCase', // dev name of the action or screen
   *       type: 'Action' // or 'Screen'
   *     }
   */
    @api
    get elementInfo() {
        return this._elementInfo;
    }

    set elementInfo(info) {
        this._elementInfo = info || {};
        if (this._elementInfo) {
            this._elementName = this._elementInfo.apiName;
            this._elementType = this._elementInfo.type;
        }
    }

    initializeValues() {
        this._inputVariables.forEach(curInputParam => {
            if (curInputParam.name && curInputParam.value) {
                if (curInputParam.name && this.inputValues[curInputParam.name]) {
                    this.inputValues[curInputParam.name].value = (curInputParam.valueDataType === 'reference') ? '{!' + curInputParam.value + '}' : curInputParam.value;
                    this.inputValues[curInputParam.name].valueDataType = curInputParam.valueDataType;
                }
            }
        });
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

    /* array of complex object containing type name-value of the dynamic data types
   * in Action or Screen
   * eg: [{
   *       typeName: 'T', // the type name
   *       typeValue: 'Account' // or any other sObject
   *     }]
   */
    
    /*     
    @api
    get typeMappings() {
        return this._typeMappings;
    }

    set typeMappings(mappings) {
        this._typeMappings = mappings || {};
        this.initializeTypeMappings();
    } */
    
    /* Return a promise that resolve and return errors if any
   *    [{
   *      key: 'key1',
   *      errorString: 'Error message'
   *    }]
   */
    @api
    validate() {
        const validity = [];
        return validity;
    }

    handleDynamicTypeMapping(event) { 
        console.log('handling a dynamic type mapping');
        console.log('event is ' + JSON.stringify(event));
        let typeValue = event.detail.objectType;
        // let typeName = 'T'; //this is hardcoded, which is bad, and should be a lookup to a setting.
        const typeName = this._elementType === "Screen" ? 'T' : 'T__record'; 
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
        this.updateRecordVariablesComboboxOptions(typeValue);
        this.selectedSObject = typeValue;
        this.updateFlowParam('vSObject', typeValue);
    }

    updateRecordVariablesComboboxOptions(objectType) {
        const variables = this._flowVariables.filter(
            (variable) => variable.objectType === objectType
        );
        let comboboxOptions = [];
        variables.forEach((variable) => {
            comboboxOptions.push({
                label: variable.name,
                value: "{!" + variable.name + "}"
            });
        });
        return comboboxOptions;
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

    updateFlowParam(name, value) {
        this.flowParams.find(param => param.name === name).value = value;
    }
    
    get isSObjectInput() {
        if (this.inputValues.isUserDefinedObject) {
            return this.inputValues.isUserDefinedObject.value === defaults.apexDefinedTypeInputs;      
        }
    }
    
    get isObjectSelected() {
        return this.selectedSObject != null;
    }

    get wizardParams() {
        return JSON.stringify(this.flowParams);
    }
    
    handlePickObjectAndFieldValueChange(event) {
        if (event.detail) {

//need to set a dynamic type mapping here

            this.dispatchFlowValueChangeEvent(this.settings.attributeObjectName, event.detail.objectType, this.settings.flowDataTypeString);
            this.dispatchFlowValueChangeEvent(this.settings.attributeFieldName, event.detail.fieldName, this.settings.flowDataTypeString);
        }
    }

    handleFlowStatusChange(event) {
        console.log('STATUS CHANGE', event.detail.flowParams);  // These are values coming back from the Wizard Flow
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