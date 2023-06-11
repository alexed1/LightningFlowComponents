import {LightningElement, api, track} from 'lwc';

const DATA_TYPE = {
    STRING: 'String',
    BOOLEAN: 'Boolean',
    NUMBER: 'Number',
    INTEGER: 'Integer'
};

const FLOW_EVENT_TYPE = {
    DELETE: 'configuration_editor_input_value_deleted',
    CHANGE: 'configuration_editor_input_value_changed',
    DYNAMIC_MAPPING: 'configuration_editor_generic_type_mapping_changed'
}

const VALIDATEABLE_INPUTS = ['objectName', 'fieldsToDisplay'];


export default class Mc_lookupCPE extends LightningElement {
    _builderContext = {};
    _values = [];
    _typeMappings = [];
    _query = '';
    _elementType;
    _elementName; 
    _typeValue;

    @api
    get elementInfo() {
        return this._elementInfo;
    }

    set elementInfo(info) {
        this._elementInfo = info || {};
        if (this._elementInfo) {
            this._elementName = this._elementInfo.apiName;
            this._elementType = this._elementInfo.type;
        }
    }

    @api get genericTypeMappings() {
        return this._genericTypeMappings;
    }
    set genericTypeMappings(value) {
        this._typeMappings = value;
        this.initializeTypeMappings();
    }

    initializeTypeMappings() {
        this._typeMappings.forEach((typeMapping) => {
            // console.log(JSON.stringify(typeMapping));
            if (typeMapping.name && typeMapping.value) {
                this._typeValue = typeMapping.value;
            }
        });
    }

    showChildInputs = false;
    isMultiSelect = false;
    isFlowLoaded = false;

    // Variables to show/hide radio buttons to show flow combo box
    showFlowResource_Required = false;
    showFlowResource_NewRecord = false;
    showFlowResource_Multi = false;

    // Function to show/hide radio buttons to show flow combo box
    showFlowResourceHandlerRequired(event) {
        this.showFlowResource_Required = !(this.showFlowResource_Required);
    }
    showFlowResourceHandlerNewRecord(event) {
        this.showFlowResource_NewRecord = !(this.showFlowResource_NewRecord);
    }
    showFlowResourceHandlerMulti(event) {
        this.showFlowResource_Multi = !(this.showFlowResource_Multi);
    }

    convertFlowConstantsToBoolean(value) {
        if (value === '$GlobalConstant.True') {
            return true;
        } else if (value === '$GlobalConstant.False') {
            return false;
        } else {
            return value;
        }
    }

    convertBooleanToFlowConstants(value) {
        if (value === true) {
            return '$GlobalConstant.True';
        } else if (value === false) {
            return '$GlobalConstant.False';
        } else {
            return value;
        }
    }

    convertValueToType(value) {
        // Value starts with $GlobalConstant
        // Type is Boolean
        // if typeOf is string
        if (typeof value === 'string') {
            if (value.startsWith('$GlobalConstant')) {
                return DATA_TYPE.BOOLEAN;
            }
        } else {
            return DATA_TYPE.STRING;
        }
    }


    // This function will allow the user to access the flow-combobox and select a flow resource
    // Otherwise the user will use the SOQL Builder to select the fields to display and where clause
    @track showAdvanceConfiguration = false;
    showAdvanceConfigurationHandler(event) {
        console.log('showAdvanceConfigurationHandler', JSON.stringify(event.detail));
        // If SOQL Query is selected, false
        // If Flow Resources is selected, true
        if (event.detail.value === 'SOQL Query') {
            this.showAdvanceConfiguration = false;
        } else {
            this.showAdvanceConfiguration = true;
        }
    }

    //don't forget to credit https://www.salesforcepoint.com/2020/07/LWC-modal-popup-example-code.html
    @track openModal = false;

    showModal() {
        this.openModal = true;
    }

    closeModal() {
        this.openModal = false;
    }

    @api get automaticOutputVariables() {
        return this._automaticOutputVariables;
    };
    
    set automaticOutputVariables(value) {
        this._automaticOutputVariables = value;
    }
    @track _automaticOutputVariables;

