import {api, track, LightningElement} from 'lwc';

export default class SendRichEmailCPE extends LightningElement {

    /* array of complex object containing id-value of a input parameter.
         * eg: [{
         *       id: 'prop1_id',
         *       value: 'value',
         *       dataType: 'string'
             }]
        */
    @api values;

    /* array of all input parameters
     * [{
     *       id: 'prop1_id',
     *       label: 'prop1_label',
     *       dataType: 'string',
     *       description: 'desc' // optional
     *       isRequired: true, // optional
     *       defaultValue: '', // optional
     *       context: {
     *           isCollection
     *           ...
     *           ...
     *       } // optional
     *  }]
     */
    @api property;
    actionName = 'SendRichEmail';
    settings = {
        specifyBodyOption: 'specifyBody',
        useTemplateOption: 'useTemplate'
    };
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
            'String': 'SendTOthisStringCollectionOfEmailAddresses'
        }
    }, {
        baseLabel: 'CC',
        label: 'CC',
        value: [],
        typeMap: {
            'User': 'SendCCtheEmailAddressesFromThisCollectionOfUsers',
            'Contact': 'SendCCtheEmailAddressesFromThisCollectionOfContacts',
            'Lead': 'SendCCtheEmailAddressesFromThisCollectionOfLeads',
            'String': 'SendCCthisStringCollectionOfEmailAddresses'
        }
    }, {
        baseLabel: 'BCC',
        label: 'BCC',
        value: [],
        typeMap: {
            'User': 'SendBCCtheEmailAddressesFromThisCollectionOfUsers',
            'Contact': 'SendBCCtheEmailAddressesFromThisCollectionOfContacts',
            'Lead': 'SendBCCtheEmailAddressesFromThisCollectionOfLeads',
            'String': 'SendBCCthisStringCollectionOfEmailAddresses'
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
        SendTOtheEmailAddressesFromThisCollectionOfContacts: {value: null},
        templateTargetObjectID: {value: null},
        bodyOption: {value: this.settings.specifyBodyOption}
    };
    @track isInitialized = true;

    /* map of resource available in the flow
           {
               actionCalls: [],
               apexPluginCalls: [],
               constants: [],
               formulas: [],
               recordCreates: [],
               recordDeletes: [],
               recordLookups: [],
               recordUpdates: [],
               screens: [],
               stages: [],
               textTemplates: [],
               variables: []
          }
        */
    @api get flowContext() {
        return this._flowContext;
    }

    set flowContext(value) {
        // this.isInitialized = false;
        this._flowContext = value;
        this.convertContextIntoRoleManagerParams(value);
        this.convertStringOptions(value);
        this.convertTemplateOptions(value);
        // this.initializeValues(value);
    }

    initializeValues(value) {
        let currentActionCall = value.actionCalls.find(curActionCall => curActionCall.actionName === this.actionName);
        let roleManagerValues = {};
        if (currentActionCall) {
            currentActionCall.inputParameters.forEach(curInputParam => {
                if (this.inputValues[curInputParam.name]) {
                    this.inputValues[curInputParam.name].value = this.getElementValue(curInputParam.value);
                }
                this.setAvailableRecipientsValues(curInputParam, roleManagerValues);
            });
        }
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
                if (curRecipient.typeMap[curObjectType] === curInputParam.name) {
                    roleManagerValues[curRecipient.baseLabel] = curInputParam.value.elementReference;
                }
            });
        });
    }

    getElementValue(curInputParamValue) {
        if (curInputParamValue.elementReference) {
            return curInputParamValue.elementReference;
        } else if (curInputParamValue.stringValue) {
            return curInputParamValue.stringValue
        } else {
            return null;
        }
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
        this.convertedFlowContext = outputTypes;
    }

    dispatchFlowValueChangeEvent(id = '', newValue = '', newValueDataType = '') {
        console.log('inputs to dispatch:  id is ' + id + ' newValue is ' + newValue + 'newValueDataType is ' + newValueDataType);
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
        // this.dispatchFlowValueChangeEvent('SendTOtheEmailAddressesFromThisCollectionOfUsers', 'TestUserVariable', 'User');
        // return;
        let curRecipient = this.availableRecipients.find(curRec => curRec.baseLabel === event.detail.id);
        if (curRecipient) {
            let attributeToChange = curRecipient.typeMap[event.detail.newValueDataType];
            let newLabel = event.detail.newValue ? curRecipient.baseLabel + ' (' + event.detail.newValue + ')' : curRecipient.baseLabel;
            curRecipient.label = newLabel;
            this.dispatchFlowValueChangeEvent(attributeToChange, event.detail.newValue, event.detail.newValueDataType);
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
        }
        console.log('incoming event data: event currentTarget' + JSON.stringify(event.currentTarget));
        console.log('incoming event data: event detail' + JSON.stringify(event.detail));
        console.log('incoming event data: event target name is: ' + JSON.stringify(event.target.name));

        //this.dispatchFlowValueChangeEvent(elementName, event.detail.value,'String' );
        //testing dispatch of an SObject Collection: this.dispatchFlowValueChangeEvent(elementName, 'curContacts','Contact[]' );
        this.dispatchFlowValueChangeEvent(elementName, 'Get_Template_Target_Record','Contact');


    }


    connectedCallback() {
        console.log('entering connected callback');
        console.log('_flowcontext is: ' +JSON.stringify(this._flowContext));
        //console.log('xxxxxxx');
        //console.log('property context is: ' +JSON.stringify(this.property));

        //console.log('flowcontext is: ' +JSON.stringify(this.flowContext));

    }

    // Return a promise that resolve and return errors if any
    // In 224, it will be synchronus instead of async.
    // [{
    //      key: 'key1',
    //      errorString: 'Error message'
    // }]
    @api validate() {
        return [];
        //do some checking for errors

        //return the data structure shown above which is an array of objects

        // for example, if the error is due to a slider being out of bounds then you
        //could return this data structure:
        //[{
        //   key: 'SendRichEmail - Set Return Date Maximum',
        //   errorString: 'Return Date Maximum must be less than 30'
        //}]


    }


}