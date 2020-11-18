import {LightningElement, wire, api, track} from 'lwc';
import {getObjectInfo} from 'lightning/uiObjectInfoApi';
import {
    buildOptions,
    getErrorMessage,
    showToast,
    flashElement,
    iconsPerType
} from 'c/fieldSelectorUtils';

export default class FlowCombobox extends LightningElement {
    @api name;
    @api label;
    @api required = false;
    @api flowContextFilterType;
    @api flowContextFilterCollectionBoolean;
    @api maxWidth;
    @api mode = 'cpe';
    @api disabled;
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
    originalObjectName;
    displayType;
    isSObject;

    labels = {
        noDataAvailable: 'No data available',
        cpeMode: 'cpe'
    };

    typeDescriptors = [
        {apiName: 'variables', label: 'Variables', dataType: 'dataType'},
        {apiName: 'constants', label: 'Global Constants', dataType: 'String'},
        {apiName: 'textTemplates', label: 'Variables', dataType: 'String'},
        {apiName: 'stages', label: 'Variables', dataType: 'String'},
        {apiName: 'screens.fields', label: 'Screen Components', dataType: 'String'},
        {apiName: 'screens.fields.inputParameters', label: 'Screen Components', dataType: 'String'},
        {apiName: 'recordLookups', label: 'Variables', dataType: 'SObject'},
        {apiName: 'formulas', label: 'Formulas', dataType: 'String'},
        {apiName: 'actionCalls.inputParameters', label: 'Variables', dataType: 'String'},
        {apiName: 'actionCalls.outputParameters', label: 'Variables', dataType: 'String'},
        {apiName: 'apexPluginCalls', label: 'Variables', dataType: 'String'},
    ];

    settings = {
        stringDataType: 'String',
        referenceDataType: 'reference',
        invalidReferenceError: 'This Flow doesn\'t have a defined resource with that name. If you\'re trying to enter a literal value, don\'t use {!}',
        invalidFieldError: 'Selected field is invalid.'
    };

    @api
    get value() {
        return this._value;
    }

