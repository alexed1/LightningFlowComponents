/**
 * Lightning Web Component for Flow Screens:        GetRecordsInCPE
 *
 * Custom Property Editor for GetRecordsIn Invocable FLow Action
 *
 *      The GetRecordsIn component is designed to be an alternative to the standard Get Records Flow element.
 *      In place of the normal selection and filter attributes, it is designed to return a collection of records
 *      where the value of a field in the record is IN a collection of values passed into the component.
 *
 * 06/05/22 -   Eric Smith -    Version 1.0.0  
 *
 **/

import { LightningElement, api, track } from 'lwc';

// *** Set the component's current version # here
const VERSION_NUMBER = "1.0.0";

const CB_TRUE = "CB_TRUE";      // Used with fsc_flowCheckbox component
const CB_FALSE = "CB_FALSE";    // Used with fsc_flowCheckbox component
const CB_ATTRIB_PREFIX = "cb_"; // Used with fsc_flowCheckbox component

const DEFAULTS = {
    inputAttributePrefix: "select_",
    customHelpDefinition: "CUSTOM",
    attributeSpacing: "slds-m-vertical_x-small"
};

const COLORS = {
    blue: "#4C6E96", //Brand is #1B5297, decreasing shades: #346096, #4C6E96, #657B96
    blue_light: "#657B96",
    green: "#659668",
    green_light: "#7E967F",
    red: "#966594",
    red_light: "#967E95"
};

export default class GetRecordsInCPE extends LightningElement {

    versionNumber;

    // *** Define any banner overrides you want to use (see fsc_flowBanner.js)
    _bannerMargin = "slds-m-top_small slds-m-bottom_xx-small";
    _bannerClass =
        "slds-text-color_inverse slds-text-heading_medium slds-m-bottom_xx-small";
    _defaultBannerColor = COLORS.blue;
    _colorWizardOverride = COLORS.green;
    _colorAdvancedOverride = COLORS.red;
    _defaultModalHeaderColor = COLORS.blue_light;
    _modalHeaderColorWizardOverride = COLORS.green_light;
    _modalHeaderColorAdvancedOverride = COLORS.red_light;

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

    @api
    get bannerMargin() {
        return this._bannerMargin;
    }

    @api
    get bannerClass() {
        return this._bannerClass;
    }

    @api
    get defaultBannerColor() {
        return this._defaultBannerColor;
    }

    @api
    get colorWizardOverride() {
        return this._colorWizardOverride;
    }

    @api
    get colorAdvancedOverride() {
        return this._colorAdvancedOverride;
    }

    @api
    get defaultModalHeaderColor() {
        return this._defaultModalHeaderColor;
    }

    @api
    get modalHeaderColorWizardOverride() {
        return this._modalHeaderColorWizardOverride;
    }

    @api
    get modalHeaderColorAdvancedOverride() {
        return this._modalHeaderColorAdvancedOverride;
    }

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

    get isDisplayAll() {
        // TODO: First provide a more limited object picklist (see Datatable)
        return true;
    }
    
    get availableObjectTypes() { 
        return (this.isDisplayAll) ? 'All' : '';
    }

