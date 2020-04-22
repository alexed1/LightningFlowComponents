import {api, track, LightningElement} from 'lwc';

export default class SendRichEmailCPE extends LightningElement {

    
    settings = {
        specifyBodyOption: 'specifyBody',
        useTemplateOption: 'useTemplate',
        stringVariablesOption: 'String Variables (or type an address)',
        stringDataType: 'String',
        referenceDataType: 'reference',
        componentWidth: 320,
        nullValue: ''
    };
    @track _values;
    @track _builderContext;
    @track convertedFlowContext;
    @track stringOptions = [];

    bodyOptions = [
        {label: 'Specify Body here', value: this.settings.specifyBodyOption, fields: ['HTMLbody', 'plainTextBody']},
        {
            label: 'Use Email Template',
            value: this.settings.useTemplateOption,
            fields: ['templateID', 'templateTargetObjectID']
        }
    ];
    @track selectedBodyOption = this.settings.specifyBodyOption;
    @track availableRecipients = [{
        baseLabel: 'TO',
        label: 'TO',
        value: [],
        objectType: null,
        typeMap: {
            'User': 'SendTOtheEmailAddressesFromThisCollectionOfUsers',
            'Contact': 'SendTOtheEmailAddressesFromThisCollectionOfContacts',
            'Lead': 'SendTOtheEmailAddressesFromThisCollectionOfLeads',
            'String': 'SendTOthisStringCollectionOfEmailAddresses',
            'String Variables (or type an address)': 'SendTOthisOneEmailAddress'
        }
    }, {
        baseLabel: 'CC',
        label: 'CC',
        value: [],
        objectType: null,
        typeMap: {
            'User': 'SendCCtheEmailAddressesFromThisCollectionOfUsers',
            'Contact': 'SendCCtheEmailAddressesFromThisCollectionOfContacts',
            'Lead': 'SendCCtheEmailAddressesFromThisCollectionOfLeads',
            'String': 'SendCCthisStringCollectionOfEmailAddresses',
            'String Variables (or type an address)': 'SendCCthisOneEmailAddress'
        }
    }, {
        baseLabel: 'BCC',
        label: 'BCC',
        value: [],
        objectType: null,
        typeMap: {
            'User': 'SendBCCtheEmailAddressesFromThisCollectionOfUsers',
            'Contact': 'SendBCCtheEmailAddressesFromThisCollectionOfContacts',
            'Lead': 'SendBCCtheEmailAddressesFromThisCollectionOfLeads',
            'String': 'SendBCCthisStringCollectionOfEmailAddresses',
            'String Variables (or type an address)': 'SendBCCthisOneEmailAddress'
        }
    }];
    //Keys must inherit names from invocable method
    @track inputValues = {
        replyEmailAddress: {value: null, dataType: null, isCollection: false},
        orgWideEmailAddressId: {value: null, dataType: null, isCollection: false},
        senderDisplayName: {value: null, dataType: null, isCollection: false},
        subject: {value: null, dataType: null, isCollection: false},
        HTMLbody: {value: null, dataType: null, isCollection: false},
        plainTextBody: {value: null, dataType: null, isCollection: false},
        templateID: {value: null, dataType: null, isCollection: false},
        templateTargetObjectID: {value: null, dataType: null, isCollection: false},
        bodyOption: {value: this.settings.specifyBodyOption, dataType: this.settings.stringDataType, isCollection: false}
    };
    @track isInitialized = true; //helps ensure all data structures are ready before rendering starts

    @api get builderContext() {
        return this._builderContext;
    }

    set builderContext(value) {
        this._builderContext = value;
        this.convertContextIntoRoleManagerParams(value);
    }


    @api get inputVariables() {
        return this._values;
    }

    set inputVariables(value) {
        this.isInitialized = false;
        this._values = value;
        this.initializeValues();
    }

    initializeValues(value) {

        let roleManagerValues = {};
        this._values.forEach(curInputParam => {
                if (curInputParam.id && this.inputValues[curInputParam.id]) {
                    this.inputValues[curInputParam.id].value = curInputParam.value;
                    this.inputValues[curInputParam.id].dataType = curInputParam.dataType;
                }
            this.setAvailableRecipientsValues(curInputParam, roleManagerValues);
        });

        Object.keys(roleManagerValues).forEach(curRecipientBaseLabel => {
            let foundRecipient = this.availableRecipients.find(curRecipient => curRecipient.baseLabel === curRecipientBaseLabel);
            if (foundRecipient) {
                foundRecipient.value = [roleManagerValues[curRecipientBaseLabel].value];
                if (roleManagerValues[curRecipientBaseLabel]) {
                    let newLabel = foundRecipient.baseLabel + ' (' + roleManagerValues[curRecipientBaseLabel].value + ')';
                    foundRecipient.label = roleManagerValues[curRecipientBaseLabel].value ? newLabel : foundRecipient.baseLabel;
                    foundRecipient.objectType = roleManagerValues[curRecipientBaseLabel].objectType;
                }
            }
        });
        this.initializeBodyOptions();
        this.isInitialized = true;
    }

    initializeBodyOptions() {
        this.bodyOptions.forEach(curBodyOption => {
            let hasValue = false;
            curBodyOption.fields.forEach(curBodyField => {
                if (!hasValue && this.inputValues[curBodyField].value) {
                    this.selectedBodyOption = curBodyOption.value;
                }
            });
        });
    }