    set value(value) {
        this._value = value;
        this.isDataSelected = !!this._value;
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
                this._dataType = this.settings.stringDataType;
            }

        }
    }

    @api get flowContext() {
        return this._flowContext;
    }

    set flowContext(value) {
        this._flowContext = value;
        if (this.mode && this.mode.toLowerCase() === this.labels.cpeMode) {
            this._mergeFields = this.generateMergeFieldsFromFlowContext(this._flowContext);
        } else {
            this._mergeFields = value;
        }

        if (!this._selectedObjectType) {
            this.setOptions(this._mergeFields);
            this.determineSelectedType();
        }
    }

    @api get objectType() {
        return this._selectedObjectType;
    }

    set objectType(value) {
        this.originalObjectName = value;
        this._selectedObjectType = value;
    }

    get displayPill() {
        return !this.disabled && this.isDataSelected && (this._dataType === this.settings.referenceDataType || this.mode !== this.labels.cpeMode);
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
                    let localOption = this._mergeFields[i].options.find(curTypeOption => curTypeOption.value.toLowerCase() === parentVar.toLowerCase());
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
            showToast('Error', getErrorMessage(error), 'error');
            this.setOptions([]);
        } else if (data) {
            this._mergeFields = [{type: data.label + ' Fields', options: buildOptions(data.fields)}];
            this.setOptions(this._mergeFields);
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

    generateMergeFieldsFromFlowContext(flowContext) {
        let optionsByType = {};
        let key = 0;

        this.getTypes().forEach(curType => {
            let typeParts = curType.split('.');
            let typeOptions = [];

            if (typeParts.length && flowContext[typeParts[0]]) {
                let objectToExamine = flowContext;
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
                                allObjectToExamine = [...allObjectToExamine, ...curObjToExam[curTypePart].map(curItem => {
                                    return {
                                        ...curItem, varApiName: curObjToExam.name + '.' + curItem.name,
                                        varLabel: (curObjToExam.label ? curObjToExam.label : parentNodeLabel) + ': ' + curItem.name
                                    }
                                })];
                            });
                            objectToExamine = allObjectToExamine;
                        }
                    }

                });

                let curTypeOptions = this.getOptionLines(objectToExamine, 'varLabel', 'varApiName', 'dataType', 'isCollection', 'objectType');
                if (curTypeOptions.length) {
                    typeOptions = [...typeOptions, ...curTypeOptions];
                }
                if (typeOptions.length) {
                    let localType = this.getTypeDescriptor(curType).label;
                    if (optionsByType[localType]) {
                        optionsByType[localType] = [...optionsByType[localType], ...typeOptions];
                    } else {
                        optionsByType[localType] = typeOptions;
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

    getOptionLines(objectArray, labelField, valueField, typeField, isCollectionField, objectTypeField) {
        let typeOptions = [];
        objectArray.forEach(curObject => {
            let curDataType = curObject[typeField] ? curObject[typeField] : 'String';
            typeOptions.push({
                type: curDataType,
                label: curObject[labelField] ? curObject[labelField] : curObject[valueField],
                value: curObject[valueField],
                isCollection: !!curObject[isCollectionField],
                objectType: curObject[objectTypeField],
                optionIcon: this.getIconNameByType(curDataType),
                isSObject: curDataType === 'SObject',
                displayType: curDataType === 'SObject' ? curObject[objectTypeField] : curDataType,
                key: 'flowCombobox-' + this.key++
            });
        });
        return typeOptions;
    }

    handleOpenObject(event) {
console.log('handleOpenObject', event.data);       
        event.stopPropagation();
        this._selectedFieldPath = (this._selectedFieldPath ? this._selectedFieldPath + '.' : '') + event.currentTarget.dataset.optionValue;
        this.value = this._selectedFieldPath + '.';
        this._selectedObjectType = event.currentTarget.dataset.objectType;
        flashElement(this, '.custom-selected-field-path', 'custom-blue-flash', 2, 400);

    }

    handleSetSelectedRecord(event) {
        if (event.currentTarget.dataset) {
            this._dataType = this.settings.referenceDataType;
            this.displayType = event.currentTarget.dataset.displayType;
            this.isSObject = event.currentTarget.dataset.isSObject;
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
                newValueDataType: this._dataType,
                displayType: this.displayType,
                isSObject: this.isSObject
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
        if (this.mode === this.labels.cpeMode) {
            this._selectedObjectType = null;
        } else {
            this._selectedObjectType = this.originalObjectName;
        }

        this._dataType = this.settings.stringDataType;
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
            if (this._value.endsWith('.')) {
                this.hasError = true;
            }
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
        console.log(Date.now());
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
        this.allOptions.forEach(curOption => {
            let localOptions = curOption.options;

            if (this.flowContextFilterType) {
                localOptions = localOptions.filter(opToFilter => opToFilter.displayType === this.flowContextFilterType || (opToFilter.type === 'SObject' && !this.flowContextFilterCollectionBoolean));
            }

            if (typeof this.flowContextFilterCollectionBoolean !== "undefined") {
                localOptions = localOptions.filter(opToFilter => opToFilter.isCollection === this.flowContextFilterCollectionBoolean);
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

    getIconNameByType(variableType) {
        return iconsPerType[variableType];
    }

    handleOpenOptions(event) {
        // event.stopPropagation();
        console.log('handleOpenOptions');
        this.selfEvent = true;
        if (this.isMenuOpen && this.mode === this.labels.cpeMode) {
            this.isDataSelected = false;
            this._value = this.formattedValue(this._value);
        } else {
            this.openOptionDialog();
        }

    }

    get isCPEMode() {
        return this.mode === this.labels.cpeMode;
    }

    handleOpenEditDialog(event) {
console.log('handleOpenEditDialog', event.data);         
        event.stopPropagation();
        this.handleOpenOptions(event);
    }

    handleCloseOptions(event) {
        this.closeOptionDialog();
    }

    handleSearchField(event) {
        let currentText = event.target.value;
        if (this.isReference(currentText)) {
            this._dataType = this.settings.referenceDataType;
        } else {
            this._dataType = this.settings.stringDataType;
        }
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
            let isReference = this.isReference(valueInput.value);
            this._value = this.removeFormatting(valueInput.value);
            if (isReference) {
                let typeOption = this.getTypeOption(this._value);
                if (!typeOption) {
                    this.hasError = true;
                }
                this._dataType = this.settings.referenceDataType;
            } else {
                this._dataType = this.settings.stringDataType;
            }
        }
    }

    isReference(value) {
        let isReference = value.indexOf('{!') === 0 && value.lastIndexOf('}') === (value.length - 1);
        return isReference;
    }

    getFullPath(path, val) {
        return (path ? path + '.' : '') + val;
    }

    formattedValue(value) {
        if (this.isReference(value)) {
            return value;
        } else {
            return this._dataType === this.settings.referenceDataType ? '{!' + value + '}' : value;
        }
    }

    removeFormatting(value) {
        let isReference = this.isReference(value);
        let clearValue = isReference ? value.substring(0, value.lastIndexOf('}')).replace('{!', '') : value;
        return clearValue;
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
}