import {LightningElement, track, api} from 'lwc';

const defaults = {
    apexDefinedTypeInputs: false,
    inputAttributePrefix: 'select_'
};

export default class DatatableCPE extends LightningElement {

    // Define how you would like any banner lines to look in the CPE
    _bannerStyle = 'padding:0.3rem;background:#16325c;';
    _bannerMargin = 'slds-m-top_small slds-m-bottom_xx-small';
    _bannerClass = 'slds-text-color_inverse slds-text-heading_medium';

    _inputVariables = [];
    _builderContext = [];
    _elementInfo = {};
    _flowVariables;
    _elementType;
    _elementName;

    selectedSObject = '';
    isSObjectInput = true;
    isObjectSelected = false;

    @api
    get bannerStyle() {
        return this._bannerStyle;
    }

    @api
    get bannerMargin() {
        return this._bannerMargin;
    }

    @api
    get bannerClass() {
        return this._bannerClass;
    }

    // These names have to match the input attribute names in your <myLWCcomponent>.js-meta.xml file
    @track inputValues = { 
        objectName: {value: null, valueDataType: null, isCollection: false, label: 'Select Object'},
        fieldName: {value: null, valueDataType: null, isCollection: false, label: 'Select Field'},
        isUserDefinedObject: {value: null, valueDataType: null, isCollection: false, label: 'Input Records are Apex-Defined Objects'},
        tableData: {value: null, valueDataType: null, isCollection: true, label: 'Datatable Record Collection'},
        tableDataString: {value: null, valueDataType: null, isCollection: false, label: 'Datatable Record String'},
        preSelectedRows: {value: null, valueDataType: null, isCollection: true, label: 'Pre-Selected Rows Collection'},
        preSelectedRowsString: {value: null, valueDataType: null, isCollection: false, label: 'Pre-Selected Rows String'}
    };

    settings = { 
        attributeObjectName: 'objectName',
        attributeFieldName: 'fieldName'
    }

    selectDataSourceOptions = [
        {label: 'SObject Collection', value: !this.inputValues.isUserDefinedObject},
        {label: 'Apex Defined Object String', value: this.inputValues.isUserDefinedObject}
    ];

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
        this.isObjectSelected = true;
        this.inputValues.tableData.value = null;
        this.inputValues.preSelectedRows.value = null;
        this.updateFlowParam('vSObject', typeValue);
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

            if (curAttributeName == 'isUserDefinedObject') {
                this.isSObjectInput = !event.target.checked;
                this.isObjectSelected = (this.isSObjectInput && this.selectedSObject != '');
            }
        }
    
    }

    @api
    validate() {
        const validity = [];
        return validity;
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