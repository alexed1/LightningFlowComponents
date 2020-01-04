import {api, track, LightningElement} from 'lwc';

export default class SendRichEmailCPE extends LightningElement {

    @api property;
    settings = {
        specifyBodyOption: 'specifyBody',
        useTemplateOption: 'useTemplate',
        stringVariablesOption: 'String Variables (or type an address)'
    };
    @track _values;
    @track _flowContext;
    @track convertedFlowContext;
    @track stringOptions = [];
    @track templateOptions = [];
    bodyOptions = [
        {label: 'Specify Body here', value: this.settings.specifyBodyOption},
        {label: 'Use Email Template', value: this.settings.useTemplateOption}
    ];
    @track selectedBodyOption = this.settings.specifyBodyOption;
    @track availableRecipients = [{
        baseLabel: 'TO',
        label: 'TO',
        value: [],
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
        replyEmailAddress: {value: null},
        orgWideEmailAddressId: {value: null},
        senderDisplayName: {value: null},
        subject: {value: null},
        HTMLbody: {value: null},
        plainTextBody: {value: null},
        recordId: {value: null},
        templateTargetObjectID: {value: null},
        bodyOption: {value: this.settings.specifyBodyOption}
    };
    @track isInitialized = true;

    @api get flowContext() {
        return this._flowContext;
    }

    set flowContext(value) {
        this._flowContext = value;
        this.convertStringOptions(value);
        this.convertTemplateOptions(value);
        this.convertContextIntoRoleManagerParams(value);
    }


    @api get values() {
        return this._values;
    }

    set values(value) {
        this.isInitialized = false;
        this._values = value;
        this.initializeValues();
    }

    initializeValues(value) {

        let roleManagerValues = {};
        this._values.forEach(curInputParam => {
            if (this.inputValues[curInputParam.id]) {
                this.inputValues[curInputParam.id].value = curInputParam.value;
            }
            this.setAvailableRecipientsValues(curInputParam, roleManagerValues);
        });

        Object.keys(roleManagerValues).forEach(curRecipientBaseLabel => {
            let foundRecipient = this.availableRecipients.find(curRecipient => curRecipient.baseLabel === curRecipientBaseLabel);
            if (foundRecipient) {
                foundRecipient.value = [roleManagerValues[curRecipientBaseLabel]];
                if (roleManagerValues[curRecipientBaseLabel]) {
                    let newLabel = foundRecipient.baseLabel + ' (' + roleManagerValues[curRecipientBaseLabel] + ')';
                    foundRecipient.label = newLabel;
                }
            }
        });
        this.isInitialized = true;
    }

    setAvailableRecipientsValues(curInputParam, roleManagerValues) {
        this.availableRecipients.forEach(curRecipient => {
            Object.keys(curRecipient.typeMap).forEach(curObjectType => {
                if (curRecipient.typeMap[curObjectType] === curInputParam.id) {
                    roleManagerValues[curRecipient.baseLabel] = curInputParam.value;
                }
            });
        });
    }

    convertStringOptions(value) {
        this.stringOptions = value.variables.filter(curValue => {
            return curValue.dataType === 'String' && !curValue.isCollection
        }).map(curValue => {
            return {label: curValue.name, value: curValue.name}
        });
    }

    convertTemplateOptions(value) {
        this.templateOptions = value.textTemplates.map(curValue => {
            return {label: curValue.name, value: curValue.name}
        });
    }

    get stringAndTemplateOptions() {
        return [...this.stringOptions, ...this.templateOptions];
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
                    }
                }
                outputTypes[curLookUp.object].data.push(curLookUp);
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
        const valueChangedEvent = new CustomEvent('valuechanged', {
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

    handleValueSelected(event) {

        let curRecipient = this.availableRecipients.find(curRec => curRec.baseLabel === event.detail.id);
        if (curRecipient) {
            let attributeToChange = curRecipient.typeMap[event.detail.newValueDataType];
            let newLabel = event.detail.newValue ? curRecipient.baseLabel + ' (' + event.detail.newValue + ')' : curRecipient.baseLabel;
            curRecipient.label = newLabel;
            if (event.detail.newValueDataType === this.settings.stringVariablesOption) {
                this.dispatchFlowValueChangeEvent(attributeToChange, event.detail.newValue, 'String');
            } else {
                this.dispatchFlowValueChangeEvent(attributeToChange, '{!' + event.detail.newValue + '}', 'reference');
            }

        }
    }

    handleBodyOptionChange(event) {
        this.selectedBodyOption = event.detail.value;
    }

    get isSpecifyBodyOption() {
        return this.selectedBodyOption === this.settings.specifyBodyOption;
    }

    handleValueChange(event) {
        let elementName = event.currentTarget.name;
        if (this.inputValues[elementName]) {
            this.inputValues[elementName].value = event.detail.value;
            this.dispatchFlowValueChangeEvent(elementName, '{!' + event.detail.value + '}', 'reference');
        }
    }

    @api validate() {
        return [];
    }
}