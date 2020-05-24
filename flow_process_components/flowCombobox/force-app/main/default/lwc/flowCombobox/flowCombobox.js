import {LightningElement, wire, api, track} from 'lwc';
import {getObjectInfo} from 'lightning/uiObjectInfoApi';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import {formattedValue, isReference, getDataType, removeFormatting, flowComboboxDefaults} from 'c/flowComboboxUtils';

export default class FlowCombobox extends LightningElement {
    @api name;
    @api label;
    @api required = false;
    @api builderContextFilterType;
    @api builderContextFilterCollectionBoolean;
    @api maxWidth;
    @track _dataType;
    @track _value;
    @track allOptions;
    @track _options = [];
    @track _mergeFields = [];
    @track dropdownClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
    @track isDataSelected = false;
    @track _selectedObjectType;
    @track _selectedFieldPath;
    @track hasError = false;
    isMenuOpen = false;
    isDataModified = false;
    selfEvent = false;
    key = 0;
    _builderContext;
    labels = {
        noDataAvailable: 'No data available',
        staticOptionsLabel: 'OBJECT FIELDS',
        invalidReferenceError: 'This Flow doesn\'t have a defined resource with that name. If you\'re trying to enter a literal value, don\'t use {!}',
    };
    iconsPerType = {
        String: 'utility:text',
        Boolean: 'utility:check',
        Date: 'utility:date_input',
        DateTime: 'utility:date_time',
        Number: 'utility:number_input',
        Int: 'utility:number_input',
        Double: 'utility:number_input',
        Picklist: 'utility:picklist',
        TextArea: 'utility:textarea',
        Phone: 'utility:phone_portrait',
        Address: 'utility:location',
        Currency: 'utility:currency_input',
        Url: 'utility:link',
        SObject: 'utility:sobject',
        reference: 'utility:merge_field'
    };

    typeDescriptors = [
        {
            apiName: 'variables',
            label: 'Variables',
            dataType: 'dataType',
            objectTypeField: 'objectType',
            isCollectionField: 'getFirstRecordOnly'
        },
        {apiName: 'constants', label: 'Global Constants', dataType: flowComboboxDefaults.stringDataType},
        {apiName: 'textTemplates', label: 'Variables', dataType: flowComboboxDefaults.stringDataType},
        {apiName: 'stages', label: 'Variables', dataType: flowComboboxDefaults.stringDataType},
        // {apiName: 'screens.fields', label: 'Screen Components', dataType: flowComboboxDefaults.stringDataType},
        // {
        //     apiName: 'screens.fields.inputParameters',
        //     label: 'Screen Components',
        //     dataType: flowComboboxDefaults.stringDataType
        // },
        {
            apiName: flowComboboxDefaults.recordLookupsType,
            label: 'Variables',
            dataType: 'SObject',
            objectTypeField: 'object',
            isCollectionField: 'getFirstRecordOnly'
        },
        {apiName: 'formulas', label: 'Formulas', dataType: flowComboboxDefaults.stringDataType},
        // {apiName: 'actionCalls.inputParameters', label: 'Variables', dataType: flowComboboxDefaults.stringDataType},
        // {apiName: 'actionCalls.outputParameters', label: 'Variables', dataType: flowComboboxDefaults.stringDataType},
        // {apiName: 'apexPluginCalls', label: 'Variables', dataType: flowComboboxDefaults.stringDataType},
    ];

    _staticOptions
    @api
    get staticOptions() {
        return this._staticOptions;
    }

    set staticOptions(value) {
        this._staticOptions = value;
        this.processOptions();
    }

    @api
    get value() {
        return this._value;
    }

    set value(value) {
        this.isDataSelected = !!value;
        if (isReference(value)) {
            this._dataType = getDataType(value);
            this._value = removeFormatting(value);
        } else {
            this._value = value;
        }
        this.determineSelectedType();
    }

    @api
    get valueType() {
        return this._dataType;
    }

    set valueType(value) {
        if (!this._dataType) {
            if (value) {
                this._dataType = value;
            } else {
                this._dataType = flowComboboxDefaults.stringDataType;
            }

        }
    }

    @api get builderContext() {
        return this._builderContext;
    }

    set builderContext(value) {
        this._builderContext = value;
        this._mergeFields = this.generateMergeFieldsFromBuilderContext(this._builderContext);
        if (!this._selectedObjectType) {
            this.setOptions(this._mergeFields);
            this.determineSelectedType();
        }
    }

    get displayPill() {
        return this.isDataSelected && this._dataType === flowComboboxDefaults.referenceDataType;
    }

