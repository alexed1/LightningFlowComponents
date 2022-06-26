/**
 * Lightning Web Component for Flow Screens:        GetRecordsInCPE
 *
 * Custom Property Editor for GetRecordsIn Invocable FLow Action
 *
 *      The GetRecordsIn component is designed to be an alternative to the standard Get Records Flow element.
 *      In place of the normal selection and filter attributes, it is designed to return a collection of records
 *      where the value of a field in the record is IN a collection of values passed into the component.
 *
 *      Thanks to David Fromstein for wonderful new versions of Combobox and Object and Field selector
 *                                  ObjectFieldSelectorController.cls, ObjectFieldSelectorControllerTest.cls
 *                                  LWCs: df_combobox, dfcomboboxUtils, df_fieldSelector2, df_objectSelector, df_objectFieldSelectorUtils
 *
 * 06/05/22 -   Eric Smith -    Version 1.0.0  
 *
 **/

import { LightningElement, api, track } from 'lwc';
import { DISPLAY_TYPE_OPTIONS, AVAILABLE_OBJECT_OPTIONS, FIELD_TYPES, LAYOUT_OPTIONS, transformConstantObject } from 'c/df_objectFieldSelectorUtils';


// *** Set the component's current version # here
const VERSION_NUMBER = "1.0.2";

const DEFAULTS = {
    inputAttributePrefix: "select_",
    customHelpDefinition: "CUSTOM",
    attributeSpacing: "slds-m-vertical_x-small"
};

export default class GetRecordsInCPE extends LightningElement {

    versionNumber;

    // Flow Builder interface
    _inputVariables = [];
    _builderContext = [];
    _genericTypeMappings = [];
    _elementInfo = {};
    _flowVariables;
    _elementType;
    _elementName;

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
    get genericTypeMappings() {
        return this._genericTypeMappings;
    }

