import {LightningElement, wire, api, track} from 'lwc';
import {getObjectInfo} from 'lightning/uiObjectInfoApi';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import {
    formattedValue,
    isReference,
    getDataType,
    removeFormatting,
    flowComboboxDefaults
} from 'c/fsc_flowComboboxUtils';
import getObjectFields from '@salesforce/apex/usf3.FieldSelectorController.getObjectFields';

const OUTPUTS_FROM_LABEL = 'Outputs from '; 
export default class FlowCombobox extends LightningElement {
    @api name;
    @api label;
    @api required = false;
    @api builderContextFilterType;
    @api builderContextFilterCollectionBoolean;
    @api maxWidth;
    @api autocomplete = 'off';
    @api fieldLevelHelp;
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
    @track _RecordObject; // Used when a start element is in the flow
    @track hasError = false;
    isMenuOpen = false;
    isDataModified = false;
    selfEvent = false;
    key = 0;
    _builderContext;
    _automaticOutputVariables;
    labels = {
        noDataAvailable: 'No matching mergefields or variables are available ',
        staticOptionsLabel: 'OBJECT FIELDS',
        invalidReferenceError: 'This Flow doesn\'t have a defined resource with that name. If you\'re trying to enter a literal value, don\'t use {!}',
    };
    iconsPerType = {
        String: 'utility:text',
        string: 'utility:text',
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
        reference: 'utility:merge_field',
        actionCalls : 'utility:fallback',
        screenComponent : 'utility:fallback',
        Apex : 'utility:apex',
        int : 'utility:text',
        boolean : 'utility:crossfilter'

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
        {apiName: 'screens.fields', label: 'Screen Components', dataType: flowComboboxDefaults.screenComponentType},
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
        {
            apiName: flowComboboxDefaults.recordCreatesType,
            label: 'Variables',
            dataType: 'SObject',
            objectTypeField: 'object',
            isCollectionField: 'getFirstRecordOnly'
        },
        {
            apiName: flowComboboxDefaults.recordUpdatesType,
            label: 'Variables',
            dataType: 'SObject',
            objectTypeField: 'object',
            isCollectionField: 'getFirstRecordOnly'
        },
        {apiName: 'formulas', label: 'Formulas', dataType: flowComboboxDefaults.stringDataType},
        {apiName: 'actionCalls', label: 'ACTIONS', dataType: flowComboboxDefaults.actionType}, //fallback
        // {apiName: 'actionCalls.outputParameters', label: 'Variables', dataType: flowComboboxDefaults.stringDataType},
        // {apiName: 'apexPluginCalls', label: 'Variables', dataType: flowComboboxDefaults.stringDataType},
        {apiName: 'globalVariables', label: 'Global Variables', dataType: flowComboboxDefaults.stringDataType}, // Not within Flow Metadata API but compiled to allow Global Variables to be used
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
        this._mergeFields = this.adjustOptions(this._mergeFields);
        if (!this._selectedObjectType) {
            this.setOptions(this._mergeFields);
            this.determineSelectedType();
        }
    }

    @api get automaticOutputVariables () {
        return this._automaticOutputVariables;
    }

    set automaticOutputVariables(value) {
        // console.log('setting automaticOutputVariables to ' + JSON.stringify(value));
        this._automaticOutputVariables = value;
    }

    get displayPill() {
        return this.isDataSelected && this._dataType === flowComboboxDefaults.referenceDataType;
    }

    setOptions(value) {
        this._options = value;
        this.allOptions = JSON.parse(JSON.stringify(this._options));
        this.processOptions();
    }