    setOptions(value) {
        this._options = value;
        this.allOptions = JSON.parse(JSON.stringify(this._options));
        this.processOptions();
    }

    getTypeOption(value) {
        if (value) {
            let parentVar = value.split('.')[0];
            if (parentVar && this._mergeFields && this._mergeFields.length) {
                for (let i = 0; i < this._mergeFields.length; i++) {
                    let localOption = this._mergeFields[i].options.find(curTypeOption => {
                        let result = (curTypeOption.value.toLowerCase() === parentVar.toLowerCase()) || (curTypeOption.value.toLowerCase() === value.toLowerCase());
                        return result;
                    });
                    if (localOption) {
                        return localOption;
                    }
                }
            }
        }
    }

    @wire(getObjectInfo, {objectApiName: '$_selectedObjectType'})
    _getObjectInfo({error, data}) {
        if (error) {
            this.showToast('Error', error.body, 'error');
            console.log(error.body);
            this.setOptions([]);
        } else if (data) {
            let tempOptions = [];
            // let localKey = 0;
            Object.keys(data.fields).forEach(curField => {
                let curFieldData = data.fields[curField];
                let curDataType = curFieldData.dataType === 'Reference' ? 'SObject' : curFieldData.dataType;
                let curObjectType = curFieldData.referenceToInfos.length ? curFieldData.referenceToInfos[0].apiName : null;
                tempOptions.push(this.generateOptionLine(
                    curDataType,
                    curFieldData.label,
                    curFieldData.apiName,
                    false,
                    curObjectType,
                    this.getIconNameByType(curDataType),
                    curDataType === 'SObject',
                    curDataType === 'SObject' ? curObjectType : curDataType,
                    flowComboboxDefaults.defaultKeyPrefix + this.key++
                ));
            });
            this.setOptions([{type: data.label + ' Fields', options: tempOptions}]);
        }

    }

    getTypes() {
        return this.typeDescriptors.map(curTypeDescriptor => curTypeDescriptor.apiName);
    }

    getTypeDescriptor(typeApiName) {
        return this.typeDescriptors.find(curTypeDescriptor => curTypeDescriptor.apiName === typeApiName);
    }

    determineSelectedType() {
        if (this._value && this.allOptions) {
            let valParts = this._value.replace(/[^a-zA-Z0-9._-]/g, '').split('.');
            if (valParts.length > 1) {
                this.allOptions.forEach(curOption => {
                    let localOptions = curOption.options;
                    let selectedOption = localOptions.find(curSelectedOption => curSelectedOption.value === valParts[0]);
                    if (selectedOption) {
                        this._selectedObjectType = selectedOption.displayType;
                        valParts.pop();
                        this._selectedFieldPath = valParts.join('.');
                    }
                });
            }
        }
    }

    generateMergeFieldsFromBuilderContext(builderContext) {
        let optionsByType = {};
        let key = 0;

        this.getTypes().forEach(curType => {
            let typeParts = curType.split('.');
            let typeOptions = [];

            if (typeParts.length && builderContext[typeParts[0]]) {
                let objectToExamine = builderContext;
                let parentNodeLabel = '';
                typeParts.forEach(curTypePart => {

                    if (objectToExamine[curTypePart]) {
                        objectToExamine = objectToExamine[curTypePart].map(curItem => {
                            parentNodeLabel = curItem.label ? curItem.label : curItem.name;
                            return {
                                ...curItem,
                                varApiName: curItem.name,
                                varLabel: parentNodeLabel
                            }
                        });
                    } else {
                        if (Array.isArray(objectToExamine)) {
                            let allObjectToExamine = [];
                            objectToExamine.forEach(curObjToExam => {
                                if (curObjToExam.storeOutputAutomatically) {
                                    //TODO: Uncomment when it is clear how to get output parameters from actions and flow screens
                                    // allObjectToExamine.push({
                                    //     varApiName: curObjToExam.name,
                                    //     varLabel: curObjToExam.label
                                    // });
                                } else {
                                    allObjectToExamine = [...allObjectToExamine, ...curObjToExam[curTypePart].map(curItem => {
                                        return {
                                            ...curItem, varApiName: curObjToExam.name + '.' + curItem.name,
                                            varLabel: (curObjToExam.label ? curObjToExam.label : parentNodeLabel) + ': ' + curItem.name
                                        }
                                    })];
                                }
                            });
                            objectToExamine = allObjectToExamine;
                        }
                    }

                });
                let localType = this.getTypeDescriptor(curType);

                let curTypeOptions = this.getOptionLines(
                    objectToExamine,
                    'varLabel',
                    'varApiName',
                    'dataType',
                    localType.isCollectionField ? localType.isCollectionField : 'isCollection',
                    localType.objectTypeField ? localType.objectTypeField : 'objectType',
                    localType
                );
                if (curTypeOptions.length) {
                    typeOptions = [...typeOptions, ...curTypeOptions];
                }
                if (typeOptions.length) {
                    // let localType = this.getTypeDescriptor(curType).label;
                    if (optionsByType[localType.label]) {
                        optionsByType[localType.label] = [...optionsByType[localType.label], ...typeOptions];
                    } else {
                        optionsByType[localType.label] = typeOptions;
                    }
                }
            } else {
                console.log(curType + ' is undefined');
            }
        });
        let options = [];
        let allOutputTypes = Object.keys(optionsByType);

        if (allOutputTypes.length) {
            allOutputTypes.forEach(curKey => {
                options.push({type: curKey, options: optionsByType[curKey]});
            });
        }
        return options;
    }