    setAvailableRecipientsValues(curInputParam, roleManagerValues) {
        this.availableRecipients.forEach(curRecipient => {
            Object.keys(curRecipient.typeMap).forEach(curObjectType => {
                if (curRecipient.typeMap[curObjectType] === curInputParam.id) {
                    if (!roleManagerValues[curRecipient.baseLabel] || !roleManagerValues[curRecipient.baseLabel].value) {
                        roleManagerValues[curRecipient.baseLabel] = {
                            value: curInputParam.value,
                            objectType: curObjectType
                        };
                    }
                }
            });
        });
    }

    convertContextIntoRoleManagerParams(flowContext) {
        let allowedTypes = ['User', 'Lead', 'Contact', 'String'];
        let valueFieldName = 'name';
        let labelFieldName = 'label';
        let outputTypes = {};
        flowContext.recordLookups.forEach(curLookUp => {
            if (allowedTypes.includes(curLookUp.object)) {
                if (!outputTypes.hasOwnProperty(curLookUp.object)) {
                    if (!curLookUp.getFirstRecordOnly) {
                        outputTypes[curLookUp.object] = {
                            data: [],
                            valueFieldName: valueFieldName,
                            labelFieldName: labelFieldName
                        };
                        outputTypes[curLookUp.object].data.push(curLookUp);
                    }
                }

            }
        });

        let stringVariables = flowContext.variables.filter(curValue => {
            return curValue.dataType === 'String' && !curValue.isCollection
        });

        if (stringVariables && stringVariables.length) {
            outputTypes[this.settings.stringVariablesOption] = {
                data: stringVariables,
                valueFieldName: 'name',
                labelFieldName: 'name'
            };
        }

        this.convertedFlowContext = outputTypes;
    }

    dispatchFlowValueChangeEvent(id = '', newValue = '', newValueDataType = '') {
        const valueChangedEvent = new CustomEvent('configuration_editor_input_value_changed', {
            bubbles: true,
            cancelable: false,
            composed: true,
            detail: {
                id: id,
                newValue: newValue,
                newValueDataType: newValueDataType
            }
        });
        this.dispatchEvent(valueChangedEvent);
    }

    doCleanRoleManager(baseLabel, newValueObjectType) {
        let valuesToCleanUp = [];
        this.availableRecipients.forEach(curRecipient => {
            if (!baseLabel || baseLabel === curRecipient.baseLabel) {
                Object.keys(curRecipient.typeMap).forEach(curType => {
                    if (newValueObjectType !== curType) {
                        valuesToCleanUp = valuesToCleanUp.concat(this._values.filter(curValue => curValue.id === curRecipient.typeMap[curType]));
                    }
                });
            }
        });

        if (valuesToCleanUp.length) {
            valuesToCleanUp.forEach(valueToCleanUp => {
                if (valueToCleanUp && valueToCleanUp.value) {
                    this.dispatchFlowValueChangeEvent(valueToCleanUp.id, this.settings.nullValue, this.settings.stringDataType);
                }
            });
        }
    }

    doClearBodyOptions() {
        let bodyOptionToClear = this.bodyOptions.filter(bodyOptionToClear => bodyOptionToClear.value !== this.selectedBodyOption);
        if (bodyOptionToClear && bodyOptionToClear.length) {
            bodyOptionToClear.forEach(curBodyOption => {
                curBodyOption.fields.forEach(curBodyField => {
                    if (this.inputValues[curBodyField].value) {
                        this.dispatchFlowValueChangeEvent(curBodyField, this.settings.nullValue, this.settings.stringDataType);
                    }
                });
            });
        }
    }

    handleValueSelected(event) {

        let curRecipient = this.availableRecipients.find(curRec => curRec.baseLabel === event.detail.id);
        this.doCleanRoleManager(event.detail.id, event.detail.newValueObjectType);

        if (curRecipient) {
            let attributeToChange = curRecipient.typeMap[event.detail.newValueObjectType];
            let newLabel = event.detail.newValue ? curRecipient.baseLabel + ' (' + event.detail.newValue + ')' : curRecipient.baseLabel;
            curRecipient.label = newLabel;
            if (event.detail.newValueType === this.settings.stringDataType) {
                this.dispatchFlowValueChangeEvent(attributeToChange, event.detail.newValue ? event.detail.newValue : this.settings.nullValue, this.settings.stringDataType);
            } else {
                this.dispatchFlowValueChangeEvent(attributeToChange, event.detail.newValue ? '{!' + event.detail.newValue + '}' : this.settings.nullValue, this.settings.referenceDataType);
            }
        }
    }

    handleBodyOptionChange(event) {
        this.selectedBodyOption = event.detail.value;
        this.doClearBodyOptions();
    }



    get isSpecifyBodyOption() {
        return this.selectedBodyOption === this.settings.specifyBodyOption;
    }

    handleFlowComboboxValueChange(event) {
        let elementName = event.detail.id;
        if (this.inputValues[elementName]) {
            this.inputValues[elementName].value = event.detail.newValue;
            this.inputValues[elementName].dataType = event.detail.newValueDataType;
            let formattedValue = (event.detail.newValueDataType === this.settings.stringDataType || !event.detail.newValue) ? event.detail.newValue : '{!' + event.detail.newValue + '}';
            this.dispatchFlowValueChangeEvent(elementName, formattedValue, event.detail.newValueDataType);
        }
    }

    handleClearAll(event) {
        this.doCleanRoleManager();
    }

    get inputStyle() {
        if (this.settings.componentWidth) {
            return 'max-width: ' + this.settings.componentWidth + 'px';
        }
    }

    @api validate() {
        let resultErrors = [];
        let allComboboxes = this.template.querySelectorAll('c-flow-combobox');
        if (allComboboxes) {
            allComboboxes.forEach(curCombobox => {
                if (!curCombobox.reportValidity()) {
                    resultErrors.push('error');
                }
            });
        }
        return resultErrors;
    }

}