    @track inputValues = {
        objectName: {value: null, valueDataType: null, isCollection: false, label: 'Lookup which Object?', required: true, errorMessage: 'Please select an object'},
        label: {value: 'Select Record', valueDataType: null, isCollection: false, label: 'Label'},
        fieldsToDisplay: {value: null, valueDataType: null, isCollection: true, label: 'Fields to Display', serialized: true, required: true, errorMessage: 'Please select at least one field to display'},
        fieldsToSearch: {value: null, valueDataType: null, isCollection: true, label: 'Fields to Search', serialized: true},
        whereClause: {value: null, valueDataType: null, isCollection: false, label: 'Filter Criteria'},
        defaultValueInput: {value: null, valueDataType: null, isCollection: false, label: 'Default Value'},
        required: {value: false, flowValue: '$GlobalConstant.False' ,valueDataType: DATA_TYPE.BOOLEAN, isCollection: false, label: 'Required'},
        messageWhenValueMissing: {value: 'Please select a record', valueDataType: null, isCollection: false, label: 'Message When Value Missing'},
        showNewRecordAction: {value: false, flowValue: '$GlobalConstant.False' ,valueDataType: DATA_TYPE.BOOLEAN, isCollection: false, label: 'New Record Action'},
        leftIconName: {value: 'utility:search', valueDataType: null, isCollection: false, label: 'Left Icon Name'},
        rightIconName: {value: 'utility:down', valueDataType: null, isCollection: false, label: 'Right Icon Name'},
        allowMultiselect: {value: false, flowValue: '$GlobalConstant.False' ,valueDataType: DATA_TYPE.BOOLEAN, isCollection: false, label: 'Selection Mode'},
        fieldLevelHelp: {value: null, valueDataType: null, isCollection: false, label: 'Field Level Help'},
        noMatchString: {value: 'Nothing Found', valueDataType: null, isCollection: false, label: 'Error Text - Nothing Found'},
        placeholder: {value: null, valueDataType: null, isCollection: false, label: 'Placeholder'},
        disabled: {value: false, flowValue: '$GlobalConstant.False' ,valueDataType: DATA_TYPE.BOOLEAN, isCollection: false, label: 'Disabled'},
        minimumNumberOfSelectedRecords: {value: null, valueDataType: null, isCollection: false, label: 'Minimum'},
        maximumNumberOfSelectedRecords: {value: null, valueDataType: null, isCollection: false, label: 'Maximum'},
        minimumNumberOfSelectedRecordsMessage: {value: 'Please select at least {0} records', valueDataType: null, isCollection: false, label: 'Minimum'},
        maximumNumberOfSelectedRecordsMessage: {value: 'Please select no more than {0} records', valueDataType: null, isCollection: false, label: 'Maximum'},
        dataSource: {value: 'SOQL Query', valueDataType: null, isCollection: false, label: 'Data Source'},
    }

    @api get builderContext() {
        return this._builderContext;
    }

    set builderContext(value) {
        this._builderContext = value;
    }

    @api get inputVariables() {
        return this._values;
    }

    set inputVariables(value) {
        this._values = value;
        this.initializeValues();
    }

    get objectTypes() {
        return [
            {label: 'Standard and Custom', value: ''},
            {label: 'All', value: 'All'},
        ];
    }

    // Data Source Options
    get dataSourceOptions () { 
        return [
            {label: 'SOQL Query', value: 'SOQL Query'},
            {label: 'Flow Resources', value: 'Flow Resources'}
        ];
    }

    // Required Options
    get requiredOptions () {
        return [
            {label: 'True', value: '$GlobalConstant.True'},
            {label: 'False', value: '$GlobalConstant.False'}
        ];
    } 

    // Show New Record Action Options
    get showNewRecordActionOptions  () {
        return [
            {label: 'Show', value: '$GlobalConstant.True'},
            {label: 'Hide', value: '$GlobalConstant.False'}
        ];
    }

    // Allow Multiselect Options
    get allowMultiselectOptions  () {
        return [
            {label: 'Single', value: '$GlobalConstant.False'},
            {label: 'Multiple', value: '$GlobalConstant.True'}
        ];
    }

    handleSoqlQueryChange(event) {
        this._query = event.detail;
    }

