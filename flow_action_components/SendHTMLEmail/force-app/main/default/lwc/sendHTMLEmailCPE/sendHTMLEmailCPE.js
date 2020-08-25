/**
 * @File Name			: sendHTMLEmailCPE.js
 * @Description			: CPE for sendHTMLEmail - an extended functionality for sending email
 * @Author				: Jack D. Pond
 * @Credits				: From quickChoiceCPE,Andrii Kraiev and sentRichEmailCPE,Alex Edelstein etal.
 * @Group				: 
 * @Last Modified By	: Jack D. Pond
 * @Last Modified On	: 08-13-2020
 * @Modification Log	: 
 * Ver		Date		Author				Modification
 * 1.33.2	6/29/2020	Jack D. Pond		Initial Version
**/
import {api, track, LightningElement} from 'lwc';

export default class SendHTMLEmailCPE extends LightningElement {
	_builderContext;
	_values;
	convertedFlowContext;

	settings = {
		specifyBodyOption: 'specifyBody',
		useTemplateOption: 'useTemplate',
		useTemplateNameOption: 'useTemplateName',
		singleEmailOption: 'singleEmail',
		massEmailOption: 'massEmail',
		flowDataTypeString: 'String',
		stringCollectionVariablesOption: 'String Collection',
		stringVariablesOption: 'String Variables (or type an address)',
		stringDataType: 'String',
		referenceDataType: 'reference',
		nullValue: ''
	}

	@track inputValues = {
		orgWideEmailAddressId: {value: null, valueDataType: null, isCollection: false, label: 'Organization Wide Email Address'},
		senderDisplayName: {value: null, valueDataType: null, isCollection: false, label: 'Sender Display Name'},
		subject: {value: null, valueDataType: null, isCollection: false, label: 'Subject'},
		HTMLbody: {value: null, valueDataType: null, isCollection: false, label: 'HTML Body'},
		plainTextBody: {value: null, valueDataType: null, isCollection: false, label: 'Plain Text'},
		templateID: {value: null, valueDataType: null, isCollection: false, label: 'Email Template Id'},
		templateTargetObjectId: {value: null, valueDataType: null, isCollection: false, label: 'Recipient Record Id (also for template merge fields and recording related Email as an activity)'},
		bodyOption: {value: this.settings.specifyBodyOption, dataType: this.settings.flowDataTypeString, isCollection: false, label: 'Body'},
		emailMessageType: {value: null, dataType: null, isCollection: false, label: 'Email Type'},
		description: {value: null, dataType: null, isCollection: false, label: 'Description (sent in internal email with status after action completes)'},
		bcc: {value: null, dataType: null, isCollection: false, label: 'Sender receives BCC of first email sent?'},
		senderDisplayName: {value: null, dataType: null, isCollection: false, label: 'Sender Display Name'},
		replyEmailAddress: {value: null, dataType: null, isCollection: false, label: 'Reply Email Address'},
		UseSalesforceSignature: {value: null, dataType: null, isCollection: false, label: 'Use Salesforce Signature if executing user has one?'},
		templateName: {value: null, dataType: null, isCollection: false, label: 'Template Name'},
		templateLanguage: {value: null, dataType: null, isCollection: false, label: 'Template Language'},
		targetObjectIds: {value: null, dataType: null, isCollection: true, label: 'Recipient Record Id Collection (also for template merge fields and recording Email as an activity)'},
		whatIds: {value: null, dataType: null, isCollection: true, label: 'Related Record Id Collection(for template merge fields and recording Email as a task)'},
		saveAsActivity: {value: null, dataType: null, isCollection: false, label: 'Save Email as Activity on Recipient Record(s)?'},
		saveAsTask: {value: null, dataType: null, isCollection: false, label: 'Save Email as Task on recipient related record(s)?'},
		recordId: {value: null, valueDataType: null, isCollection: false, label: 'Related Record Id (for template merge fields and/or recording Email as a task)'},
		SendTOthisOneEmailAddress: {value: null, valueDataType: null, isCollection: false, label: 'SendTOthisOneEmailAddress'},
		SendTOthisStringCollectionOfEmailAddresses: {value: null, valueDataType: null, isCollection: false, label: 'SendTOthisStringCollectionOfEmailAddresses'},
		SendTOtheEmailAddressesFromThisCollectionOfContacts: {value: null, valueDataType: null, isCollection: false, label: 'SendTOtheEmailAddressesFromThisCollectionOfContacts'},
		SendTOtheEmailAddressesFromThisCollectionOfUsers: {value: null, valueDataType: null, isCollection: false, label: 'SendTOtheEmailAddressesFromThisCollectionOfUsers'},
		SendTOtheEmailAddressesFromThisCollectionOfLeads: {value: null, valueDataType: null, isCollection: false, label: 'SendTOtheEmailAddressesFromThisCollectionOfLeads'},
		SendCCthisOneEmailAddress: {value: null, valueDataType: null, isCollection: false, label: 'SendCCthisOneEmailAddress'},
		SendCCthisStringCollectionOfEmailAddresses: {value: null, valueDataType: null, isCollection: false, label: 'SendCCthisStringCollectionOfEmailAddresses'},
		SendCCtheEmailAddressesFromThisCollectionOfContacts: {value: null, valueDataType: null, isCollection: false, label: 'SendCCtheEmailAddressesFromThisCollectionOfContacts'},
		SendCCtheEmailAddressesFromThisCollectionOfUsers: {value: null, valueDataType: null, isCollection: false, label: 'SendCCtheEmailAddressesFromThisCollectionOfUsers'},
		SendCCtheEmailAddressesFromThisCollectionOfLeads: {value: null, valueDataType: null, isCollection: false, label: 'SendCCtheEmailAddressesFromThisCollectionOfLeads'},
		SendBCCthisOneEmailAddress: {value: null, valueDataType: null, isCollection: false, label: 'SendBCCthisOneEmailAddress'},
		SendBCCthisStringCollectionOfEmailAddresses: {value: null, valueDataType: null, isCollection: false, label: 'SendBCCthisStringCollectionOfEmailAddresses'},
		SendBCCtheEmailAddressesFromThisCollectionOfContacts: {value: null, valueDataType: null, isCollection: false, label: 'SendBCCtheEmailAddressesFromThisCollectionOfContacts'},
		SendBCCtheEmailAddressesFromThisCollectionOfUsers: {value: null, valueDataType: null, isCollection: false, label: 'SendBCCtheEmailAddressesFromThisCollectionOfUsers'},
		SendBCCtheEmailAddressesFromThisCollectionOfLeads: {value: null, valueDataType: null, isCollection: false, label: 'SendBCCtheEmailAddressesFromThisCollectionOfLeads'},
		contentDocumentAttachments: {value: null, valueDataType: null, isCollection: false, label: 'Attach which Content Document Links?'}
	};

