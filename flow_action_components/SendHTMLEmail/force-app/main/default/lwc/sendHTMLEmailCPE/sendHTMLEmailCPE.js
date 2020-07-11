/**
 * @File Name			: sendHTMLEmailCPE.js
 * @Description			: 
 * @Author				: Jack D. Pond
 * @Credits				: From quickChoiceCPE,Andrii Kraiev and sentRichEmailCPE,Alex Edelstein etal.
 * @Group				: 
 * @Last Modified By	: Jack D. Pond
 * @Last Modified On	: 07-10-2020
 * @Modification Log	: 
 * Ver		Date		Author				Modification
 * 1.0		6/29/2020	Jack D. Pond		Initial Version
**/
import {api, track, LightningElement} from 'lwc';

/*	MassEmail

	saveAsTask
	setBccSender(bcc)
	setDescription(description)
	setReplyTo(replyAddress)
	setSaveAsActivity(saveAsActivity)
	setSenderDisplayName(displayName)
	setTargetObjectIds(targetObjectIds)
	setTemplateID(templateId)
	setUseSignature(useSignature)
	setWhatIds(whatIds)
*/

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
		displayModeVisualCards: 'Visual',
		displayModePicklist: 'Picklist',
		displayModeRadio: 'Radio',
		inputModePicklist: 'Picklist Field',
		inputModeDualCollection: 'Dual String Collections',
		inputModeSingleCollection: 'Single String Collection',
		inputValueRecordTypeId: 'recordTypeId',
		choiceLabelsPicklistLabelsLabel: 'Choice Labels',
		choiceLabelsPicklistValuesLabel: 'Choice Values',
		choiceLabelsCardLabelsLabel: 'Card Titles',
		choiceLabelsCardValuesLabel: 'Card Descriptions',
		attributeObjectName: 'objectName',
		attributeFieldName: 'fieldName',
		attributeInputMode: 'inputMode',
		flowDataTypeString: 'String',
		availableFieldTypesPicklist: 'Picklist',
		inputAttributePrefix: 'select_'
	}

	@track inputValues = {
		displayMode: {value: null, valueDataType: null, isCollection: false, label: 'Display the choices as:'},
		inputMode: {value: null, valueDataType: null, isCollection: false, label: 'Select datasource:'},
		choiceLabels: {value: null, valueDataType: null, isCollection: true, label: 'Choice Labels [Card Titles]'},
		choiceValues: {value: null, valueDataType: null, isCollection: true, label: 'Choice Values [Card Descriptions]'},
		orgWideEmailAddressId: {value: null, valueDataType: null, isCollection: false, label: 'Reply Email Address'},
		senderDisplayName: {value: null, valueDataType: null, isCollection: false, label: 'Sender Display Name'},
		subject: {value: null, valueDataType: null, isCollection: false, label: 'Subject'},
		HTMLbody: {value: null, valueDataType: null, isCollection: false, label: 'HTML Body'},
		plainTextBody: {value: null, valueDataType: null, isCollection: false, label: 'Plain Text'},
		templateID: {value: null, valueDataType: null, isCollection: false, label: 'Select  Email Template by Id'},
		templateTargetObjectId: {value: null, valueDataType: null, isCollection: false, label: 'Specify Target record ID'},
		bodyOption: {value: this.settings.specifyBodyOption, dataType: this.settings.flowDataTypeString, isCollection: false, label: 'Body'},
		emailMessageType: {value: null, dataType: null, isCollection: false, label: 'Select Email Type'},
		description: {value: null, dataType: null, isCollection: false, label: 'Description to send for flow action results email notification'},
		bcc: {value: null, dataType: null, isCollection: false, label: 'Sender receives BCC of first email sent?'},
		senderDisplayName: {value: null, dataType: null, isCollection: false, label: 'senderDisplayName'},
		replyEmailAddress: {value: null, dataType: null, isCollection: false, label: 'Reply Email Address'},
		UseSalesforceSignature: {value: null, dataType: null, isCollection: false, label: 'Use SalesForce Signature if executing user has one?'},
		templateName: {value: null, dataType: null, isCollection: false, label: 'Template Name'},
		templateLanguage: {value: null, dataType: null, isCollection: false, label: 'Template Language'},
		targetObjectIds: {value: null, dataType: null, isCollection: false, label: 'targetObjectIds collection'},
		whatIds: {value: null, dataType: null, isCollection: false, label: 'whatIds collection'},
		saveAsActivity: {value: null, dataType: null, isCollection: false, label: 'saveAsActivity on targetId(s)'},
		saveAsTask: {value: null, dataType: null, isCollection: false, label: 'saveAsTask on related records?'},
		recordId: {value: null, valueDataType: null, isCollection: false, label: 'Related Record ID(whatId/recordId)'},
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
		SendBCCtheEmailAddressesFromThisCollectionOfLeads: {value: null, valueDataType: null, isCollection: false, label: 'SendBCCtheEmailAddressesFromThisCollectionOfLeads'}
/*
		allowNoneToBeChosen: {value: null, valueDataType: null, isCollection: false, label: 'Add a \'None\' choice'},
		required: {value: null, valueDataType: null, isCollection: false, label: 'Required'},
		masterLabel: {value: null, valueDataType: null, isCollection: false, label: 'Master Label'},
		value: {value: null, valueDataType: null, isCollection: false, label: 'Value (Default or Existing)'},
		style_width: {value: null, valueDataType: null, isCollection: false, label: 'Width (Pixels)'},
		numberOfColumns: {value: null, valueDataType: null, isCollection: false, label: 'Number of Columns'},
		includeIcons: {value: null, valueDataType: null, isCollection: false, label: 'Show Icons'},
		choiceIcons: {value: null, valueDataType: null, isCollection: true, label: 'Choice Icons [Card Icons]'},
		iconSize: {value: null, valueDataType: null, isCollection: false, label: 'Icon Size'},
		objectName: {value: null, valueDataType: null, isCollection: false, label: 'Select Object'},
		fieldName: {value: null, valueDataType: null, isCollection: false, label: 'Select Field'},
		recordTypeId: {value: null, valueDataType: null, isCollection: false, label: 'Filter on Record Type ID:'},
*/
	};


	bodyOptions = [
		{label: 'Specify Body here', value: this.settings.specifyBodyOption,fields: ['HTMLbody','plainTextBody']},
		{label: 'Use Email Template',value: this.settings.useTemplateOption,fields: ['templateID','templateTargetObjectId']}
	];

	emailTemplateOptions = [
		{label: 'Specify Template by Id Here', value: this.settings.specifyBodyOption,fields: ['templateID','templateTargetObjectId']},
		{label: 'Use template with this name',value: this.settings.useTemplateNameOption,fields: ['templateName','templateName']}
	];

	emailOptions = [
		{label: 'Single Email Message', value: this.settings.singleEmailOption,fields: ['HTMLbody','plainTextBody']},
		{label: 'Mass Email Messages',value: this.settings.massEmailOption,fields: ['templateID','templateTargetObjectId']}
	];

	displayChoicesAsOptions = [
		{label: 'Picklist', value: 'Picklist'},
		{label: 'Radio Button Group', value: 'Radio'},
		{label: 'Visual Cards', value: 'Visual'}
	];

	numberOfColumnOptions = [
		{label: '1', value: '1'},
		{label: '2', value: '2'}
	];

	iconSizeOptions = [
		{label: 'x-small', value: 'x-small'},
		{label: 'small', value: 'small'},
		{label: 'medium', value: 'medium'},
		{label: 'large', value: 'large'}
	];

	selectDataSourceOptions = [
		{label: 'A Picklist field', value: this.settings.inputModePicklist},
		{label: 'Two String Collections (Labels and Values)', value: this.settings.inputModeDualCollection},
		{label: 'One String Collection (Values)', value: this.settings.inputModeSingleCollection}
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

	get isVisualCards() {
		return this.inputValues.displayMode.value === this.settings.displayModeVisualCards;
	}

	get isDatasourcePicklist() {
		return this.inputValues.inputMode.value === this.settings.inputModePicklist;
	}

	get isDatasourceDualCollection() {
		return this.inputValues.inputMode.value === this.settings.inputModeDualCollection;
	}

	get isDatasourceSingleOrDualCollection() {
		return this.inputValues.inputMode.value === this.settings.inputModeSingleCollection || this.inputValues.inputMode.value === this.settings.inputModeDualCollection;
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

	initializeValues(value) {
		let roleManagerValues = {};
		if (this._values && this._values.length) {
			this._values.forEach(curInputParam => {
				if (curInputParam.name && this.inputValues[curInputParam.name]) {
					this.inputValues[curInputParam.name].value = curInputParam.value;
					this.inputValues[curInputParam.name].valueDataType = curInputParam.valueDataType;
				}
				this.setAvailableRecipientsValues(curInputParam, roleManagerValues);
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
		this.setInputMode();
		this.setChoiceLabels();
		this.initializeEmailOptions();
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
	initializeEmailOptions() {
		this.inputValues.emailMessageType.value = this.inputValues.emailMessageType.value ? this.inputValues.emailMessageType.value : this.settings.singleEmailOption;
		this.isMassEmail = this.inputValues.emailMessageType.value === this.settings.massEmailOption;
	}

	setChoiceLabels() {
		if (this.inputValues.displayMode.value === this.settings.displayModeVisualCards &&
			this.inputValues.choiceLabels.label !== this.settings.choiceLabelsCardLabelsLabel) {
			this.inputValues.choiceLabels.label = this.settings.choiceLabelsCardLabelsLabel;
			this.inputValues.choiceValues.label = this.settings.choiceLabelsCardValuesLabel;
		}
		if (this.inputValues.displayMode.value !== this.settings.displayModeVisualCards &&
			this.inputValues.choiceLabels.label !== this.settings.choiceLabelsPicklistLabelsLabel) {
			this.inputValues.choiceLabels.label = this.settings.choiceLabelsPicklistLabelsLabel;
			this.inputValues.choiceValues.label = this.settings.choiceLabelsPicklistValuesLabel;
		}
	}

	setInputMode() {
		if (this.inputValues.displayMode.value === this.settings.displayModeVisualCards && this.inputValues.inputMode.value !== this.settings.inputModeDualCollection) {
			this.dispatchFlowValueChangeEvent(this.settings.attributeInputMode, this.settings.inputModeDualCollection, this.settings.flowDataTypeString);
		}
	}

	handlePickObjectAndFieldValueChange(event) {
		if (event.detail) {
			this.dispatchFlowValueChangeEvent(this.settings.attributeObjectName, event.detail.objectType, this.settings.flowDataTypeString);
			this.dispatchFlowValueChangeEvent(this.settings.attributeFieldName, event.detail.fieldName, this.settings.flowDataTypeString);
		}
	}

	handleFlowComboboxValueChange(event) {
		if (event.target && event.detail) {
			let formattedValue = (event.detail.newValueDataType === this.settings.flowDataTypeString || !event.detail.newValue) ? event.detail.newValue : '{!' + event.detail.newValue + '}';
			this.dispatchFlowValueChangeEvent(event.target.name.replace(this.settings.inputAttributePrefix, ''), formattedValue, event.detail.newValueDataType);
		}
	}

	handleValueChange(event) {
		if (event.target) {
			let curAttributeName = event.target.name ? event.target.name.replace(this.settings.inputAttributePrefix, '') : null;
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

	dispatchFlowValueChangeEvent(id = '', newValue = '', newValueDataType = '') {
		const valueChangedEvent = new CustomEvent('configuration_editor_input_value_changed', {
			bubbles: true,
			cancelable: false,
			composed: true,
			detail: {
				id: id,
				newValue: newValue ? newValue : null,
				newValueDataType: newValueDataType
			}
		});
		this.dispatchEvent(valueChangedEvent);
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
		console.log(JSON.stringify(flowContext, null, 4));
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

	handleEmailOptionChange(event) {
		let curAttributeName = event.target.name ? event.target.name.replace(this.settings.inputAttributePrefix, '') : null;
		this.inputValues.emailMessageType.value = event.detail.value;
		this.isMassEmail = this.inputValues.emailMessageType.value === this.settings.massEmailOption;
		this.dispatchFlowValueChangeEvent(curAttributeName, event.detail.value, "String");
		//		this.doClearBodyOptions();
	}
}