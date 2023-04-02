/**
 * Lightning Web Component for Flow Screens:        clipboardButtonCPE
 *
 * Custom Property Editor for clipboardButton FLow Screen Component
 *
 * This clipboardButton component is designed to be used on a FLow Screen where the value passed to the component
 * is displayed and when the button is clicked, the value will be inserted into the system clipboard
 *
 * CREATED BY:          Eric Smith
 *
 * VERSION:             1.x.x
 *
 * RELEASE NOTES:       https://github.com/alexed1/LightningFlowComponents/tree/master/flow_screen_components/clipboardButton/README.md
 *
 **/

import { LightningElement, track, api } from "lwc";

const VERSION_NUMBER = "1.1.0";

const CB_TRUE = "CB_TRUE"; // Used with fsc_flowCheckbox component
const CB_FALSE = "CB_FALSE"; // Used with fsc_flowCheckbox component
const CB_ATTRIB_PREFIX = "cb_"; // Used with fsc_flowCheckbox component

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

export default class ClipboardButtonCPE extends LightningElement {
  versionNumber;

  // Define any banner overrides you want to use (see fsc_flowBanner.js)
  _bannerMargin = "slds-m-top_small slds-m-bottom_xx-small";
  _bannerClass =
    "slds-text-color_inverse slds-text-heading_medium slds-m-bottom_xx-small";
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
    return defaults.attributeSpacing;
  }

  @api get automaticOutputVariables () {
    return this._automaticOutputVariables;
 }

  set automaticOutputVariables (value) {
    this._automaticOutputVariables = value;
 }

 _automaticOutputVariables;
  // These names have to match the input attribute names in your <myLWCcomponent>.js-meta.xml file
  @track inputValues = {
    clipboardLabel: {
      value: null,
      valueDataType: null,
      isCollection: false,
      label: "Clipboard Label",
      helpText: "Label to appear above the Clipboard contents box (Optional)"
    },
    buttonLabel: {
      value: null,
      valueDataType: null,
      isCollection: false,
      label: "Button Label",
      helpText: "Label to use on the button (Optional)"
    },
    clipboardContent: {
      value: null,
      valueDataType: null,
      isCollection: false,
      label: "Clipboard Content",
      helpText: "Set this to the value to pass into the Clipboard"
    },
    // fieldApiName: {value: null, valueDataType: null, isCollection: false, label: 'Field API Name',
    //     helpText: 'Select the field API name to use its value from the Record page instead of the Clipboard Content'},
    contentSize: {
      value: null,
      valueDataType: null,
      isCollection: false,
      label: "Content Size (In 12ths)",
      helpText:
        "Set the size of the contents box in 12ths of the total container width (Optional)",
      isError: false,
      errorMessage: null
    },
    removeClipboard: {
      value: null,
      valueDataType: null,
      isCollection: false,
      label: "Hide Clipboard after Selection?",
      helpText:
        "Remove the clipboard contents display from the screen once the button is clicked."
    },
    cb_removeClipboard: {
      value: null,
      valueDataType: null,
      isCollection: false,
      label: ""
    }
  };

  sectionEntries = {
    clipboardButton: { label: "Clipboard Button", info: [] }
  };

  helpSections = [
    {
      name: "clipboardButton",
      attributes: [
        { name: "clipboardLabel" },
        { name: "buttonLabel" },
        { name: "clipboardContent" },
        // {name: 'fieldApiName'},
        { name: "contentSize" },
        { name: "removeClipboard" }
        // {name: defaults.customHelpDefinition,
        //     label: 'For more information on using Apex Defined Objects with Datatable',
        //     helpText: 'https://ericsplayground.wordpress.com/how-to-use-an-apex-defined-object-with-my-datatable-flow-component/'}
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
    console.log("clipboardButtonCPE - initializeValues");
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
          // if (curInputParam.name == 'objectName') {
          //     this.selectedSObject = curInputParam.value;
          // }
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
    console.log("handle default attributes");
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

  handleDynamicTypeMapping(event) {
    //     console.log('handling a dynamic type mapping');
    //     console.log('event is ' + JSON.stringify(event));
    //     let typeValue = event.detail.objectType;
    //     const typeName = this._elementType === "Screen" ? 'T' : 'T__record';
    //     console.log('typeValue is: ' + typeValue);
    //     const dynamicTypeMapping = new CustomEvent('configuration_editor_generic_type_mapping_changed', {
    //         composed: true,
    //         cancelable: false,
    //         bubbles: true,
    //         detail: {
    //             typeName,
    //             typeValue,
    //         }
    //     });
    //     this.dispatchEvent(dynamicTypeMapping);
    //     this.updateRecordVariablesComboboxOptions(typeValue);
    //     this.updateFlowParam('vSObject', typeValue);
    //     if (this.selectedSObject != typeValue) {
    //         this.inputValues.tableData.value = null;
    //         this.inputValues.preSelectedRows.value = null;
    //         this.dispatchFlowValueChangeEvent('tableData', null, 'String');
    //         this.dispatchFlowValueChangeEvent('preSelectedRows', null, 'String');
    //         this.selectedSObject = typeValue;
    //         this.dispatchFlowValueChangeEvent('objectName', typeValue, 'String');
    //     }
    //     this.handleGetObjectDetails(typeValue);
  }

  updateRecordVariablesComboboxOptions(objectType) {
    //     const variables = this._flowVariables.filter(
    //         (variable) => variable.objectType === objectType
    //     );
    //     let comboboxOptions = [];
    //     variables.forEach((variable) => {
    //         comboboxOptions.push({
    //             label: variable.name,
    //             value: "{!" + variable.name + "}"
    //         });
    //     });
    //     return comboboxOptions;
  }

  handleGetObjectDetails(objName) {
    // Custom callout to APEX based on SObject selection
    //     console.log('Passing object name to Apex Controller', objName);
    //     getCPEReturnResults({ objName: objName })
    //     .then(result => {
    //         let returnResults = JSON.parse(result);
    //         // Assign return results from the Apex callout
    //         this.objectLabel = returnResults.objectLabel;
    //         this.objectPluralLabel = returnResults.objectPluralLabel;
    //         this.objectIconName = returnResults.objectIconName;
    //         console.log(`Return Values for ${objName}, Label: ${this.objectLabel}, Plural: ${this.objectPluralLabel}, Icon: ${this.objectIconName}`);
    //     })  // Handle any errors from the Apex Class
    //     .catch(error => {
    //         console.log('getCPEReturnResults error is: ' + JSON.stringify(error));
    //         if (error.body) {
    //             this.errorApex = 'Apex Action error: ' + error.body.message;
    //             alert(this.errorApex + '\n');  // Present the error to the user
    //         }
    //         return this.errorApex;
    //     });
  }

  handleValueChange(event) {
    // if (event.target) {
    //     let curAttributeName = event.target.name ? event.target.name.replace(defaults.inputAttributePrefix, '') : null;
    //     let value = event.detail ? event.detail.value : event.target.value;
    //     let curAttributeValue = event.target.type === 'checkbox' ? event.target.checked : value;
    //     let curAttributeType;
    //     switch (event.target.type) {
    //         case "checkbox":
    //             curAttributeType = 'Boolean';
    //             break;
    //         case "number":
    //             curAttributeType = 'Number';
    //             break;
    //         default:
    //             curAttributeType = 'String';
    //     }
    //     this.dispatchFlowValueChangeEvent(curAttributeName, curAttributeValue, curAttributeType);
    // }
  }

  handleCheckboxChange(event) {
    if (event.target && event.detail) {
      let changedAttribute = event.target.name.replace(
        defaults.inputAttributePrefix,
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

      // Handle any internal value settings based on attribute values here
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

  @api
  validate() {
    this.validateErrors.length = 0;

    // Custom Error Checking
    this.checkError(
      parseInt(this.inputValues.contentSize.value) > 12,
      "contentSize",
      "Maximum value is 12"
    );

    // ComboBox Errors
    let allComboboxes = this.template.querySelectorAll("c-flow-combobox");
    if (allComboboxes) {
      allComboboxes.forEach((curCombobox) => {
        if (!curCombobox.reportValidity()) {
          resultErrors.push("error");
          console.log("ComboBox Error:", error);
        }
      });
    }

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
