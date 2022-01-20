import { LightningElement, track, api } from "lwc";
import * as InvocableStringWizardEditorMapping from "./invocableStringWizardEditorMapping";
const SF_DEV_DOCS_BASE_URL =
  "https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_methods_system_string.htm#apex_System_String_";

export default class InvocableStringWizardEditor extends LightningElement {
  @api inputVariables;
  activeAccordionSections = ["sourceUrl", "description","output"];

  _builderContext;
  _automaticOutputVariables;
  _flowVariables;

  methodVisibilityController;

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
  get automaticOutputVariables() {
    return this._automaticOutputVariables;
  }
  set automaticOutputVariables(value) {
    this._automaticOutputVariables = value;
  }

  get method() {
    const param = this.inputVariables.find(({ name }) => name === "method");
    return param && param.value;
  }

  get methodSelected() {
    if (this.method) {
      this.methodSelector(this.method);
      return true;
    }
    return false;
  }

  get sourceUrl() {
    return SF_DEV_DOCS_BASE_URL + this.method;
  }

  get description() {
    return this.methodVisibilityController.description;
  }

  get output() {
    return this.methodVisibilityController.output;
  }

  get mainString() {
    const param = this.inputVariables.find(({ name }) => name === "mainString");
    return param && param.value;
  }

  get mainStringMapping() {
    return this.methodVisibilityController.mainString;
  }

  get integer01() {
    const param = this.inputVariables.find(({ name }) => name === "integer01");
    return param && param.value;
  }

  get integer01Mapping() {
    return this.methodVisibilityController.integer01;
  }

  get integer02() {
    const param = this.inputVariables.find(({ name }) => name === "integer02");
    return param && param.value;
  }

  get integer02Mapping() {
    return this.methodVisibilityController.integer02;
  }

  get string01() {
    const param = this.inputVariables.find(({ name }) => name === "string01");
    return param && param.value;
  }

  get string01Mapping() {
    return this.methodVisibilityController.string01;
  }

  get string02() {
    const param = this.inputVariables.find(({ name }) => name === "string02");
    return param && param.value;
  }

  get string02Mapping() {
    return this.methodVisibilityController.string02;
  }

  get integerList() {
    const param = this.inputVariables.find(
      ({ name }) => name === "integerList"
    );
    return param && param.value;
  }

  get integerListMapping() {
    return this.methodVisibilityController.integerList;
  }

  get stringList() {
    const param = this.inputVariables.find(({ name }) => name === "stringList");
    return param && param.value;
  }

  get stringListMapping() {
    return this.methodVisibilityController.stringList;
  }

  get methods() {
    let fieldMapping = InvocableStringWizardEditorMapping.fieldMapping();
    let methodOptions = [];
    for (let i = 0; i < fieldMapping.length; i++) {
      methodOptions.push({
        label: fieldMapping[i].method,
        value: fieldMapping[i].method
      });
    }
    return methodOptions;
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
          newValue: newValue,
          newValueDataType: newValueDataType
        }
      }
    );
    this.dispatchEvent(valueChangedEvent);
  }

  handleFlowComboboxValueChange(event) {
    if (event && event.detail) {
      this.dispatchFlowValueChangeEvent(
        event.detail.id,
        event.detail.newValue,
        event.detail.newValueDataType
      );
    }
  }

  handlechangeMethod(event) {
    this.methodSelector(event.detail.value);
    this.dispatchFlowValueChangeEvent("method", event.detail.value, "String");
  }

  methodSelector(methodName) {
    let fieldMapping = InvocableStringWizardEditorMapping.fieldMapping();
    for (let i = 0; i < fieldMapping.length; i++) {
      if (fieldMapping[i].method === methodName) {
        this.methodVisibilityController = fieldMapping[i];
        break;
      }
    }
  }

  @track errors = [];

  get errorMessage() {
    return this.errors.join("; ");
  }
  get isError() {
    return this.errors.length > 0;
  }

  @api validate() {
    let validity = [];
    this.errors = [];
    if (!this.methodSelected) {
      this.errors.push("Please Select a Method");
      validity.push({
        key: "Please Select a Method",
        errorString: "Please Select a Method"
      });
    }
    if (
      (this.mainStringMapping.required && !this.mainString) ||
      (this.integer01Mapping.required && !this.integer01) ||
      (this.integer02Mapping.required && !this.integer02) ||
      (this.string01Mapping.required && !this.string01) ||
      (this.string02Mapping.required && !this.string02) ||
      (this.integerListMapping.required && !this.integerList) ||
      (this.stringListMapping.required && !this.stringList)
    ) {
      this.errors.push("Mandatory field(s) not completed");
      validity.push({
        key: "Mandatory field(s) not completed",
        errorString: "Mandatory field(s) not completed"
      });
    }
    return validity;
  }
}
