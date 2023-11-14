/**
 * Lightning Web Component for Flow Screens:        fsc_drawLineCPE
 *
 * Custom Property Editor for fsc_drawLine FLow Screen Component
 *
 * This drawLine component is designed to be used on a Flow Screen, Record Page, App Page or Home Page to display a horizontal line
 * Attributes are available for vetical margins, color and thickness.
 * 
 * This component is packaged as part of the unofficialsf.com FlowScreenComponentsBasePack
 * 
 * 11/13/23 -   Eric Smith -    Version 1.0.1
 *              Bug Fixes:      Line thickness attribute was causing an error when other components on the same screen had validation errors
 *
 * CREATED BY:          Eric Smith
 * 
 * VERSION:             1.0.0
 * 
 * DATE:                4/11/2023
 *
 * 
 *
 **/

import { LightningElement, api, track } from 'lwc';

const VERSION_NUMBER = "1.0.1";

const defaults = {
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

export default class Fsc_drawLineCPE extends LightningElement {

    versionNumber;

    // Set Sample Line Values
    get classMarginTop() {
        return this.inputValues['marginTop'].value;
    }

    get classMarginBottom() {
        return this.inputValues['marginBottom'].value;
    }

    get styleThickness() {
        return this.inputValues['thickness'].value;
    }

    get thicknessPixels() {
        return this.inputValues['thickness'].value.slice(0,-2);
    }

    get styleColor() {
        return this.inputValues['color'].value;
    }

    get sldsClass() {
        return `slds-m-top_${this.classMarginTop} slds-m-bottom_${this.classMarginBottom}`;
    }

    get lineStyle() {
        return `border-width: ${this.styleThickness};border-color: ${this.styleColor};`;
    }

    // Define any banner overrides you want to use (see fsc_flowBanner.js)
    _bannerMargin = "slds-m-top_small slds-m-bottom_xx-small";
    _bannerClass = "slds-text-color_inverse slds-text-heading_medium slds-m-bottom_xx-small";
    _defaultBannerColor = COLORS.blue;
    _colorWizardOverride = COLORS.green;
    _colorAdvancedOverride = COLORS.red;
    _defaultModalHeaderColor = COLORS.blue_light;
    _modalHeaderColorWizardOverride = COLORS.green_light;
    _modalHeaderColorAdvancedOverride = COLORS.red_light;
    
    _inputVariables = [];
    _builderContext = [];
    _elementInfo = {};
    _flowVariables;
    _elementType;
    _elementName;

    validateErrors = [];
    firstPass = true;

    get bannerMargin() {
        return this._bannerMargin;
    }

    get bannerClass() {
        return this._bannerClass;
    }

    get defaultBannerColor() {
        return this._defaultBannerColor;
    }

    get colorWizardOverride() {
        return this._colorWizardOverride;
    }

    get colorAdvancedOverride() {
        return this._colorAdvancedOverride;
    }

    get defaultModalHeaderColor() {
        return this._defaultModalHeaderColor;
    }

    get modalHeaderColorWizardOverride() {
        return this._modalHeaderColorWizardOverride;
    }

    get modalHeaderColorAdvancedOverride() {
        return this._modalHeaderColorAdvancedOverride;
    }

    get attributeSpacing() {
        return defaults.attributeSpacing;
    }

    get automaticOutputVariables () {
        return this._automaticOutputVariables;
    }

    set automaticOutputVariables (value) {
        this._automaticOutputVariables = value;
    }

    _automaticOutputVariables;

    // These names have to match the input attribute names in your <myLWCcomponent>.js-meta.xml file
    @track
    inputValues = {
        marginTop: {
            value: "none",
            valueDataType: null,
            isCollection: false,
            label: "Top Margin",
            helpText: "Size selection for the top margin (Default = none)"
        },
        marginBottom: {
            value: "xx-small",
            valueDataType: null,
            isCollection: false,
            label: "Bottom Margin",
            helpText: "Size selection for the bottom margin (Default = xx-small)"
        },
        thickness: {
            value: "1px",
            valueDataType: null,
            isCollection: false,
            label: "Line Thickness",
            helpText: "Number of pixels for the line thickness (Default = 1px)"
        },
        color: {
            value: "#808080",
            valueDataType: null,
            isCollection: false,
            label: "Line Color",
            helpText: "Color code for the line using the format #xxxxxx. (Default = Gray #808080)"
        }
    };

    marginOptions = [
        {label: 'none', value: 'none'},
        {label: 'xxx-small', value: 'xxx-small'},
        {label: 'xx-small', value: 'xx-small'},
        {label: 'x-small', value: 'x-small'},
        {label: 'small', value: 'small'},
        {label: 'medium', value: 'medium'},
        {label: 'large', value: 'large'},
        {label: 'x-large', value: 'x-large'},
        {label: 'xx-large', value: 'xx-large'}
    ]

    sectionEntries = {
        sampleLine: { label: "Sample Line", info: []},
        drawLine: { label: "Line Attributes", info: [] }
    };

    helpSections = [
        {
            name: "sampleLine",
            attributes: [
                {name: defaults.customHelpDefinition, 
                    label: 'Sample Line',
                    helpText: 'The thickness, color and vertical spacing of the sample line should approximate what it will look like on a flow screen.'}
            ]
        },
        {
            name: "drawLine",
            attributes: [
                {name: defaults.customHelpDefinition, 
                    label: 'Line Attributes',
                    helpText: 'Change the available settings to set a line thickness and color along with the spacing above and below the line.'},
                { name: "marginTop" },
                { name: "marginBottom" },
                { name: "thickness" },
                { name: "color" }
            ]
        }
    ];

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
    
    @api
    get inputVariables() {
        return this._inputVariables;
    }
    
    set inputVariables(variables) {
        this._inputVariables = variables || [];
        this.initializeValues();
    }

    initializeValues() {
        console.log("drawLineCPE - initializeValues");
        this._inputVariables.forEach((curInputParam) => {
            if (curInputParam.name && curInputParam.value != null) {
                console.log(
                    "Init:",
                    curInputParam.name,
                    curInputParam.valueDataType,
                    curInputParam.value
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

                // Handle any internal value settings based on attribute values here
                if (curInputParam.name == "thickness") {
                    if (this.inputValues[curInputParam.name].value.toString().slice(-1) != "x") {
                        this.inputValues[curInputParam.name].value += "px";
                        this.inputValues[curInputParam.name].valueDataType = "String";
                    }
                }

                }
                if (curInputParam.isError) {
                    this.inputValues[curInputParam.name].isError = false;
                }
            }
        });
    
        if (this.firstPass) {
            this.handleDefaultAttributes();
            this.handleBuildHelpInfo();
        }
        this.firstPass = false;
    }
    
    handleDefaultAttributes() {
        console.log("Handle default attributes");
    }
    
    handleBuildHelpInfo() {
        console.log("build help info");
        this.helpSections.forEach((section) => {
            this.sectionEntries[section.name].info = [];
            section.attributes.forEach((attribute) => {
                if (attribute.name == defaults.customHelpDefinition) {
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
        });
    }

    handleStringChange(event) {
        let changedAttribute = event.target.name.replace(
            defaults.inputAttributePrefix,
            ""
        );
        let newValue = event.detail.value;
        this.dispatchFlowValueChangeEvent(changedAttribute, newValue, "String");
    }

    handleNumberChange(event) {
        let changedAttribute = event.target.name.replace(
            defaults.inputAttributePrefix,
            ""
        );
        let newValue = event.detail.value.toString() + "px";
        this.dispatchFlowValueChangeEvent(changedAttribute, newValue, "String");
    }

    handleFlowComboboxValueChange(event) {
        if (event.target && event.detail) {
            let changedAttribute = event.target.name.replace(
                defaults.inputAttributePrefix,
                ""
            );
            let newType = event.detail.newValueDataType;
            let newValue = event.detail.newValue;
    
          // Handle all Number attributes here
        if (changedAttribute == "contentSize" && newType != "reference") {
            newType = "Number";
        }
    
        this.dispatchFlowValueChangeEvent(changedAttribute, newValue, newType);
    
          // Handle custom attribute changes here
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
        console.log("dispatchFlowValueChangeEvent", id, newValue, newValueDataType);
        if (!newValue) {
          this.inputValues[id].value = newValue; // You need to force any cleared values back to inputValues
        }
        if (newValue) {
          this.inputValues[id].isError = false; // Clear any prior error before validating again if the field has any value
        }
    }
    
    connectedCallback() {
        this.versionNumber = VERSION_NUMBER;
    }
    
    disconnectedCallback() {}
    
    // Match Slider Button Color to the Line Color
    renderedCallback() {
        document.documentElement.style.setProperty('--headerColor', this.styleColor);
    }

    @api
    validate() {
        this.validateErrors.length = 0;
    
        // Custom Error Checking
        // this.checkError(
        //     parseInt(this.inputValues.contentSize.value) > 12,
        //     "contentSize",
        //     "Maximum value is 12"
        // );
    
        // ComboBox Errors
        // let allComboboxes = this.template.querySelectorAll("c-flow-combobox");
        // if (allComboboxes) {
        //     allComboboxes.forEach((curCombobox) => {
        //     if (!curCombobox.reportValidity()) {
        //         resultErrors.push("error");
        //         console.log("ComboBox Error:", error);
        //     }
        //     });
        // }
    
        return this.validateErrors;
    }
    
    checkError(isError, key, errorString) {
        this.inputValues[key].class = "slds-form-element";
        if (isError) {
            this.validateErrors.push({ key: key, errorString: errorString });
            this.inputValues[key].isError = true;
            this.inputValues[key].errorMessage = errorString;
            this.inputValues[key].class += " slds-has-error";
            console.log("CPE generated error:", key, isError, errorString);
        } else {
            this.inputValues[key].isError = false;
        }
    }

}