    get typeOptions() { // TODO: @wire
        return [
            { label: 'Account', value: 'Account' },
            { label: 'Case', value: 'Case' },
            { label: 'Lead', value: 'Lead' },
            { label: 'Contact', value: 'Contact' },
        ];
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
        // TODO: restrict options to only those that match Source Object
        const variables = this.builderContext.variables;
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

    selectedSourceObject = '';
    get isSourceObjectSelected() {
        return (!!this.selectedSourceObject);
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

    // *** Define sections for the Help Text on each Banner
    sectionEntries = {
        // sectionName: { label: "My Section Label", info: [] }
    };

    // *** List the attribute names and/or custom entries for each help text section
    helpSections = [
        {
        // name: "sectionName",
        // attributes: [
        //     { name: "attributeName" },
        //     { name: "attributeName" },
        //     { name: "attributeName" },
        //     { name: DEFAULTS.customHelpDefinition,
        //         label: 'My Custom Label',
        //         helpText: 'My Custom Help Text'}
        // ]
        }
    ];

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
            }

        });

        if (this.firstPass) {
            this.handleDefaultAttributes();
            this.handleBuildHelpInfo();
        }
        this.firstPass = false;
    }

    handleDefaultAttributes() {
        console.log("CPE - handle default attributes");
    }

    handleBuildHelpInfo() {
        console.log("CPE - build help info");
        this.helpSections.forEach((section) => {
            if (Object.keys(this.sectionEntries).length > 0) {
                this.sectionEntries[section.name].info = [];
                section.attributes.forEach((attribute) => {
                    if (attribute.name == DEFAULTS.customHelpDefinition) {
                        this.sectionEntries[section.name].info.push({
                            label: attribute.label,
                            helpText: attribute.helpText
                        });
                    } else {
                        this.sectionEntries[section.name].info.push({
                            label: this.inputValues[attribute.name].label,
                            helpText: this.inputValues[attribute.name].helpText
                        });
                    }
                });
            }
        });
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
        console.log("CPE - Handle Input Object Change");
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
    }

    handlesourceRecordCollectionChange(event) {
        if (event && event.detail) {
            const newValue = event.detail.value;
            const valueChangedEvent = new CustomEvent(
                'configuration_editor_input_value_changed',
                {
                    bubbles: true,
                    cancelable: false,
                    composed: true,
                    detail: {
                        name: 'sourceRecordCollection',
                        newValue,
                        newValueDataType: 'reference',
                    },
                }
            );
        this.dispatchEvent(valueChangedEvent);
        this.inputValues.sourceRecordCollection.value = newValue;
        }
    }

    updateRecordVariablesComboboxOptions(objectType) {
console.log("🚀 ~ file: GetRecordsInCPE.js ~ line 485 ~ GetRecordsInCPE ~ updateRecordVariablesComboboxOptions ~ objectType", objectType);
const vars = this._flowVariables;
vars.forEach((v) => {
console.log("🚀 ~ file: GetRecordsInCPE.js ~ line 490 ~ GetRecordsInCPE ~ var.forEach ~ v", v.name, v.objectType);
});
        const variables = this._flowVariables.filter(
            (variable) => variable.objectType === objectType
        );
        let comboboxOptions = [];
        variables.forEach((variable) => {
console.log("🚀 ~ file: GetRecordsInCPE.js ~ line 487 ~ GetRecordsInCPE ~ variables.forEach ~ variable", variable);
            comboboxOptions.push({
                label: variable.name,
                value: "{!" + variable.name + "}"
            });
        });
        return comboboxOptions;
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
        if (event.target && event.detail) {
        let changedAttribute = event.target.name.replace(
            DEFAULTS.inputAttributePrefix,
            ""
        );
        this.dispatchFlowValueChangeEvent(
            changedAttribute,
            event.detail.newValue,
            event.detail.newValueDataType
        );
        this.dispatchFlowValueChangeEvent(
            CB_ATTRIB_PREFIX + changedAttribute,
            event.detail.newStringValue,
            "String"
        );

        // *** Handle any internal value settings based on attribute values here
        // if (changedAttribute == 'displayAll') {
        //     this.inputValues.objectName.value = null;
        //     this.selectedSObject = null;
        //     this.dispatchFlowValueChangeEvent('objectName',this.selectedSObject, 'String');
        // }
        }
    }

    updateCheckboxValue(name, value) {
        // Used to force a checkbox value change elsewhere in the CPE based on custom logic
        this.inputValues[name].value = value;
        this.dispatchFlowValueChangeEvent(name, value, "boolean");
        this.inputValues[CB_ATTRIB_PREFIX + name].value = value
            ? CB_TRUE
            : CB_FALSE;
        this.dispatchFlowValueChangeEvent(
            CB_ATTRIB_PREFIX + name,
            this.inputValues[CB_ATTRIB_PREFIX + name].value,
            "String"
        );
    }

    handleFlowComboboxValueChange(event) {
        if (event.target && event.detail) {
            let changedAttribute = event.target.name.replace(
                DEFAULTS.inputAttributePrefix,
                ""
            );
            let newType = event.detail.newValueDataType;
            let newValue = event.detail.newValue;

            // *** Handle all Number attributes here
            // if (changedAttribute == "contentSize" && newType != "reference") {
            //     newType = "Number";
            // }

            this.dispatchFlowValueChangeEvent(changedAttribute, newValue, newType);

            // *** Handle custom attribute changes here
            // if (changedAttribute == 'tableData') {
            //     this.isRecordCollectionSelected = !!event.detail.newValue;
            // }

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
        this.checkError((!this.isOutputObjectSelected), 'outputObject', 'You must select the Output Object');
        this.checkError((this.isSourceMethodObject && !this.isSourceObjectSelected), 'sourceObject', 'You must select the Source Object');

        // ComboBox Errors
        let allComboboxes = this.template.querySelectorAll("c-fsc_flow-combobox");
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