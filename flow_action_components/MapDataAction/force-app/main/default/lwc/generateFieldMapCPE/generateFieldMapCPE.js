import {LightningElement, track, api} from 'lwc';

const defaults = {
    dataTypeSObject: 'sobject',
    dataTypeApexDefined: 'apexDefined',
    inputAttributePrefix: 'select_',
    attributeObjectName: 'objectName',
    flowDataTypeString: 'String',
    attributeInputMapJSON: 'inputMapJson',
    reactionYes: 'yes',
    reactionNo: 'no'
}
export default class GenerateFieldMapCpe extends LightningElement {
    _builderContext;
    _values;

    labels = {
        addMappingField: 'Field',
        confirmAction: 'Confirm your action',
        objectChangeConfirm: 'Changing that value will erase your current mappings. Continue?'
    }
    dataTypeOptions = [
        {
            label: 'SObject (Salesforce Record)',
            value: defaults.dataTypeSObject
        },
        {
            label: 'Apex-Defined Data Type (Custom Data)',
            value: defaults.dataTypeApexDefined
        }
    ]
    changeObjectModalReactions = [
        {label: 'Ok', variant: 'destructive', value: defaults.reactionYes},
        {label: 'Cancel', variant: 'brand', value: defaults.reactionNo}
    ]
    @track inputValues = {
        inputDataType: {value: null, valueDataType: null, isCollection: false, label: 'Select Input Data Type'},
        inputObject: {value: null, valueDataType: null, isCollection: false, label: 'Select Object'},
        outputDataType: {value: null, valueDataType: null, isCollection: false, label: 'Select Output  Data Type'},
        outputObject: {value: null, valueDataType: null, isCollection: false, label: 'Select Object'},
        inputMapJson: {value: null, valueDataType: null, isCollection: false, label: 'inputMapJson'},
    }

    get isInputSObject() {
        return this.inputValues.inputDataType.value === defaults.dataTypeSObject;
    }

    get isOutputSObject() {
        return this.inputValues.outputDataType.value === defaults.dataTypeSObject;
    }


    @api get builderContext() {
        return this._builderContext;
    }

    set builderContext(value) {
        this._builderContext = value;
    }

    @api get inputVariables() {
        return this._values;
    }

    set inputVariables(value) {
        this._values = value;
        this.initializeValues();
    }

    initializeValues(value) {
        if (this._values && this._values.length) {
            this._values.forEach(curInputParam => {
                if (curInputParam.name && this.inputValues[curInputParam.name]) {
                    this.inputValues[curInputParam.name].value = curInputParam.value;
                    this.inputValues[curInputParam.name].valueDataType = curInputParam.valueDataType;
                }
            });
        }
    }

    handleValueChange(event) {
        if (event.target) {
            let curAttributeName = event.target.name ? event.target.name.replace(defaults.inputAttributePrefix, '') : null;
            let curAttributeValue = event.target.type === 'checkbox' ? event.target.checked : event.detail.value;
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

    handleObjectSelected(event) {
        let curAttributeName = event.target.name ? event.target.name.replace(defaults.inputAttributePrefix, '') : null;
        let params = {
            attributeName: curAttributeName,
            objectType: event.detail.objectType,
            priorValue: this.inputValues[curAttributeName].value ? this.inputValues[curAttributeName].value.repeat(1) : null
        };
        if (this.inputValues[curAttributeName].value !== event.detail.objectType) {
            if (this.getInputMapJSON()) {
                this.modalAction(true, params);
            } else {
                this.handleObjectChange(params);
            }
        }
        // this.inputValues[curAttributeName].value = event.detail.objectType;
    }

    handleModalReactionButtonClick(event) {
        let params = event.detail.params;
        if (event.detail.value === defaults.reactionYes) {
            this.inputValues.inputMapJson.value = null;
            this.handleObjectChange(params);
            this.clearRows();
        } else {
            this.inputValues[params.attributeName].value = params.priorValue;
        }
        this.modalAction(false);
    }

    handleObjectChange(params) {
        this.dispatchFlowValueChangeEvent(defaults.attributeInputMapJSON, null, defaults.flowDataTypeString);
        this.dispatchFlowValueChangeEvent(params.attributeName, params.objectType, defaults.flowDataTypeString);
    }

    modalAction(isOpen, params) {
        const existing = this.template.querySelector('c-uc-modal');
        if (existing) {
            if (isOpen) {
                existing.params = params;
                existing.openModal();
            } else {
                existing.closeModal();
            }
        }
    }

    clearRows() {
        let fieldLinesCmp = this.template.querySelector('c-generate-field-map-cpe-lines');
        if (fieldLinesCmp) {
            return fieldLinesCmp.clearRows();
        }
    }

    getInputMapJSON() {
        let fieldLinesCmp = this.template.querySelector('c-generate-field-map-cpe-lines');
        if (fieldLinesCmp) {
            return fieldLinesCmp.inputMapJson;
        }
        return null;
    }

    generateError(key, errorString) {
        return {key: key, errorString: errorString};

    }

    @api validate() {
        let resultErrors = [];
        if (!this.inputValues.outputObject.value) {
            resultErrors.push(this.generateError('outputObject', 'missing output object'));
        }
        if (!this.inputValues.outputDataType.value) {
            resultErrors.push(this.generateError('inputObject', 'missing input object'));
        }
        let fieldLinesCmp = this.template.querySelector('c-generate-field-map-cpe-lines');
        if (fieldLinesCmp) {
            let validity = fieldLinesCmp.reportValidity();
            if (validity && validity.hasError) {
                resultErrors.push(...validity.errors);
            } else {
                this.dispatchFlowValueChangeEvent(defaults.attributeInputMapJSON, fieldLinesCmp.inputMapJson, defaults.flowDataTypeString);
            }
        }
        return resultErrors;
    }

}