    set genericTypeMappings(context) {
        this._genericTypeMappings = context || {};
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

    validateErrors = [];
    firstPass = true;
    isObjectSelected = false;
    selectedSourceObject = '';

    @api
    get attributeSpacing() {
        return DEFAULTS.attributeSpacing;
    }

    _automaticOutputVariables;
    @api get automaticOutputVariables () {
        return this._automaticOutputVariables;
    }

    set automaticOutputVariables (value) {
        this._automaticOutputVariables = value;
    }

    get outputObject() {
        const type = this._genericTypeMappings.find(
            ({ typeName }) => typeName === "U__outputCollection"
            );
        return type && type.typeValue;
    }

    get sourceObject() {
        const type = this._genericTypeMappings.find(
            ({ typeName }) => typeName === "T__sourceRecordCollection"
            );
        return type && type.typeValue;
    }

    get sourceCollectionValueOptions() {
        const variables = this._flowVariables.filter(
            (variable) => variable.objectType === this.sourceObject
        );
        return variables.map(({ name }) => ({
            label: name,
            value: name,
        }));
    }

    get sourceRecordCollectionPlaceholder() {
        return 'Select ' + this.inputValues.sourceObject.value + ' record collection variable...';
    }

    get sourceRecordCollection() {
        const param = this._inputVariables.find(({ name }) => name === 'sourceRecordCollection');
        return param && param.value;
    }

    // *** David Fromstein's Object/Field Picker
    get required() {
        return true;
    }

    get notRequired() {
        return null;
    }

    get allow(){
        return true;
    }

    get doNotAllow(){
        return null;
    }

    get objectOnly() {
        return DISPLAY_TYPE_OPTIONS.OBJECT.value;
    }

    get fieldsOnly() {
        return DISPLAY_TYPE_OPTIONS.FIELD.value;
    }

    isDisplayAll = false;
    get availableObjectSelection() {
        return (this.isDisplayAll) ? 'all' : 'both';
    }

    get supportedFieldTypes() {
        return [
            FIELD_TYPES.REFERENCE.value,
            FIELD_TYPES.EMAIL.value,
            FIELD_TYPES.PHONE.value,
            FIELD_TYPES.PICKLIST.value,
            FIELD_TYPES.MULTIPICKLIST.value,
            FIELD_TYPES.TEXT.value,
            FIELD_TYPES.TEXTAREA.value,
            FIELD_TYPES.URL.value
        ].join();
    }

    // *** Custom CPE handling here

    get formatOptions() {
        return [
            { label: 'Delimited String', value: 'String'},
            { label: 'Text Collection', value: 'Collection'},
            { label: 'Record Collection', value: 'Object'},
        ];
    }

    get isSourceMethodString() {
        return this.inputValues.sourceMethod.value == 'String';
    }

    get isSourceMethodCollection() {
        return this.inputValues.sourceMethod.value == 'Collection';
    }

    get isSourceMethodObject() {
        return this.inputValues.sourceMethod.value == 'Object';
    }
    
    selectedOutputObject = '';
    get isOutputObjectSelected() {
        return (!!this.selectedOutputObject);
    }

    get isSourceObjectSelected() {
        return (!!this.selectedSourceObject);
    }

    enteredRecordCollection = '';
    get isRecordCollectionEntered() {
        return (!!this.enteredRecordCollection);
    }

    enteredSourceString = '';
    get isSourceStringEntered() {
        return (!!this.enteredSourceString);
    }

    enteredSourceCollection = '';
    get isSourceCollectionEntered() {
        return (!!this.enteredSourceCollection);
    }

    get storeRecordDataOptions() {
        return [
            { label: 'Automatically store all fields', value: 'Auto'},
            { label: 'Choose fields and let Salesforce do the rest', value: 'Choose'},
        ];
    }

    get isChooseFields() {
        return this.inputValues.storeFieldsMethod.value == 'Choose';
    }

    // *** These names must match the input attribute names in your <myLWCcomponent>.js-meta.xml file or the @invocableVariable names in your invocable Apex action
    // *** fieldApiName: {value: null, valueDataType: null, isCollection: false, label: 'My Label', helpText: 'My Help Text', isError: false, errorMessage: 'My Error Message'},
    @track inputValues = {
        outputObject: {
            value: null,
            valueDataType: null,
            isCollection: false,
            label: "Object",
            helpText: "The Object type of the records to be returned",
            isError: false, 
            errorMessage: null
        },
        targetField: {
            value: null,
            valueDataType: null,
            isCollection: false,
            label: "Target Field Name (Default: Id)",
            helpText: "API Name of the field to be checked against the values in the IN collection (Default: Id)",
            isError: false, 
            errorMessage: null
        },
        storeFieldsMethod: {
            value: null,
            valueDataType: null,
            isCollection: false,
            label: "How to Store Record Data",
            helpText: "Select Choose when you want to provide your own list of field API Names to include in the output collection (Default: Auto)",
            isError: false, 
            errorMessage: null
        },
        outputFieldNames: {
            value: null,
            valueDataType: null,
            isCollection: false,
            label: "Output Field Names",
            helpText: "Comma separated list of field API Names to include in the output collection",
            isError: false, 
            errorMessage: null
        },
        sourceMethod: {
            value: null,
            valueDataType: null,
            isCollection: false,
            label: "Source Method for IN values",
            helpText: "Format of the values for the IN collection (Default: String)",
            isError: false, 
            errorMessage: null
        },        
        sourceValueString: {
            value: null,
            valueDataType: null,
            isCollection: false,
            label: "Source Value String",
            helpText: "Delimited list of values for the IN collection",
            isError: false, 
            errorMessage: null
        },
        sourceDelimiter: {
            value: null,
            valueDataType: null,
            isCollection: false,
            label: "Source Value String Delimiter (Default: ,)",
            helpText: "Delimiter character used to separate the values in the Source Value String (Default: ,)",
            isError: false, 
            errorMessage: null
        },
        sourceValueCollection: {
            value: null,
            valueDataType: null,
            isCollection: true,
            label: "Source Value Collection",
            helpText: "Collection of values for the IN collection",
            isError: false, 
            errorMessage: null
        },
        sourceObject: {
            value: null,
            valueDataType: null,
            isCollection: false,
            label: "Source Object",
            helpText: "API Name of the Object from the record collection containing the IN values",
            isError: false, 
            errorMessage: null
        },
        sourceRecordCollection: {
            value: null,
            valueDataType: null,
            isCollection: true,
            label: "Source Record Collection",
            helpText: "Record Collection containing the IN values",
            isError: false, 
            errorMessage: null
        },  
        sourceField: {
            value: null,
            valueDataType: null,
            isCollection: false,
            label: "Source Field Name (Id)",
            helpText: "API Name of the field to use in the record collection for the IN values",
            isError: false, 
            errorMessage: null
        }
    };

    initializeValues() {
        console.log("CPE - initializeValues");
        this._inputVariables.forEach((curInputParam) => {
            if (curInputParam.name && curInputParam.value != null) {
                console.log(
                    "CPE - Init:",
                    curInputParam.name,
                    curInputParam.valueDataType,
                    curInputParam.value,
                    curInputParam.isError,
                );
                if (
                    curInputParam.name &&
                    this.inputValues[curInputParam.name] != null
                ) {
                    this.inputValues[curInputParam.name].value =
                        curInputParam.valueDataType === "reference"
                        ? "{!" + curInputParam.value + "}"
                        : decodeURIComponent(curInputParam.value);
                    this.inputValues[curInputParam.name].valueDataType =
                        curInputParam.valueDataType;

                if (curInputParam.isError) {
                    this.inputValues[curInputParam.name].isError = false;
                }
                
            }
            
            // *** Handle any internal value settings based on attribute values here
                // if (curInputParam.name == 'myParamName') {
                //     this.myVariable = curInputParam.value;
                // }
            }
            if (curInputParam.name == 'outputObject') { 
                this.selectedOutputObject = curInputParam.value;    
            }
            if (curInputParam.name == 'sourceObject') { 
                this.selectedSourceObject = curInputParam.value;
                this.isObjectSelected = true;
            }
            if (curInputParam.name == 'sourceRecordCollection') { 
                this.enteredRecordCollection = curInputParam.value;    
            }            
            if (curInputParam.name == 'sourceValueString') { 
                this.enteredSourceString = curInputParam.value;    
            }
            if (curInputParam.name == 'sourceValueCollection') { 
                this.enteredSourceCollection = curInputParam.value;    
            }
            if (curInputParam.name == 'storeFieldsMethod') { 
                if (this.inputValues.storeFieldsMethod.value == 'Choose' && !this.inputValues.outputFieldNames.value) {
                    this.dispatchFlowValueChangeEvent('outputFieldNames', 'Id', 'String');
                }    
            }
            
        });

        if (this.firstPass) {
            this.handleDefaultAttributes();
            // this.handleBuildHelpInfo();
        }
        this.firstPass = false;
    }

    handleDefaultAttributes() {
        console.log("CPE - handle default attributes");
    }

    handleOutputObjectChange(event) {
        console.log("CPE - Handle Output Object Change");
        if (event && event.detail) {
            const newValue = event.detail.value;
            const typeChangedEvent = new CustomEvent(
                "configuration_editor_generic_type_mapping_changed",
                {
                    bubbles: true,
                    cancelable: false,
                    composed: true,
                    detail: {
                        typeName: "U__outputCollection",
                        typeValue: newValue
                    }
                }
            );
            this.dispatchEvent(typeChangedEvent);
            this.dispatchFlowValueChangeEvent('outputObject', newValue, 'String');
            // Set Source Object to be the same as the Output object (in case the Record Collection option isn't chosen)
            if (!this.isSourceMethodObject) {
                this.dispatchSourceObjectChange(newValue);
            }
        }
    }

    handleSourceObjectChange(event) {
        console.log("CPE - Handle Source Object Change");
        if (event && event.detail) {
            const newValue = event.detail.value;
            this.dispatchSourceObjectChange(newValue);
        }
    }

    dispatchSourceObjectChange(newValue) {
        const typeChangedEvent = new CustomEvent(
            'configuration_editor_generic_type_mapping_changed',
            {
                bubbles: true,
                cancelable: false,
                composed: true,
                detail: {
                    typeName: 'T__sourceRecordCollection',
                    typeValue: newValue
                },
            }
        );
        this.dispatchEvent(typeChangedEvent);
        this.dispatchFlowValueChangeEvent('sourceObject', newValue, 'String');
        this.isObjectSelected = true;
        this.selectedSourceObject = newValue;
        this.dispatchFlowValueChangeEvent('sourceRecordCollection', null, 'reference');
        this.dispatchFlowValueChangeEvent('sourceField', '', 'String');
    }

    handleValueChange(event) {
        console.log('CPE - Handle Value Change Event: ', event);
        if (event.target) {
            let curAttributeName = event.target.name ? event.target.name.replace(DEFAULTS.inputAttributePrefix, '') : null;
            let value = event.detail ? event.detail.value : event.target.value;
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

    handleCheckboxChange(event) {
        this.isDisplayAll = event.target.checked;
    }

    handleFlowComboboxValueChange(event) {
        if (event.target && event.detail) {
            let changedAttribute = event.target.name.replace(
                DEFAULTS.inputAttributePrefix,
                ""
            );
            let newType = event.detail?.newValueDataType || 'String';
            let newValue = event.detail?.newValue || event.detail.value;

            // *** Handle all Number attributes here
            // if (changedAttribute == "contentSize" && newType != "reference") {
            //     newType = "Number";
            // }

            // *** Handle custom attribute changes here
            if (changedAttribute == 'outputFieldNames') {
                if ((newValue.length == 2 && newValue != 'Id') ||
                    (newValue.length != 2
                    && (newValue.slice(-3) != ',Id')
                    && (newValue.slice(0, 3) != 'Id,')
                    && (!newValue.includes(',Id,'))))
                    {
                        newValue = (newValue.length == 0) ? 'Id': 'Id,' + newValue;
                    }
            }

            this.dispatchFlowValueChangeEvent(changedAttribute, newValue, newType);

        }
    }

    dispatchFlowValueChangeEvent(id, newValue, newValueDataType) {
        const valueChangedEvent = new CustomEvent(
            "configuration_editor_input_value_changed",
            {
                bubbles: true,
                cancelable: false,
                composed: true,
                detail: {
                name: id,
                newValue: newValue ? newValue : null,
                newValueDataType: newValueDataType
                }
            }
        );
        this.dispatchEvent(valueChangedEvent);
        console.log('CPE - dispatchFlowValueChangeEvent', id, newValue, newValueDataType);
        if (!newValue) {
            this.inputValues[id].value = newValue;  // You need to force any cleared values back to inputValues
        }
        if (newValue) {
            this.inputValues[id].isError = false;   // Clear any prior error before validating again if the field has any value
        }
    }

    connectedCallback() {
        this.versionNumber = VERSION_NUMBER;
    }
    
    disconnectedCallback() {}
    
    @api
    validate() {
        console.log('CPE - Validate Errors');
        this.validateErrors.length = 0;
    
        // *** Custom Error Checking Here
        this.checkError((!this.isOutputObjectSelected), 'outputObject', 'You must select the Output object');
        this.checkError((this.isSourceMethodObject && !this.isSourceObjectSelected), 'sourceObject', 'You must select the Source object');
        this.checkError((this.isSourceMethodObject && !this.isRecordCollectionEntered), 'sourceRecordCollection', 'You must enter the Source Record Collection');
        this.checkError((this.isSourceMethodString && !this.isSourceStringEntered), 'sourceValueString', 'You must enter the Source Value String');
        this.checkError((this.isSourceMethodCollection && !this.isSourceCollectionEntered), 'sourceValueCollection', 'You must enter the Source Value Collection');

        // ComboBox Errors
        let allComboboxes = this.template.querySelectorAll("c-df_flow-combobox");
        if (allComboboxes) {
            allComboboxes.forEach((curCombobox) => {
            if (!curCombobox.reportValidity()) {
                resultErrors.push("error");
                console.log("CPE - ComboBox Error:", error);
            }
            });
        }
        return this.validateErrors;
    }

    checkError(isError, key, errorString) {
        this.inputValues[key].class = 'slds-form-element';
        if (isError) { 
            this.validateErrors.push({key: key, errorString: errorString});
            this.inputValues[key].isError = true;
            this.inputValues[key].errorMessage = errorString;
            this.inputValues[key].class += ' slds-has-error';
            console.log('CPE - CPE generated error:', key, isError, errorString);
        } else { 
            this.inputValues[key].isError = false;
        }
    }

}