    getOptionLines(objectArray, labelField, valueField, typeField, isCollectionField, objectTypeField, typeDescriptor) {
        let typeOptions = [];
        objectArray.forEach(curObject => {

            let curDataType = this.getTypeByDescriptor(curObject[typeField], typeDescriptor);
            typeOptions.push(this.generateOptionLine(
                curDataType,
                curObject[labelField] ? curObject[labelField] : curObject[valueField],
                curObject[valueField],
                typeDescriptor.apiName === flowComboboxDefaults.recordLookupsType ? !curObject[isCollectionField] : !!curObject[isCollectionField],
                curObject[objectTypeField],
                this.getIconNameByType(curDataType),
                (curDataType === flowComboboxDefaults.dataTypeSObject || typeDescriptor.apiName === flowComboboxDefaults.recordLookupsType),
                curDataType === flowComboboxDefaults.dataTypeSObject ? curObject[objectTypeField] : curDataType,
                flowComboboxDefaults.defaultKeyPrefix + this.key++
            ));
        });
        return typeOptions;
    }

    getTypeByDescriptor(curObjectFieldType, typeDescriptor) {
        if (!typeDescriptor) {
            return flowComboboxDefaults.stringDataType;
        } else if (typeDescriptor.apiName === flowComboboxDefaults.recordLookupsType) {
            return flowComboboxDefaults.dataTypeSObject
        } else {
            return curObjectFieldType ? curObjectFieldType : flowComboboxDefaults.stringDataType;
        }
    }

    generateOptionLine(type, label, value, isCollection, objectType, optionIcon, isObject, displayType, key, flowType) {
        return {
            type: type,
            label: label,
            value: value,
            isCollection: isCollection,
            objectType: objectType,
            optionIcon: optionIcon,
            isObject: isObject,
            displayType: displayType,
            key: key,
            flowType: flowType ? flowType : flowComboboxDefaults.referenceDataType
        };
    }

    handleOpenObject(event) {
        event.stopPropagation();
        this._selectedFieldPath = (this._selectedFieldPath ? this._selectedFieldPath + '.' : '') + event.currentTarget.dataset.optionValue;
        this.value = this._selectedFieldPath + '.';
        this._selectedObjectType = event.currentTarget.dataset.objectType;
    }

    handleSetSelectedRecord(event) {
        if (event.currentTarget.dataset) {
            this._dataType = event.currentTarget.dataset.flowType;
            this.value = this.getFullPath(this._selectedFieldPath, event.currentTarget.dataset.value);
            this.isDataModified = true;
            this.hasError = false;
            this.closeOptionDialog();
        }
    }


    dispatchValueChangedEvent() {
        const valueChangedEvent = new CustomEvent('valuechanged', {
            detail: {
                id: this.name,
                newValue: this._value ? this._value : '',
                newValueDataType: this._dataType
            }
        });
        this.dispatchEvent(valueChangedEvent);
    }

    resetData(event) {
        this.value = '';
        this.resetTypeOptions();
        this.closeOptionDialog();
    }

    resetTypeOptions() {
        this.isDataModified = true;
        this._selectedFieldPath = '';
        this._selectedObjectType = null;
        this._dataType = flowComboboxDefaults.stringDataType;
        this.setOptions(this._mergeFields);
    }

    openOptionDialog(event) {
        // this.isDataSelected = false;
        this.isMenuOpen = true;
        this.dropdownClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-is-open';
    }

    closeOptionDialog(setValueInput) {

        if (this._value) {
            this.isDataSelected = true;
        }
        this.isMenuOpen = false;
        this.dropdownClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';

        if (setValueInput) {
            this.setValueInput();
        }

        if (this.isDataModified) {
            this.dispatchValueChangedEvent();
            this.isDataModified = false;
        }
    }

