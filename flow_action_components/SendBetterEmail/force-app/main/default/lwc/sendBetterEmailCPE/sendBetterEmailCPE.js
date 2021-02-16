/**
 * @File Name			: sendBetterEmailCPE.js
 * @Description			: CPE for sendBetterEmail - an extended functionality for sending email
 * @Author				: Jack D. Pond
 * @Credits				: From quickChoiceCPE,Andrii Kraiev and sentRichEmailCPE,Alex Edelstein etal.
 * @Group				: 
 * @Last Modified By	: Jack D. Pond
 * @Last Modified On	: 02-16-2021
 * @Modification Log	: 
 * Ver		Date		Author				Modification
 * 1.33.2	6/29/2020	Jack D. Pond		Initial Version
 * 2.00.02	08-31-2020	Jack D. Pond		#469 thisOneEmailAddress failing when assigned to string
 * 2.00.02	09-02-2020	Jack D. Pond		#478 unchecked value sets to null when changed to false 
 * 2.00.02	09-02-2020	Jack D. Pond		#481 allow flow formulas (string) to be selected in flow combo boxes 
 * 2.00.02	10-06-2020	Jack D. Pond		Reverted naming, fixed bugs
 * 2.00.03  11-28-2020  Jack D. Pond		Updated for Flow Action BasePack and Flow Screen Component Base Pack.
 * 2.00.05  02-14-2020  Jack D. Pond		setTreatTargetObjectAsRecipient Fix: #586,ReplyEmail with SendBetterEmail #595
* 
 **/
import {api, track, LightningElement} from 'lwc';
const constVal = {
	specifyBodyOption: 'specifyBody',
	useTemplateOption: 'useTemplate',
	useTemplateNameOption: 'useTemplateName',
	singleEmailOption: 'singleEmail',
	massEmailOption: 'massEmail',
	flowDataTypeString: 'String',
	flowDataTypeBoolean: 'Boolean',
	flowDataTypeNumber: 'Number',
	eventDataTypeNumber: 'number',
	eventDataTypeCheckbox: 'checkbox',
	stringCollectionVariablesOption: 'String Collection',
	stringVariablesOption: 'String Variables (or type an address)',
	stringDataType: 'String',
	referenceDataType: 'reference',
	nullValue: ''
}

// This code is for setting up checkbox with defaults - should be forward compatible
const cbConstants = {
	checkbox_prefix: 'checkbox_sel_',
	GlobalConstantTrue: '$GlobalConstant.True',
	GlobalConstantFalse: '$GlobalConstant.False',
	flowDataTypeBoolean: 'Boolean',
	cbNotPrefix: 'cb_'
}
// end of checkbox with default code

export default class SendBetterEmailCPE extends LightningElement {
	_builderContext;
	_values;
	convertedFlowContext;
	
