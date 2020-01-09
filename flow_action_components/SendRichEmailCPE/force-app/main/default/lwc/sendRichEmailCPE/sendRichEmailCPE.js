import {api, track, LightningElement} from 'lwc';

export default class SendRichEmailCPE extends LightningElement {

    @api property;
    settings = {
        specifyBodyOption: 'specifyBody',
        useTemplateOption: 'useTemplate',
        stringVariablesOption: 'String Variables (or type an address)',
        stringDataType: 'String',
        referenceDataType: 'reference',
        true: true,
        false: false,
        componentWidth: 300
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
        replyEmailAddress: {value: null, dataType: null},
        orgWideEmailAddressId: {value: null, dataType: null},
        senderDisplayName: {value: null, dataType: null},
        subject: {value: null, dataType: null},
        HTMLbody: {value: null, dataType: null},
        plainTextBody: {value: null, dataType: null},
        recordId: {value: null, dataType: null},
        templateTargetObjectID: {value: null, dataType: null},
        bodyOption: {value: this.settings.specifyBodyOption, dataType: this.settings.stringDataType}
    };
    @track isInitialized = true;

    @api get flowContext() {
        return this._flowContext;
    }

    set flowContext(value) {
        this._flowContext = value;
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
                this.inputValues[curInputParam.id].dataType = curInputParam.dataType;
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

    convertTemplateOptions(value) {
        this.templateOptions = value.textTemplates.map(curValue => {
            return {label: curValue.name, value: curValue.name}
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
            if (event.detail.newValueDataType === this.settings.stringVariablesOption || event.detail.newValueDataType === this.settings.stringDataType) {
                this.dispatchFlowValueChangeEvent(attributeToChange, event.detail.newValue, this.settings.stringDataType);
            } else {
                this.dispatchFlowValueChangeEvent(attributeToChange, '{!' + event.detail.newValue + '}', this.settings.referenceDataType);
            }

        }
    }

    handleBodyOptionChange(event) {
        this.selectedBodyOption = event.detail.value;
    }

    get isSpecifyBodyOption() {
        return this.selectedBodyOption === this.settings.specifyBodyOption;
    }

    handleFlowValueChange(event) {
        let elementName = event.detail.id;
        if (this.inputValues[elementName]) {
            this.inputValues[elementName].value = event.detail.newValue;
            this.inputValues[elementName].value = event.detail.newValueDataType;
            let formattedValue = (event.detail.newValueDataType === this.settings.stringDataType || !event.detail.newValue) ? event.detail.newValue : '{!' + event.detail.newValue + '}';
            this.dispatchFlowValueChangeEvent(elementName, formattedValue, event.detail.newValueDataType);
        }
    }

    get inputStyle() {
        if (this.settings.componentWidth) {
            return 'max-width: ' + this.settings.componentWidth + 'px';
        }
    }

    @api validate() {
        return [];
    }

}