	bodyOptions = [
		{label: 'Specify Body here', value: this.settings.specifyBodyOption,fields: ['HTMLbody','plainTextBody']},
		{label: 'Use Email Template',value: this.settings.useTemplateOption,fields: ['templateID','templateTargetObjectId']}
	];

	emailTemplateOptions = [
		{label: 'Specify Template by Id Here', value: this.settings.specifyBodyOption,fields: ['templateID','templateTargetObjectId']},
		{label: 'Use template with this name',value: this.settings.useTemplateNameOption,fields: ['templateName','templateLanguage']}
	];

	emailOptions = [
		{label: 'Standard Email', value: this.settings.singleEmailOption},
		{label: 'Mass Email',value: this.settings.massEmailOption}
	];

	@track convertedFlowContext;
	@track stringOptions = [];

	@track isInitialized = true; //helps ensure all data structures are ready before rendering starts
	@track selectedBodyOption = this.settings.specifyBodyOption;
	get isSpecifyBodyOption() {
		return this.selectedBodyOption === this.settings.specifyBodyOption;
	}
	@track selectedEmailOption = this.settings.singleEmailOption;
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
			'String': 'SendBCCthisStringCollectionOfEmailAddresses',
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
				}
			});
		});
	}

	initializeEmailOptions() {
		this.inputValues.emailMessageType.value = this.inputValues.emailMessageType.value ? this.inputValues.emailMessageType.value : this.settings.singleEmailOption;
		this.isMassEmail = this.inputValues.emailMessageType.value === this.settings.massEmailOption;
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
			return curValue.dataType === 'String' && curValue.isCollection
		});


		allowedTypes.forEach(curType => {
			if (curType === 'String'){
				let allVariables = flowContext.variables.filter(curValue => {
					return curValue.dataType === curType && curValue.isCollection
				});
				this.addToOutputTypes(outputTypes,allVariables,this.settings.stringCollectionVariablesOption,false);
				allVariables = flowContext.variables.filter(curValue => {
					return curValue.dataType === curType && !curValue.isCollection
				});
				this.addToOutputTypes(outputTypes,allVariables,this.settings.stringVariablesOption,false);
			} else {
				let allVariables = flowContext.variables.filter(curValue => {
					return curValue.dataType === 'SObject' && curValue.objectType === curType
				});
				this.addToOutputTypes(outputTypes,allVariables,curType,true);
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
					this.dispatchFlowValueChangeEvent(valueToCleanUp.name, this.settings.nullValue, this.settings.stringCollectionVariablesOption);
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

	dispatchFlowValueChangeEvent(id = '', newValue = '', newValueDataType = '') {
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

	handleBodyOptionChange(event) {
		this.selectedBodyOption = event.detail.value;
		this.doClearBodyOptions();
	}

	handleClearAll(event) {
		this.doCleanRoleManager();
	}

	handleEmailOptionChange(event) {
		let curAttributeName = event.target.name ? event.target.name : null;
		this.inputValues.emailMessageType.value = event.detail.value;
		this.isMassEmail = this.inputValues.emailMessageType.value === this.settings.massEmailOption;
		this.dispatchFlowValueChangeEvent(curAttributeName, event.detail.value, 'String');
		//		this.doClearBodyOptions();
	}

	handleFlowComboboxValueChange(event) {
		if (event.target && event.detail) {
			let formattedValue = (event.detail.newValueDataType === this.settings.flowDataTypeString || !event.detail.newValue) ? event.detail.newValue : '{!' + event.detail.newValue + '}';
			this.dispatchFlowValueChangeEvent(event.target.name, formattedValue, event.detail.newValueDataType);
		}
	}

	handleValueChange(event) {
		if (event.target) {
			let curAttributeName = event.target.name ? event.target.name : null;
			let curAttributeValue = event.target.type === 'checkbox' ? event.target.checked : event.detail.value;
			let curAttributeType;
			switch (event.target.type) {
				case 'checkbox':
					curAttributeType = 'Boolean';
					break;
				case 'number':
					curAttributeType = 'Number';
					break;
				default:
					curAttributeType = 'String';
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
			if (event.detail.newValueType === this.settings.stringCollectionVariablesOption) {
				this.dispatchFlowValueChangeEvent(attributeToChange, event.detail.newValue ? event.detail.newValue : this.settings.nullValue, this.settings.stringCollectionVariablesOption);
			} else {
				this.dispatchFlowValueChangeEvent(attributeToChange, event.detail.newValue ? '{!' + event.detail.newValue + '}' : this.settings.nullValue, this.settings.referenceDataType);
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