	@track inputValues = {
		orgWideEmailAddressId: {value: null, valueDataType: null, isCollection: false, default: null, label: 'Organization Wide Email Address'},
		senderDisplayName: {value: null, valueDataType: null, isCollection: false, default: null, label: 'Sender Display Name'},
		subject: {value: null, valueDataType: null, isCollection: false, default: null, label: 'Subject'},
		HTMLbody: {value: null, valueDataType: null, isCollection: false, default: null, label: 'HTML Body'},
		plainTextBody: {value: null, valueDataType: null, isCollection: false, default: null, label: 'Plain Text'},
		templateID: {value: null, valueDataType: null, isCollection: false, default: null, label: 'Email Template Id'},
		templateTargetObjectId: {value: null, valueDataType: null, isCollection: false, default: null, label: 'Recipient Record Id (also for template merge fields and recording related Email as an activity)'},
		bodyOption: {value: constVal.specifyBodyOption, dataType: constVal.flowDataTypeString, isCollection: false, default: null, label: 'Body'},
		emailMessageType: {value: null, dataType: null, isCollection: false, default: null, label: 'Email Type'},
		description: {value: null, dataType: null, isCollection: false, default: null, label: 'Description (sent in internal email with status after action completes)'},
		bcc: {value: null, dataType: null, isCollection: false, default: null, label: 'Sender receives BCC of first email sent?'},
		senderDisplayName: {value: null, dataType: null, isCollection: false, default: null, label: 'Sender Display Name'},
		replyEmailAddress: {value: null, dataType: null, isCollection: false, default: null, label: 'Reply Email Address'},
		UseSalesforceSignature: {value: null, dataType: null, isCollection: true, default: null, label: 'Use Salesforce Signature if executing user has one?'},
		InReplyTo: {value: null, dataType: null, isCollection: true, default: null, label: 'MessageId List of existing email if this is InReplyTo'},
		templateName: {value: null, dataType: null, isCollection: false, default: null, label: 'Template Name'},
		templateLanguage: {value: null, dataType: null, isCollection: false, default: null, label: 'Template Language'},
		targetObjectIds: {value: null, dataType: null, isCollection: true, default: null, label: 'Recipient Record Id Collection (also for template merge fields and recording Email as an activity)'},
		whatIds: {value: null, dataType: null, isCollection: true, default: null, default: null, label: 'Related Record Id Collection(for template merge fields and recording Email as a task)'},
		saveAsActivity: {value: null, dataType: null, isCollection: false, default: null, label: 'Save Email as Activity on Recipient Record(s)?'},
		saveAsTask: {value: null, dataType: null, isCollection: false, default: null, label: 'Save Email as Task on recipient related record(s)?'},
		setTreatTargetObjectAsRecipient: {value: null, dataType: null, isCollection: false, default: true, label: 'Treat the target as a recipient. Defaults to True'},
		cb_setTreatTargetObjectAsRecipient: {value: 'CB_TRUE', dataType: null, isCollection: false, default: false, label: '!Treat the target as a recipient.'},
		recordId: {value: null, valueDataType: null, isCollection: false, default: null, label: 'Related Record Id (for template merge fields and/or recording Email as a task)'},
		SendTOthisOneEmailAddress: {value: null, valueDataType: 'String', isCollection: false, default: null, label: 'SendTOthisOneEmailAddress'},
		SendTOthisStringCollectionOfEmailAddresses: {value: null, valueDataType: null, isCollection: false, default: null, label: 'SendTOthisStringCollectionOfEmailAddresses'},
		SendTOtheEmailAddressesFromThisCollectionOfContacts: {value: null, valueDataType: null, isCollection: false, default: null, label: 'SendTOtheEmailAddressesFromThisCollectionOfContacts'},
		SendTOtheEmailAddressesFromThisCollectionOfUsers: {value: null, valueDataType: null, isCollection: false, default: null, label: 'SendTOtheEmailAddressesFromThisCollectionOfUsers'},
		SendTOtheEmailAddressesFromThisCollectionOfLeads: {value: null, valueDataType: null, isCollection: false, default: null, label: 'SendTOtheEmailAddressesFromThisCollectionOfLeads'},
		SendCCthisOneEmailAddress: {value: null, valueDataType: 'String', isCollection: false, default: null, label: 'SendCCthisOneEmailAddress'},
		SendCCthisStringCollectionOfEmailAddresses: {value: null, valueDataType: null, isCollection: false, default: null, label: 'SendCCthisStringCollectionOfEmailAddresses'},
		SendCCtheEmailAddressesFromThisCollectionOfContacts: {value: null, valueDataType: null, isCollection: false, default: null, label: 'SendCCtheEmailAddressesFromThisCollectionOfContacts'},
		SendCCtheEmailAddressesFromThisCollectionOfUsers: {value: null, valueDataType: null, isCollection: false, default: null, label: 'SendCCtheEmailAddressesFromThisCollectionOfUsers'},
		SendCCtheEmailAddressesFromThisCollectionOfLeads: {value: null, valueDataType: null, isCollection: false, default: null, label: 'SendCCtheEmailAddressesFromThisCollectionOfLeads'},
		SendBCCthisOneEmailAddress: {value: null, valueDataType: 'String', isCollection: false, default: null, label: 'SendBCCthisOneEmailAddress'},
		SendBCCthisStringCollectionOfEmailAddresses: {value: null, valueDataType: null, isCollection: false, default: null, label: 'SendBCCthisStringCollectionOfEmailAddresses'},
		SendBCCtheEmailAddressesFromThisCollectionOfContacts: {value: null, valueDataType: null, isCollection: false, default: null, label: 'SendBCCtheEmailAddressesFromThisCollectionOfContacts'},
		SendBCCtheEmailAddressesFromThisCollectionOfUsers: {value: null, valueDataType: null, isCollection: false, default: null, label: 'SendBCCtheEmailAddressesFromThisCollectionOfUsers'},
		SendBCCtheEmailAddressesFromThisCollectionOfLeads: {value: null, valueDataType: null, isCollection: false, default: null, label: 'SendBCCtheEmailAddressesFromThisCollectionOfLeads'},
		contentDocumentAttachments: {value: null, valueDataType: null, isCollection: false, default: null, label: 'Attach which Content Document Links?'}
	};

	bodyOptions = [
		{label: 'Specify Body here', value: constVal.specifyBodyOption,fields: ['HTMLbody','plainTextBody']},
		{label: 'Use Email Template',value: constVal.useTemplateOption,fields: ['templateID','templateTargetObjectId','templateName']}
	];

	emailTemplateOptions = [
		{label: 'Specify Template by Id Here', value: constVal.specifyBodyOption,fields: ['templateID','templateTargetObjectId']},
		{label: 'Use template with this name',value: constVal.useTemplateNameOption,fields: ['templateName','templateLanguage']}
	];