    adjustOptions(mergeFields) {
        let sObjectSingleList = [];
        let sObjectCollectionList = []
        mergeFields.forEach(
            optionList => {
                    for(let i = 0; i < optionList.options.length; i++) {
                        if(optionList.options[i].isObject) {
                            if(optionList.options[i].isCollection) {
                                sObjectCollectionList.push(optionList.options[i]);
                            } else {
                                sObjectSingleList.push(optionList.options[i]);
                            }
                            optionList.options.splice(i, 1);
                            i--;
                        }
                    }
                
            }
        );

        mergeFields.push(
            {
                type : 'RECORD (COLLECTION) VARIABLES ',
                options : sObjectCollectionList
            }
        );

        mergeFields.push(
            {
                type : 'RECORD (SINGLE) VARIABLES ',
                options : sObjectSingleList
            }
        );

        return mergeFields;
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
                    if (selectedOption && selectedOption.isObject) {
                        this._selectedObjectType = selectedOption.displayType;
                        valParts.pop();
                        this._selectedFieldPath = valParts.join('.');
                    }
                });
            }
        }
    }

    generateMergeFieldsFromBuilderContext(builderContext) {
        // console.log('generateMergeFieldsFromBuilderContext: ', JSON.stringify(builderContext));
        let optionsByType = {};
        let key = 0;

        this.getTypes().forEach(curType => {
            let typeParts = curType.split('.'); // e.g. 'screen.fields'
            let typeOptions = [];

            // Does builderContext have a "start" property
            // If so we need to parse the "object" value
            if (builderContext?.start) {
                this._RecordObject = builderContext.start.object;
            }


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
                                    // console.log('curObjToExam: ', JSON.stringify(curObjToExam));
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
                    localType.isCollectionField ? localType.isCollectionField : flowComboboxDefaults.isCollectionField,
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

        // Add Global Variables
        let globalVariables = {
            "globalVariables":[
            {
                type: 'String',
                label: '$Flow',
                value: '$Flow',      
                isCollection: false,
                objectType: 'objectType',
                optionIcon: "utility:system_and_global_variable",
                isObject: false,
                globalVariable: true,
                displayType: "String",
                key: flowComboboxDefaults.defaultGlobalVariableKeyPrefix + key++,
                flowType: "reference",
                storeOutputAutomatically: false
            },
            {
                type: 'String',
                label: '$User',
                value: '$User',      
                isCollection: false,
                objectType: 'objectType',
                optionIcon: "utility:system_and_global_variable",
                isObject: false,
                globalVariable: true,
                displayType: "String",
                key: flowComboboxDefaults.defaultGlobalVariableKeyPrefix + key++,
                flowType: "reference",
                storeOutputAutomatically: false
            },
            {
                type: 'String',
                label: '$UserRole',
                value: '$UserRole',      
                isCollection: false,
                objectType: 'objectType',
                optionIcon: "utility:system_and_global_variable",
                isObject: false,
                globalVariable: true,
                displayType: "String",
                key: flowComboboxDefaults.defaultGlobalVariableKeyPrefix + key++,
                flowType: "reference",
                storeOutputAutomatically: false
            },
            {
                type: 'String',
                label: '$Profile',
                value: '$Profile',      
                isCollection: false,
                objectType: 'objectType',
                optionIcon: "utility:system_and_global_variable",
                isObject: false,
                globalVariable: true,
                displayType: "String",
                key: flowComboboxDefaults.defaultGlobalVariableKeyPrefix + key++,
                flowType: "reference",
                storeOutputAutomatically: false
            },
            {
                type: 'String',
                label: '$System',
                value: '$System',  
                isCollection: false,
                objectType: 'objectType',
                optionIcon: "utility:system_and_global_variable",
                isObject: false,
                globalVariable: true,
                displayType: "String",
                key: flowComboboxDefaults.defaultGlobalVariableKeyPrefix + key++,
                flowType: "reference",
                storeOutputAutomatically: false
            }
        ]};

        // If _RecordObject is defined, add it to the global variables
        if (this._RecordObject) {
            globalVariables.globalVariables.push(
                {
                    type: 'String',
                    label: '$Record',
                    value: '$Record',
                    isCollection: false,
                    objectType: 'objectType',
                    optionIcon: "utility:system_and_global_variable",
                    isObject: false,
                    globalVariable: true,
                    displayType: "String",
                    key: flowComboboxDefaults.defaultGlobalVariableKeyPrefix + key++,
                    flowType: "reference",
                    storeOutputAutomatically: false
                },                
                {
                    type: 'String',
                    label: '$Record__Prior',
                    value: '$Record__Prior',
                    isCollection: false,
                    objectType: 'objectType',
                    optionIcon: "utility:system_and_global_variable",
                    isObject: false,
                    globalVariable: true,
                    displayType: "String",
                    key: flowComboboxDefaults.defaultGlobalVariableKeyPrefix + key++,
                    flowType: "reference",
                    storeOutputAutomatically: false
                }
            );
        }

        // Add globalFlowVariablev object to optionsByType object
        let globalVariablesType = this.getTypeDescriptor('globalVariables').label;
        if (optionsByType[globalVariablesType]) {
            optionsByType[globalVariablesType] = [...optionsByType[globalVariablesType], ...globalVariables.globalVariables];
        } else {
            optionsByType[globalVariablesType] = globalVariables.globalVariables;
        }
        // console.log('optionsByType', optionsByType)

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
        // console.log('getOptionLines', JSON.stringify(objectArray), labelField, valueField, typeField, isCollectionField, objectTypeField, typeDescriptor);
        let typeOptions = [];
        objectArray.forEach(curObject => {
            let isActionCall = (typeDescriptor.apiName === flowComboboxDefaults.actionType);
            let isScreenComponent = (typeDescriptor.dataType === flowComboboxDefaults.screenComponentType) && curObject.storeOutputAutomatically;
            let curDataType = (isActionCall) ? flowComboboxDefaults.actionType :  isScreenComponent ? flowComboboxDefaults.screenComponentType : this.getTypeByDescriptor(curObject[typeField], typeDescriptor);
            let label = isActionCall ?  OUTPUTS_FROM_LABEL + curObject['name'] : curObject[labelField] ? curObject[labelField] : curObject[valueField];
            let curIsCollection = this.isCollection(curObject, isCollectionField);
            typeOptions.push(this.generateOptionLine(
                curDataType,
                label,//curObject[labelField] ? curObject[labelField] : curObject[valueField],
                typeDescriptor.dataType === flowComboboxDefaults.screenComponentType ? curObject[valueField].split('.')[1] : curObject[valueField], // For the split "Child_Case_Creation_Form.Text_Area" would be "Text_Area" only for screen components
                typeDescriptor.apiName === flowComboboxDefaults.recordLookupsType ? !curIsCollection : !!curIsCollection,
                curObject[objectTypeField],
                this.getIconNameByType(curDataType),
                (curDataType === flowComboboxDefaults.dataTypeSObject || typeDescriptor.apiName === flowComboboxDefaults.recordLookupsType),
                curDataType === flowComboboxDefaults.dataTypeSObject ? curObject[objectTypeField] : curDataType,
                flowComboboxDefaults.defaultKeyPrefix + this.key++,
                null,
                curObject.storeOutputAutomatically && typeDescriptor.dataType !== 'SObject'
            ));
        });
        return typeOptions;
    }

    isCollection(curObject, isCollectionField) {
        if (curObject.hasOwnProperty(isCollectionField)) {
            return curObject[isCollectionField];
        } else {
            return curObject[flowComboboxDefaults.isCollectionField];
        }
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

    generateOptionLine(type, label, value, isCollection, objectType, optionIcon, isObject, displayType, key, flowType, storeOutputAutomatically) {
        return {
            type: type,
            label: label,
            value: value,
            isCollection: isCollection,
            objectType: objectType,
            optionIcon: optionIcon,
            isObject: isObject,
            globalVariable: false,
            displayType: displayType,
            key: key,
            flowType: flowType ? flowType : flowComboboxDefaults.referenceDataType,
            storeOutputAutomatically : storeOutputAutomatically
        };
    }

    handleOpenObject(event) {
        this.doOpenObject(event, event.currentTarget.dataset.optionValue, event.currentTarget.dataset.objectType);
    }


    handleOpenScreenComponent(event) {
        let screenComponentName = event.currentTarget.dataset.optionValue.split('.');
        this.doOpenAction(event, screenComponentName.length > 1 ? screenComponentName[1] : event.currentTarget.dataset.optionValue);
    }

    handleSetSelectedRecord(event) {
        if (event.currentTarget.dataset) {
            if (this.value && this.value.endsWith(event.currentTarget.dataset.value) && event.currentTarget.dataset.objectType) {
                this.doOpenObject(event, event.currentTarget.dataset.value, event.currentTarget.dataset.objectType);
            } else {
                this._dataType = event.currentTarget.dataset.flowType;
                this.value = this.getFullPath(this._selectedFieldPath, event.currentTarget.dataset.value);
                this.isDataModified = true;
                this.hasError = false;
                this.closeOptionDialog();
            }
        }
    }

    handleOpenGlobalVariable(event) {
        // console.log('handleOpenGlobalVariable', JSON.stringify(event.currentTarget.dataset));
        this.doOpenGlobalVariable(event, event.currentTarget.dataset.optionValue);
    }

    doOpenGlobalVariable(event, value) {
        event.stopPropagation();
        // console.log('doOpenGlobalVariable', value);
        let tempOptions = [];
        let objectName = '';

        // Switch Statement to handle different types of global variables
        switch (value) {
            case '$Flow':
                tempOptions.push(
                    {
                        type: 'String',
                        label: '$Flow.ActiveStages',
                        value: '$Flow.ActiveStages',      
                        isCollection: false,
                        objectType: 'objectType',
                        optionIcon: "utility:system_and_global_variable",
                        isObject: false,
                        globalVariable: false,
                        displayType: "String",
                        key: flowComboboxDefaults.defaultGlobalVariableKeyPrefix + this.key++,
                        flowType: "reference",
                        storeOutputAutomatically: false
                    },
                    {
                        type: 'String', 
                        label: '$Flow.CurrentStage',
                        value: '$Flow.CurrentStage',
                        isCollection: false,
                        objectType: 'objectType',
                        optionIcon: "utility:system_and_global_variable",
                        isObject: false,
                        globalVariable: false,
                        displayType: "String",
                        key: flowComboboxDefaults.defaultGlobalVariableKeyPrefix + this.key++,
                        flowType: "reference",
                        storeOutputAutomatically: false
                    },
                    {
                        type: 'Date',
                        label: '$Flow.CurrentDate',
                        value: '$Flow.CurrentDate',      
                        isCollection: false,
                        objectType: 'objectType',
                        optionIcon: "utility:system_and_global_variable",
                        isObject: false,
                        globalVariable: false,
                        displayType: "Date",
                        key: flowComboboxDefaults.defaultGlobalVariableKeyPrefix + this.key++,
                        flowType: "reference",
                        storeOutputAutomatically: false
                    },
                    {
                        type: 'DateTime',
                        label: '$Flow.CurrentDateTime',
                        value: '$Flow.CurrentDateTime',      
                        isCollection: false,
                        objectType: 'objectType',
                        optionIcon: "utility:system_and_global_variable",
                        isObject: false,
                        globalVariable: false,
                        displayType: "DateTime",
                        key: flowComboboxDefaults.defaultGlobalVariableKeyPrefix + this.key++,
                        flowType: "reference",
                        storeOutputAutomatically: false
                    },
                    {
                        type: 'String',
                        label: '$Flow.CurrentRecord',
                        value: '$Flow.CurrentRecord',      
                        isCollection: false,
                        objectType: 'objectType',
                        optionIcon: "utility:system_and_global_variable",
                        isObject: false,
                        globalVariable: false,
                        displayType: "String",
                        key: flowComboboxDefaults.defaultGlobalVariableKeyPrefix + this.key++,
                        flowType: "reference",
                        storeOutputAutomatically: false
                    },
                    {
                        type: 'String',
                        label: '$Flow.FaultMessage',
                        value: '$Flow.FaultMessage',      
                        isCollection: false,
                        objectType: 'objectType',
                        optionIcon: "utility:system_and_global_variable",
                        isObject: false,
                        globalVariable: false,
                        displayType: "String",
                        key: flowComboboxDefaults.defaultGlobalVariableKeyPrefix + this.key++,
                        flowType: "reference",
                        storeOutputAutomatically: false
                    },
                    {
                        type: 'String',
                        label: '$Flow.InterviewGuid',
                        value: '$Flow.InterviewGuid',      
                        isCollection: false,
                        objectType: 'objectType',
                        optionIcon: "utility:system_and_global_variable",
                        isObject: false,
                        globalVariable: false,
                        displayType: "String",
                        key: flowComboboxDefaults.defaultGlobalVariableKeyPrefix + this.key++,
                        flowType: "reference",
                        storeOutputAutomatically: false
                    },
                    {
                        type: 'Time',
                        label: '$Flow.InterviewStartTime',
                        value: '$Flow.InterviewStartTime',      
                        isCollection: false,
                        objectType: 'objectType',
                        optionIcon: "utility:system_and_global_variable",
                        isObject: false,
                        globalVariable: false,
                        displayType: "Time",
                        key: flowComboboxDefaults.defaultGlobalVariableKeyPrefix + this.key++,
                        flowType: "reference",
                        storeOutputAutomatically: false
                    }
                )
            break;
            case '$User':
                // Get Fields from User
                objectName = 'User';
                getObjectFields({objectName: objectName})
                .then(result => {
                    // console.log('result', result);
                    let fields = this.shallowCloneArray(result);
                    fields.forEach(field => {
                        tempOptions.push({
                            type: field.type,
                            label: field.label,
                            value: field.name,
                            isCollection: false,
                            objectType: 'objectType',
                            optionIcon: "utility:system_and_global_variable",
                            isObject: false,
                            globalVariable: false,
                            displayType: "String",
                            key: flowComboboxDefaults.defaultGlobalVariableKeyPrefix + this.key++,
                            flowType: 'refrence',
                            storeOutputAutomatically: false
                        });
                    });
                    // Set the Options
                    this.setOptions([{type: value + ' Outputs', options: tempOptions}]);
                })
                break;
            case '$System':
                // Get Fields from System
                tempOptions.push(
                    {
                        type: 'String',
                        label: '$System.OriginDateTime',
                        value: '$System.OriginDateTime',
                        isCollection: false,
                        objectType: 'objectType',
                        optionIcon: "utility:system_and_global_variable",
                        isObject: false,
                        globalVariable: false,
                        displayType: "String",
                        key: flowComboboxDefaults.defaultGlobalVariableKeyPrefix + this.key++,
                        flowType: "reference",
                        storeOutputAutomatically: false
                    }
                );
                break;
            case '$Profile':
                // Get Fields from Profile
                objectName = 'Profile';
                getObjectFields({objectName: objectName})
                .then(result => {
                    // console.log('result', result);
                    let fields = this.shallowCloneArray(result);
                    fields.forEach(field => {
                        tempOptions.push({
                            type: field.type,
                            label: field.label,
                            value: field.name,
                            isCollection: false,
                            objectType: 'objectType',
                            optionIcon: "utility:system_and_global_variable",
                            isObject: false,
                            globalVariable: false,
                            displayType: "String",
                            key: flowComboboxDefaults.defaultGlobalVariableKeyPrefix + this.key++,
                            flowType: 'refrence',
                            storeOutputAutomatically: false
                        });
                    });
                    // Set the Options
                    this.setOptions([{type: value + ' Outputs', options: tempOptions}]);
                })
                break;
            case '$UserRole':
                // Get Fields from UserRole
                objectName = 'UserRole';
                getObjectFields({objectName: objectName})
                .then(result => {
                    // console.log('result', result);
                    let fields = this.shallowCloneArray(result);
                    fields.forEach(field => {
                        tempOptions.push({
                            type: field.type,
                            label: field.label,
                            value: field.name,
                            isCollection: false,
                            objectType: 'objectType',
                            optionIcon: "utility:system_and_global_variable",
                            isObject: false,
                            globalVariable: false,
                            displayType: "String",
                            key: flowComboboxDefaults.defaultGlobalVariableKeyPrefix + this.key++,
                            flowType: 'refrence',
                            storeOutputAutomatically: false
                        });
                    });
                    // Set the Options
                    this.setOptions([{type: value + ' Outputs', options: tempOptions}]);
                })
                break;
            case '$Record':
                // Get Fields from Record
                objectName = this._RecordObject;
                getObjectFields({objectName: objectName})
                .then(result => {
                    // console.log('result', result);
                    let fields = this.shallowCloneArray(result);
                    fields.forEach(field => {
                        tempOptions.push({
                            type: field.type,
                            label: field.label,
                            value: field.name,
                            isCollection: false,
                            objectType: 'objectType',
                            optionIcon: "utility:system_and_global_variable",
                            isObject: false,
                            globalVariable: false,
                            displayType: "String",
                            key: flowComboboxDefaults.defaultGlobalVariableKeyPrefix + this.key++,
                            flowType: 'refrence',
                            storeOutputAutomatically: false
                        });
                    });
                    // Set the Options
                    this.setOptions([{type: value + ' Outputs', options: tempOptions}]);
                })                
                break;
            case '$Record__Prior':
                    // Get Fields from Record
                    objectName = this._RecordObject;
                    getObjectFields({objectName: objectName})
                    .then(result => {
                        // console.log('result', result);
                        let fields = this.shallowCloneArray(result);
                        fields.forEach(field => {
                            tempOptions.push({
                                type: field.type,
                                label: field.label,
                                value: field.name,
                                isCollection: false,
                                objectType: 'objectType',
                                optionIcon: "utility:system_and_global_variable",
                                isObject: false,
                                globalVariable: false,
                                displayType: "String",
                                key: flowComboboxDefaults.defaultGlobalVariableKeyPrefix + this.key++,
                                flowType: 'refrence',
                                storeOutputAutomatically: false
                            });
                        });
                        // Set the Options
                        this.setOptions([{type: value + ' Outputs', options: tempOptions}]);
                    })                
                    break;

            default:
                return null;
        }

        // Set the Options
        this.setOptions([{type: value + ' Outputs', options: tempOptions}]);

    }

    doOpenObject(event, value, objectType) {
        event.stopPropagation();
        this._selectedFieldPath = (this._selectedFieldPath ? this._selectedFieldPath + '.' : '') + value;
        this.value = this._selectedFieldPath + '.';
        this._selectedObjectType = objectType;
    }

    doOpenAction(event, value) {
        event.stopPropagation();
        this._selectedFieldPath = (this._selectedFieldPath ? this._selectedFieldPath + '.' : '') + value;
        this.value = this._selectedFieldPath + '.';
        this.getActionOutputs(value);
    }

    getActionOutputs(actionName) {
        let tempOptions = [];
        this.automaticOutputVariables[actionName].forEach(
            output => {

                        let curObjectType = output.sobjectType ? output.sobjectType : output.subtype;
                        let curDataType  = output.dataType === 'sobject' ? 'SObject' : output.dataType;
                        tempOptions.push(this.generateOptionLine(
                            output.dataType,
                            output.label? output.label : output.apiName,
                            output.apiName ? output.apiName : output.name,
                            output.maxOccurs > 1,
                            curObjectType,
                            this.getIconNameByType(curDataType),
                            curDataType === 'SObject',
                            curDataType === 'SObject' ? curObjectType : curDataType,
                            flowComboboxDefaults.defaultKeyPrefix + this.key++
                        ));
                    }
        );
        this.setOptions([{type: actionName + ' Outputs', options: tempOptions}]);
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

    connectedCallback() {
        document.addEventListener('click', this.handleWindowClick.bind(this));
        document.addEventListener('blur', this.handleInputFocus.bind(this));
    }

    disconnectedCallback() {
        document.removeEventListener('click', this.handleWindowClick.bind(this));
    }

    handleWindowClick(event) {
        if (event.path){
            console.log('you are apparently using chrome, and can use event.path');
            if (!event.path.includes(this.template.host) && !this.selfEvent) {
                this.closeOptionDialog(true);
            }
        
        } else {
            console.log('you are apparently not using chrome, so we can\'t test using event.path');
            if (!this.selfEvent) {
                this.closeOptionDialog(true);
            }
        }

        this.selfEvent = false;
    }

    processOptions(searchString) {
        let searchLC = '';
        let allowBack = false;

        if (searchString) {
            let searchParts = searchString.split('.');
            searchLC = searchParts[searchParts.length - 1].toLowerCase();
        }

        this._options = [];
        if (this.allOptions && this.allOptions.length) {
            this.allOptions.forEach(curOption => {
                let localOptions = curOption.options;

                if (this.builderContextFilterType) {
                    localOptions = localOptions.filter(opToFilter => opToFilter.displayType?.toLowerCase() === this.builderContextFilterType.toLowerCase() || opToFilter.storeOutputAutomatically === true || (  opToFilter.type === 'SObject' && !this.builderContextFilterCollectionBoolean));
                }

                if (typeof this.builderContextFilterCollectionBoolean !== "undefined") {
                    localOptions = localOptions.filter(opToFilter =>  {
                        return((opToFilter.isCollection === this.builderContextFilterCollectionBoolean) 
                            || (opToFilter.storeOutputAutomatically === true))}

                    ) ;
                }

                if (searchLC) {
                    localOptions = localOptions.filter(opToFilter => opToFilter.label.toLowerCase().includes(searchLC) || opToFilter.value.toLowerCase().includes(searchLC.replace(/\W/g, '')));
                }

                if (localOptions.length) {
                    this._options.push({
                        ...curOption, ...{
                            options: localOptions
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
                            flowComboboxDefaults.stringDataType//,
                            //curOption.type === "ACTIONS" ? true : false
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
        if (event.target) {
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
    }

    handleSearchKeyUp(event) {
        if (event.key === "Enter" || event.key === "Tab") {
            this.toggleMenu(event);
        }
    }

    toggleMenu(event) {
        if (this.isMenuOpen) {
            this.closeOptionDialog(true);
        } else {
            this.openOptionDialog();
        }
    }

    handleKeyDown(event) {
        if (this.isMenuOpen && (event.key === "Tab" || event.key === 'Escape')) {
            this.closeOptionDialog(true);
            if (event.key === 'Escape') {
                event.stopPropagation();
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

            // checkValidity on valueInput
            if ( !valueInput.checkValidity() ) {
                this.hasError = true;
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
            resultClass += ' slds-has-error slds-m-bottom_medium';
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

    handleInputFocus(event) {
        if (this._value) {
            this.isDataSelected = true;
        }
        //this.isMenuOpen = false;
        //this.dropdownClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';

        
        this.setValueInput();

        if (this.isDataModified) {
            this.dispatchValueChangedEvent();
            this.isDataModified = false;
        }
    }

    shallowCloneArray(arrayToClone) {
        if (!Array.isArray(arrayToClone))
            return null;

        let newArray = [];
        for (let el of arrayToClone) {
            newArray.push(Object.assign({}, el));
        }
        return newArray;
    }

}