    // Using the SOQL Query Builder this function will parse the output
    // and set the fieldsToDisplay and whereClause input values
    setFilterCriteria() {
        console.log('setFilterCriteria');
        // Close Modal
        this.closeModal();

        // Example Output from SOQL Query Builder
        // this._query = SELECT Id, Name FROM Account WHERE Name LIKE '%a%' LIMIT 10;

        // If query is set
        if (this._query) {
            // If query contains LIMIT Remove everything after LIMIT
            if (this._query.includes('LIMIT')) {
                this._query = this._query.substring(0, this._query.indexOf('LIMIT'));
            }

            // If query contains ORDER BY Remove everything after ORDER BY
            if (this._query.includes('ORDER BY')) {
                this._query = this._query.substring(0, this._query.indexOf('ORDER BY'));
            }

            // Everything Between SELECT and FROM is the fields to display
            let fieldsToDisplay = this._query.substring(this._query.indexOf('SELECT') + 6, this._query.indexOf('FROM')).trim();
            console.log('fieldsToDisplay: ' + fieldsToDisplay);
            // Example what fieldsToDisplay should look like
            // {"label":"Account Name","name":"Name","type":"STRING","sublabel":"Name","leftIcon":"utility:text","hidden":false}]
            // Go through each field and add the label, name, type, sublabel, leftIcon, and hidden
            let fields = [];
            let fieldArray = fieldsToDisplay.split(',');
            for (let i = 0; i < fieldArray.length; i++) {
                let field = fieldArray[i].trim();
                let fieldLabel = field;
                let fieldName = field;
                let fieldType = 'STRING';
                let fieldSublabel = field;
                let fieldLeftIcon = 'utility:text';
                let fieldHidden = false;
                fields.push({
                    label: fieldLabel,
                    name: fieldName,
                    type: fieldType,
                    sublabel: fieldSublabel,
                    leftIcon: fieldLeftIcon,
                    hidden: fieldHidden
                });
            }
            console.log('fields: ' + JSON.stringify(fields));
            this.inputValues.fieldsToDisplay.value = fields;
            this.dispatchFlowValueChangeEvent('fieldsToDisplay', fields, DATA_TYPE.STRING);

            // Everything After WHERE is the filter criteria
            // Check if WHERE is in the query
            if (this._query.includes('WHERE')) {
                let whereClause = this._query.substring(this._query.indexOf('WHERE') + 5).trim();
                console.log('whereClause: ' + whereClause);
                this.inputValues.whereClause.value = whereClause;
                this.dispatchFlowValueChangeEvent('whereClause', whereClause, DATA_TYPE.STRING);
            }
        }
    }

    @api validate() {
        console.log('in validate: ' + JSON.stringify(VALIDATEABLE_INPUTS));
        const validity = [];
        VALIDATEABLE_INPUTS.forEach((input) => {
            console.log('in validate: ' + input + ' = ' + this.inputValues[input].value + ' required: ' + this.inputValues[input].required)
            if ( this.inputValues[input].value?.toString().length == 0 && this.inputValues[input].required) {
                console.log('in validate: ' + input + ' is required');
                let cmp = '';
                if(input == 'fieldsToDisplay'){
                    cmp = 'c-fsc_field-selector-3'
                } else if (input == 'objectName'){
                    cmp = 'c-fsc_object-selector-3'
                }
                const allValid = [...this.template.querySelectorAll(cmp)]
                .reduce((validSoFar, inputCmp) => {
                            inputCmp?.reportValidity();
                            return validSoFar;
                }, true);
                validity.push({
                    key: 'Field Required: ' + this.inputValues[input].label,
                    errorString: this.inputValues[input].errorMessage
                });
            }
        });

        return validity;
    }

    // When the component is rendered, initialize the values
    initializeValues(value) {
        console.log('in initializeValues: ' + JSON.stringify(value));
        if (this._values && this._values.length) {
            this._values.forEach(curInputParam => {
                if (curInputParam.name && this.inputValues[curInputParam.name]) {
                    console.log('in initializeValues: '+ JSON.stringify(curInputParam));
                    if (this.inputValues[curInputParam.name].serialized) {
                        this.inputValues[curInputParam.name].value = JSON.parse(curInputParam.value);
                    // If valueDataType is a boolean, then convert the value to a boolean
                    } else if (curInputParam.valueDataType == DATA_TYPE.BOOLEAN) {
                        this.inputValues[curInputParam.name].flowValue = this.convertBooleanToFlowConstants(curInputParam.value);
                        this.inputValues[curInputParam.name].value = this.convertFlowConstantsToBoolean(curInputParam.value);
                    } else {
                        this.inputValues[curInputParam.name].value = curInputParam.value;
                    }
                    this.inputValues[curInputParam.name].valueDataType = curInputParam.valueDataType;
                }

                // If input is allowMultiselect, then set the isMultiSelect flag
                if (curInputParam.name == 'allowMultiselect') {
                    this.isMultiSelect = this.convertFlowConstantsToBoolean(curInputParam.value) ? true : false;
                }

                console.log('in initializeValues: ' + curInputParam.name + ' = ' + curInputParam.value + ' type: ' + curInputParam.valueDataType);
            });
        }
    }