	emailOptions = [
		{label: 'Standard Email', value: constVal.singleEmailOption},
		{label: 'Mass Email',value: constVal.massEmailOption}
	];

	@track convertedFlowContext;
	@track stringOptions = [];

	@track isInitialized = true; //helps ensure all data structures are ready before rendering starts
	@track selectedBodyOption = constVal.specifyBodyOption;
	get isSpecifyBodyOption() {
		return this.selectedBodyOption === constVal.specifyBodyOption;
	}
	@track selectedEmailOption = constVal.singleEmailOption;
	@track isMassEmail = true;


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

	@track availableRecipients = [{
		baseLabel: 'TO',
		label: 'TO',
		value: [],
		objectType: null,
		typeMap: {
			'User': 'SendTOtheEmailAddressesFromThisCollectionOfUsers',
			'Contact': 'SendTOtheEmailAddressesFromThisCollectionOfContacts',
			'Lead': 'SendTOtheEmailAddressesFromThisCollectionOfLeads',
			'String Collection': 'SendTOthisStringCollectionOfEmailAddresses',
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
			'String Collection': 'SendCCthisStringCollectionOfEmailAddresses',
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
			'String Collection': 'SendBCCthisStringCollectionOfEmailAddresses',
			'String Variables (or type an address)': 'SendBCCthisOneEmailAddress'
		}
	}];

	initializeValues(value) {
		let roleManagerValues = {};
		if (this._values && this._values.length) {
			this._values.forEach(curInputParam => {
				if (curInputParam.name && this.inputValues[curInputParam.name]) {
					this.inputValues[curInputParam.name].value = curInputParam.value;
					this.inputValues[curInputParam.name].valueDataType = curInputParam.valueDataType;
				}
				this.initializeAvailableRecipientsValues(curInputParam, roleManagerValues);
			});
		}
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
		this.initializeEmailOptions();
		this.initializeBodyOptions();
		this.isInitialized = true;
	}