    constructor() {
        super();
        document.addEventListener('click', this.handleWindowClick.bind(this));
    }

    disconnectedCallback() {
        document.removeEventListener('click', this.handleWindowClick.bind(this));
    }

    handleWindowClick(event) {
        // console.log(Date.now());
        if (!event.path.includes(this.template.host) && !this.selfEvent) {
            this.closeOptionDialog(true);
        }
        this.selfEvent = false;
    }

    processOptions(searchString) {
        let searchLC = '';

        if (searchString) {
            let searchParts = searchString.split('.');
            searchLC = searchParts[searchParts.length - 1].toLowerCase();
        }

        this._options = [];
        if (this.allOptions && this.allOptions.length) {
            this.allOptions.forEach(curOption => {
                let localOptions = curOption.options;

                if (this.builderContextFilterType) {
                    localOptions = localOptions.filter(opToFilter => opToFilter.displayType === this.builderContextFilterType || (opToFilter.type === 'SObject' && !this.builderContextFilterCollectionBoolean));
                }

                if (typeof this.builderContextFilterCollectionBoolean !== "undefined") {
                    localOptions = localOptions.filter(opToFilter => opToFilter.isCollection === this.builderContextFilterCollectionBoolean);
                }

                if (searchLC) {
                    localOptions = localOptions.filter(opToFilter => opToFilter.label.toLowerCase().includes(searchLC) || opToFilter.value.toLowerCase().includes(searchLC.replace(/\W/g, '')));
                }

                if (localOptions.length) {
                    this._options.push({
                        ...curOption, ...{
                            options: localOptions,
                        }
                    });
                }
            });
        }

        if (this._staticOptions && this._staticOptions.length) {
            this._options.push({
                type: this.labels.staticOptionsLabel, options:
                    this._staticOptions.map(curOption => {
                        return this.generateOptionLine(
                            flowComboboxDefaults.stringDataType,
                            curOption.label,
                            curOption.value,
                            false,
                            flowComboboxDefaults.stringDataType,
                            "utility:text",
                            false,
                            flowComboboxDefaults.stringDataType,
                            flowComboboxDefaults.defaultKeyPrefix + this.key++,
                            flowComboboxDefaults.stringDataType,
                        )
                    })
            });
        }
    }

    getIconNameByType(variableType) {
        return this.iconsPerType[variableType];
    }

    handleOpenOptions(event) {
        // event.stopPropagation();
        console.log('handleOpenOptions');
        this.selfEvent = true;
        if (this.isMenuOpen) {
            this.isDataSelected = false;
            this._value = formattedValue(this._value, this._dataType);
        } else {
            this.openOptionDialog();
        }

    }

    handleOpenEditDialog(event) {
        event.stopPropagation();
        this.handleOpenOptions(event);
    }

    handleCloseOptions(event) {
        this.closeOptionDialog();
    }

    handleSearchField(event) {
        let currentText = event.target.value;
        this._dataType = getDataType(currentText);
        if (!currentText || !currentText.includes('.')) {
            this.resetTypeOptions();
            this.setOptions(this._mergeFields);
        }
        this.isDataModified = true;
        this.isDataSelected = false;

        this.processOptions(currentText);
        if (this.allOptions.length) {
            this.openOptionDialog();
        }
    }

    handleSearchKeyUp(event) {
        if (event.key === "Enter") {
            if (this.isMenuOpen) {
                this.closeOptionDialog(true);
            } else {
                this.openOptionDialog();
            }
        }
    }

    setValueInput() {
        let valueInput = this.template.querySelector('.value-input');
        if (valueInput) {
            this.hasError = false;
            let isRef = isReference(valueInput.value);
            this._value = removeFormatting(valueInput.value);
            if (isRef) {
                let typeOption = this.getTypeOption(this._value);
                if (!typeOption) {
                    this.hasError = true;
                }
                this._dataType = flowComboboxDefaults.referenceDataType;
            } else {
                this._dataType = flowComboboxDefaults.stringDataType;
            }
        }
    }

    getFullPath(path, val) {
        return (path ? path + '.' : '') + val;
    }

    get inputStyle() {
        if (this.maxWidth) {
            return 'max-width: ' + this.maxWidth + 'px;';
        }
    }

    @api
    reportValidity() {
        return !this.hasError;
    }

    get formElementClass() {
        let resultClass = 'slds-form-element';
        if (this.hasError) {
            resultClass += ' slds-has-error';
        }
        return resultClass;
    }

    showToast(title, message, variant) {
        const showToast = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        dispatchEvent(showToast);
    }

}