    // Handles all value changes
    handleValueChange(event) {
        console.log('in handleValueChange: ');
        if (event.detail && event.target) {
            // Any component using fsc_flow-combobox will be ran through here
            // This is the newer version and will allow users to use merge fields
            // If event.detail.newValue is set then use it, otherwise use event.detail.value
            let newValue = event.detail.newValue;
            if (newValue == null) {
                newValue = event.detail.value;

                // If event.detail.value.name is set then use it, otherwise use event.detail.value
                if (newValue.name != null) {
                    newValue = newValue.name;
                }
            }

            // If event.target.name is allowMultiselect and value is true then isMultiSelect is true
            // Used to disable/enable max and min fields
            if (event.target.name == 'allowMultiselect') {
                console.log('in handleValueChange: allowMultiselect = ' + (newValue))
                if (this.convertFlowConstantsToBoolean(newValue)) {
                    this.isMultiSelect = true;
                } else {
                    this.isMultiSelect = false;

                    // Set minimumNumberOfSelectedRecords and maximumNumberOfSelectedRecords to 0
                    this.dispatchFlowValueChangeEvent('minimumNumberOfSelectedRecords', 0, DATA_TYPE.INTEGER);
                    this.dispatchFlowValueChangeEvent('maximumNumberOfSelectedRecords', 0, DATA_TYPE.INTEGER);
                }
            }

            console.log('(NEW) in handleValueChange: ' + event.target.name + ' = ' + JSON.stringify(newValue) + ' type: ' + this.convertValueToType(newValue));
            this.dispatchFlowValueChangeEvent(event.target.name, this.convertFlowConstantsToBoolean(newValue), this.convertValueToType(newValue), this.convertBooleanToFlowConstants(newValue));

        } else if ( event.detail && event.currentTarget ) {
            // This is the older version for any old inputs that are still using currentTarget
            // Kept for backwards compatibility
            console.log('(OLD) in handleValueChange: ' + event.currentTarget.name + ' = ' + event.detail);
            let dataType = DATA_TYPE.STRING;
            if (event.currentTarget.type == 'checkbox') dataType = DATA_TYPE.BOOLEAN;
            if (event.currentTarget.type == 'number') dataType = DATA_TYPE.NUMBER;
            if (event.currentTarget.type == 'integer') dataType = DATA_TYPE.INTEGER;
            let newValue = event.currentTarget.type === 'checkbox' ? event.currentTarget.checked : event.detail.value;
            this.dispatchFlowValueChangeEvent(event.currentTarget.name, newValue, dataType);
        } else if (event.currentTarget?.name == 'allowMultiselect'){
            // Special case for allowMultiselect
            if (event.detail.newValue) {
                this.isMultiSelect = true;
            } else {
                this.isMultiSelect = false;

                // Set minimumNumberOfSelectedRecords and maximumNumberOfSelectedRecords to 0
                this.dispatchFlowValueChangeEvent('minimumNumberOfSelectedRecords', 0, DATA_TYPE.INTEGER);
                this.dispatchFlowValueChangeEvent('maximumNumberOfSelectedRecords', 0, DATA_TYPE.INTEGER);
            }
        } else {
            console.log('in handleValueChange: no event detail');
        }
    }

    // Speacial Use Case For Icons as we were not able to dynamically set the icon name
    handleIconChange(event) {
        this.dispatchFlowValueChangeEvent('iconName', event.detail);
    }

    handleLeftIconChange(event) {
        this.dispatchFlowValueChangeEvent('leftIconName', event.detail);
    }

    handleRightIconChange(event) {
        this.dispatchFlowValueChangeEvent('rightIconName', event.detail);
    }

    // This is used to set the value of the input fields
    dispatchFlowValueChangeEvent(id, newValue, dataType = DATA_TYPE.STRING, flowValue = null) {
        console.log('in dispatchFlowValueChangeEvent: ' + id, newValue, dataType, flowValue);
        if (this.inputValues[id] && this.inputValues[id].serialized) {
            console.log('serializing value');
            newValue = JSON.stringify(newValue);
        }
        const valueChangedEvent = new CustomEvent(FLOW_EVENT_TYPE.CHANGE, {
            bubbles: true,
            cancelable: false,
            composed: true,
            detail: {
                name: id,
                newValue: newValue ? newValue : null,
                newValueDataType: dataType,
                flowValue: flowValue ? flowValue : null
            }
        });
        this.dispatchEvent(valueChangedEvent);
    }

    // Special Use Case for Dynamic Type Mapping ( sObject )
    handleDynamicTypeMapping(event) { 
        console.log('handling a dynamic type mapping');
        console.log('genericTypeMappings is ' + JSON.stringify(this._typeMappings));
        console.log('event is ' + JSON.stringify(event));
        let typeValue = event.detail.objectType;
        const typeName = this._elementType === "Screen" ? 'T' : 'T__record'; 
        console.log('typeValue is: ' + typeValue);
        console.log('typeName is: ' + typeName);
        const dynamicTypeMapping = new CustomEvent(FLOW_EVENT_TYPE.DYNAMIC_MAPPING, {
            composed: true,
            cancelable: false,
            bubbles: true,
            detail: {
                typeName, 
                typeValue, 
            }
        });
        // Dynamic Type Mapping
        this.dispatchEvent(dynamicTypeMapping);
        // Set the objectName
        this.dispatchFlowValueChangeEvent('objectName', typeValue, DATA_TYPE.STRING);
    }   
}