	initializeAvailableRecipientsValues(curInputParam, roleManagerValues) {
		this.availableRecipients.forEach(curRecipient => {
			Object.keys(curRecipient.typeMap).forEach(curObjectType => {
				if (curRecipient.typeMap[curObjectType] === curInputParam.name) {
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

	initializeBodyOptions() {
		this.bodyOptions.forEach(curBodyOption => {
			let hasValue = false;
			curBodyOption.fields.forEach(curBodyField => {
				if (!hasValue && this.inputValues[curBodyField].value) {
					this.selectedBodyOption = curBodyOption.value;
					hasValue = true;
				}
			});
		});
	}

initializeEmailOptions() {
		this.inputValues.emailMessageType.value = this.inputValues.emailMessageType.value ? this.inputValues.emailMessageType.value : constVal.singleEmailOption;
		this.isMassEmail = this.inputValues.emailMessageType.value === constVal.massEmailOption;
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

		allowedTypes.forEach(curType => {
			if (curType === 'String'){
				let allVariables = flowContext.variables.filter(curValue => {
					return curValue.dataType === curType && curValue.isCollection
				});
				this.addToOutputTypes(outputTypes,allVariables,constVal.stringCollectionVariablesOption,false);
				allVariables = flowContext.variables.filter(curValue => {
					return curValue.dataType === curType && !curValue.isCollection
				});
				this.addToOutputTypes(outputTypes,allVariables,constVal.stringVariablesOption,false);
				allVariables = flowContext.formulas.filter(curValue => {
					return curValue.dataType === curType && !curValue.isCollection
				});
				this.addToOutputTypes(outputTypes,allVariables,constVal.stringVariablesOption,false);
			} else {
				let allVariables = flowContext.variables.filter(curValue => {
					return curValue.dataType === 'SObject' && curValue.objectType === curType
				});
				this.addToOutputTypes(outputTypes,allVariables,curType,true);
			}
			if (!(constVal.stringVariablesOption in outputTypes)){
				outputTypes[constVal.stringVariablesOption] = {
					data: [],
					valueFieldName: 'name',
					labelFieldName: 'name'
				}
			}
		});
		this.convertedFlowContext = outputTypes;
	}
	addToOutputTypes(outputTypes,theseVariables,variablesOption,isSObject) {
		let retVal = null;
		if (theseVariables && theseVariables.length) {
			if (!(variablesOption in outputTypes)) {
				outputTypes[variablesOption] = {
					data: [],
					valueFieldName: 'name',
					labelFieldName: 'name'
				}
			}
			outputTypes[variablesOption].data.push(...theseVariables);
		}
	}

	doCleanRoleManager(baseLabel, newValueObjectType) {
		let valuesToCleanUp = [];
		this.availableRecipients.forEach(curRecipient => {
			if (!baseLabel || baseLabel === curRecipient.baseLabel) {
				Object.keys(curRecipient.typeMap).forEach(curType => {
					if (newValueObjectType !== curType) {
						valuesToCleanUp = valuesToCleanUp.concat(this._values.filter(curValue => curValue.name === curRecipient.typeMap[curType]));
					}
				});
			}
		});

		if (valuesToCleanUp.length) {
			valuesToCleanUp.forEach(valueToCleanUp => {
				if (valueToCleanUp && valueToCleanUp.value) {
					this.dispatchFlowValueChangeEvent(valueToCleanUp.name, constVal.nullValue, constVal.stringCollectionVariablesOption);
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
						this.dispatchFlowValueChangeEvent(curBodyField, constVal.nullValue, constVal.stringDataType);
					}
				});
			});
		}
	}

	dispatchFlowValueChangeEvent(id = '', newValue = '', newValueDataType = '') {
		const valueChangedEvent = new CustomEvent('configuration_editor_input_value_changed', {
			bubbles: true,
			cancelable: false,
			composed: true,
			detail: {
				name: id,
				newValue: newValue,
				newValueDataType: newValueDataType
			}
		});
		this.dispatchEvent(valueChangedEvent);
	}

	handleBodyOptionChange(event) {
		this.selectedBodyOption = event.detail.value;
		this.doClearBodyOptions();
	}

// This code is for setting up checkbox with defaults - should be forward compatible
	handleCheckboxChange(event) {   // Handle a change of event for a Checkbox to store as boolean value
		if (event.target && event.detail) {
			let changedAttribute = event.target.name.replace(cbConstants.checkbox_prefix, '');
			this.dispatchFlowValueChangeEvent(changedAttribute, event.detail.newValue, event.detail.newValueDataType);
			this.dispatchFlowValueChangeEvent(cbConstants.cbNotPrefix+changedAttribute, event.detail.newStringValue, 'String');
		}
	}
//	end of checkbox with default code

	handleClearAll(event) {
		this.doCleanRoleManager();
	}

	handleEmailOptionChange(event) {
		let curAttributeName = event.target.name ? event.target.name : null;
		this.inputValues.emailMessageType.value = event.detail.value;
		this.isMassEmail = this.inputValues.emailMessageType.value === constVal.massEmailOption;
		this.dispatchFlowValueChangeEvent(curAttributeName, event.detail.value, constVal.flowDataTypeBoolean);
		//		this.doClearBodyOptions();
	}

	handleFlowComboboxValueChange(event) {
		if (event.target && event.detail) {
			let formattedValue = (event.detail.newValueDataType === constVal.flowDataTypeString || !event.detail.newValue) ? event.detail.newValue : '{!' + event.detail.newValue + '}';
			this.dispatchFlowValueChangeEvent(event.target.name, formattedValue, event.detail.newValueDataType);
		}
	}

	handleValueChange(event) {
		if (event.target) {
			let curAttributeName = event.target.name ? event.target.name : null;
			let curAttributeValue = event.target.type === constVal.eventDataTypeCheckbox ? event.target.checked : event.detail.value;
			let curAttributeType;
			switch (event.target.type) {
				case constVal.eventDataTypeCheckbox:
					curAttributeType = constVal.flowDataTypeBoolean;
					break;
				case constVal.eventDataTypeNumber:
					curAttributeType = constVal.flowDataTypeNumber;
					break;
				default:
					curAttributeType = constVal.flowDataTypeString;
			}
			this.dispatchFlowValueChangeEvent(curAttributeName, curAttributeValue, curAttributeType);
		}
	}

	handleValueSelected(event) {
		let curRecipient = this.availableRecipients.find(curRec => curRec.baseLabel === event.detail.name);
		this.doCleanRoleManager(event.detail.name, event.detail.newValueObjectType);

		if (curRecipient) {
			let attributeToChange = curRecipient.typeMap[event.detail.newValueObjectType];
			let newLabel = event.detail.newValue ? curRecipient.baseLabel + ' (' + event.detail.newValue + ')' : curRecipient.baseLabel;
			curRecipient.label = newLabel;
			if (event.detail.newValueType === constVal.stringCollectionVariablesOption) {
				this.dispatchFlowValueChangeEvent(attributeToChange, event.detail.newValue ? event.detail.newValue : constVal.nullValue, constVal.stringCollectionVariablesOption);
			} else {
				this.dispatchFlowValueChangeEvent(attributeToChange, event.detail.newValue ? ( event.detail.newValueType === constVal.referenceDataType ? '{!' + event.detail.newValue + '}': event.detail.newValue) : constVal.nullValue, event.detail.newValueType);
			}
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