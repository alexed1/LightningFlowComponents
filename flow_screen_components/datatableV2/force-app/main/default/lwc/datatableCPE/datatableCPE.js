import {LightningElement, track, api} from 'lwc';

const defaults = {
    apexDefinedTypeInputs: false,
    inputAttributePrefix: 'select_'
};

export default class DatatableCPE extends LightningElement {

    // Define any banner overrides you want to use (see fsc_flowBanner.js)
    _bannerColor = '#4C6E96';    //Brand is #1B5297, decreasing shades: 346096, 4C6E96, 657B96
    _bannerMargin = 'slds-m-top_small slds-m-bottom_xx-small';
    _bannerClass = 'slds-text-color_inverse slds-text-heading_medium slds-m-bottom_xx-small';
    _colorAdvancedOverride = '#966594';
    _colorWizardOverride = '#659668';

    _inputVariables = [];
    _builderContext = [];
    _elementInfo = {};
    _flowVariables;
    _elementType;
    _elementName;

    selectedSObject = '';
    isSObjectInput = true;
    isObjectSelected = false;
    isCheckboxColumnHidden = false;
    isHideCheckboxColumn = true;
    isAnyEdits = false;
    myBanner = 'My Banner';
    wizardHeight = '560';

    @api
    get bannerColor() {
        return this._bannerColor;
    }

    @api
    get bannerMargin() {
        return this._bannerMargin;
    }

    @api
    get bannerClass() {
        return this._bannerClass;
    }

    @api
    get colorAdvancedOverride() { 
        return this._colorAdvancedOverride;
    }

    @api
    get colorWizardOverride() { 
        return this._colorWizardOverride;
    }

    // These names have to match the input attribute names in your <myLWCcomponent>.js-meta.xml file
    @track inputValues = { 
        objectName: {value: null, valueDataType: null, isCollection: false, label: 'Select Object', 
            helpText: 'Select the Object to use in the Datatable'},
        fieldName: {value: null, valueDataType: null, isCollection: false, label: 'Select Field', 
            helpText: null},
        tableData: {value: null, valueDataType: null, isCollection: true, label: 'Datatable Record Collection', 
            helpText: 'Record Collection variable containing the records to display in the datatable.'},
        preSelectedRows: {value: null, valueDataType: null, isCollection: true, label: 'Pre-Selected Rows Collection', 
            helpText: 'Record Collection variable containing the records to show as pre-selected in the datatable.'},
        tableDataString: {value: null, valueDataType: null, isCollection: false, label: 'Datatable Record String', 
            helpText: 'Object Collection string variable containing the records to display in the datatable.'},
        preSelectedRowsString: {value: null, valueDataType: null, isCollection: false, label: 'Pre-Selected Rows String', 
            helpText: 'Object Collection string variable containing the records to show as pre-selected in the datatable.'},
        tableLabel: {value: null, valueDataType: null, isCollection: false, label: '(Optional) Label to display on the Table Header', 
            helpText: 'Provide a value here if you want a header label to appear above the datatable.'},
        tableIcon: {value: null, valueDataType: null, isCollection: false, label: '(Optional) Icon to display on the Table Header', 
            helpText: 'Example: standard:account'},
        tableBorder: {value: null, valueDataType: null, isCollection: false, label: 'Display a border around the datatable?', 
            helpText: 'When selected, a thin border will be displayed around the entire datatable.  This is the default setting.'},
        tableHeight: {value: null, valueDataType: null, isCollection: false, label: 'Table Height Definition',
            helpText: 'CSS specification for the height of the datatable (Examples: 30rem, 200px, calc(50vh - 100px)  If you leave this blank, the datatable will expand to display all records.)'},
        maxNumberOfRows: {value: null, valueDataType: null, isCollection: false, label: 'Maximum Number of Records to Display', 
            helpText: 'Enter a number here if you want to restrict how many rows will be displayed in the datatable.'},
        suppressNameFieldLink: {value: null, valueDataType: null, isCollection: false, label: "Suppress the Link on the 'Name' Field?", 
            helpText: "Suppress the default behavior of displaying the SObject's 'Name' field as a link to the record"},
        hideCheckboxColumn: {value: null, valueDataType: null, isCollection: false, label: 'Hide Checkbox Column?', 
            helpText: 'Select to hide the row selection column.  --  NOTE: The checkbox column will always display when inline editing is enabled.'},
        isRequired: {value: null, valueDataType: null, isCollection: false, label: 'Require at least 1 row to be selected?', 
            helpText: 'When this option is selected, the user will not be able to advance to the next Flow screen unless at least one row is selected in the datatable.'},
        singleRowSelection: {value: null, valueDataType: null, isCollection: false, label: 'Single Row Selection (Radio Buttons)?', 
            helpText: 'When this option is selected, Radio Buttons will be displayed and only a single row can be selected.  The default (False) will display Checkboxes and allow multiple records to be selected.'},
        isUserDefinedObject: {value: null, valueDataType: null, isCollection: false, label: 'Use Apex-Defined Object', 
            helpText: 'Select if you are providing a User(Apex) Defined object rather than a Salesforce SObject.'},
        keyField: {value: null, valueDataType: null, isCollection: false, label: 'Key Field', 
            helpText: 'This is normally the Id field, but you can specify a different field if all field values are unique.'},
    };

    wizardHelpText = 'The Column Wizard Button runs a special Flow where you can select your column fields, manipulate the table to change column widths, '
        + 'select columns for editing and filtering, update labels and formats and much more.';

    sectionEntries = { 
        dataSource: {label: 'Data Source', info: []},
        columnWizard: {label: 'Column Wizard', info: [ {label: 'Column Wizard', helpText: this.wizardHelpText} ]},
        tableFormatting: {label: 'Table Formatting', info: []},
        tableBehavior: {label: 'Table Behavior', info: []},
        advancedAttributes: {label: 'Advanced Attributes', info: []}
    }

    helpSections = [ 
        {name: 'dataSource', 
            attributes: [
                {name: 'objectName'},
                {name: 'tableData'},
                {name: 'preSelectedRows'},
                {name: 'tableDataString'},
                {name: 'preSelectedRowsString'}
            ]
        },
        {name: 'tableFormatting',
            attributes: [
                {name: 'tableLabel'},
                {name: 'tableIcon'},
                {name: 'tableBorder'},
                {name: 'tableHeight'},
                {name: 'maxNumberOfRows'}
            ]
        },
        {name: 'tableBehavior',
            attributes: [
                {name: 'suppressNameFieldLink'},
                {name: 'hideCheckboxColumn'},
                {name: 'isRequired'},
                {name: 'singleRowSelection'}
            ]
        },
        {name: 'advancedAttributes',
            attributes: [
                {name: 'isUserDefinedObject'},
                {name: 'keyField'}
            ]
        }
    ]

    settings = { 
        attributeObjectName: 'objectName',
        attributeFieldName: 'fieldName'
    }

    selectDataSourceOptions = [
        {label: 'SObject Collection', value: !this.inputValues.isUserDefinedObject},
        {label: 'Apex Defined Object String', value: this.inputValues.isUserDefinedObject}
    ];

    @api flowParams = [{
        name: 'vSObject',
        type: 'String',
        value: null
    }]

    @api 
    get inputVariables() {
        return this._inputVariables;
    }

    set inputVariables(variables) {
        this._inputVariables = variables || [];
        this.initializeValues();
    }

    @api 
    get builderContext() {
        return this._builderContext;
    }

    set builderContext(context) {
        this._builderContext = context || {};
        if (this._builderContext) {
            const { variables } = this._builderContext;
            this._flowVariables = [...variables];
        }
    }

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

    initializeValues() {
        this._inputVariables.forEach(curInputParam => {
            if (curInputParam.name && curInputParam.value) {
                if (curInputParam.name && this.inputValues[curInputParam.name]) {
                    this.inputValues[curInputParam.name].value = (curInputParam.valueDataType === 'reference') ? '{!' + curInputParam.value + '}' : curInputParam.value;
                    this.inputValues[curInputParam.name].valueDataType = curInputParam.valueDataType;
                }
            }
        });
        this.handleDefaultAttributes();
        this.handleBuildHelpInfo();
    }

    handleDefaultAttributes() {
        this.inputValues.tableBorder.value = true;
        this.inputValues.keyField.value = 'Id';
    }

    handleBuildHelpInfo() {
        this.helpSections.forEach(section => {
            this.sectionEntries[section.name].info = [];
            section.attributes.forEach(attribute => {
                this.sectionEntries[section.name].info.push({label: this.inputValues[attribute.name].label, helpText: this.inputValues[attribute.name].helpText});
            });
        });
    }

    handleDynamicTypeMapping(event) { 
        console.log('handling a dynamic type mapping');
        console.log('event is ' + JSON.stringify(event));
        let typeValue = event.detail.objectType;
        // let typeName = 'T'; //this is hardcoded, which is bad, and should be a lookup to a setting.
        const typeName = this._elementType === "Screen" ? 'T' : 'T__record'; 
        console.log('typeValue is: ' + typeValue);
        const dynamicTypeMapping = new CustomEvent('configuration_editor_generic_type_mapping_changed', {
            composed: true,
            cancelable: false,
            bubbles: true,
            detail: {
                typeName, 
                typeValue, 
            }
        });
        this.dispatchEvent(dynamicTypeMapping);
        this.updateRecordVariablesComboboxOptions(typeValue);
        this.selectedSObject = typeValue;
        this.isObjectSelected = true;
        this.inputValues.tableData.value = null;
        this.inputValues.preSelectedRows.value = null;
        this.updateFlowParam('vSObject', typeValue);
    }

    handleValueChange(event) {
        if (event.target) {
            let curAttributeName = event.target.name ? event.target.name.replace(defaults.inputAttributePrefix, '') : null;
            let value = event.detail ? event.detail.value : event.target.value;
            let curAttributeValue = event.target.type === 'checkbox' ? event.target.checked : value;
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

            // Change the displayed Data Sources if the Apex Defined Object is selected
            if (curAttributeName == 'isUserDefinedObject') {
                this.isSObjectInput = !event.target.checked;
                this.isObjectSelected = (this.isSObjectInput && this.selectedSObject != '');
            }

            // Don't allow hide the checkbox column if a selection is required or any edits are allowed
            if (curAttributeName == 'isRequired') {
                this.isHideCheckboxColumn = !event.target.checked;
                if (this.isAnyEdits || event.target.checked) {
                    this.isHideCheckboxColumn = false;
                    this.inputValues.hideCheckboxColumn.value = false;
                    this.dispatchFlowValueChangeEvent('hideCheckboxColumn', false, 'boolean');
                }
            }

            // Skip is required and single row options if the checkbox column is hidden
            if (curAttributeName == 'hideCheckboxColumn') { 
                this.isCheckboxColumnHidden = event.target.checked;
                this.inputValues.isRequired.value = false;
                this.dispatchFlowValueChangeEvent('isRequired', false, 'boolean');
            }
        }
    
    }

    handleHeightChange(event) { 
        this.wizardHeight = event.target.value;
    }
    
    @api
    validate() {
        const validity = [];
        return validity;
    }

    updateRecordVariablesComboboxOptions(objectType) {
        const variables = this._flowVariables.filter(
            (variable) => variable.objectType === objectType
        );
        let comboboxOptions = [];
        variables.forEach((variable) => {
            comboboxOptions.push({
                label: variable.name,
                value: "{!" + variable.name + "}"
            });
        });
        return comboboxOptions;
    }

    handleFlowComboboxValueChange(event) {   
        if (event.target && event.detail) {
            let changedAttribute = event.target.name.replace(defaults.inputAttributePrefix, '');
            this.dispatchFlowValueChangeEvent(changedAttribute, event.detail.newValue, event.detail.newValueDataType);
        }
    }

    dispatchFlowValueChangeEvent(id, newValue, newValueDataType) {
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

    updateFlowParam(name, value) {
        this.flowParams.find(param => param.name === name).value = value;
    }

    get wizardParams() {
        return JSON.stringify(this.flowParams);
    }
    
    handlePickObjectAndFieldValueChange(event) {
        if (event.detail) {
            this.dispatchFlowValueChangeEvent(this.settings.attributeObjectName, event.detail.objectType, this.settings.flowDataTypeString);
            this.dispatchFlowValueChangeEvent(this.settings.attributeFieldName, event.detail.fieldName, this.settings.flowDataTypeString);
        }
    }

    handleFlowStatusChange(event) {
        console.log('STATUS CHANGE', event.detail.flowParams);  // These are values coming back from the Wizard Flow
        event.detail.flowParams.forEach(attribute => { 
            console.log('Field, Value', attribute.name, attribute.value);
        });
    }

    // Keep the ESC key from also closing the CPE
    connectedCallback() { 
        this.template.addEventListener('keydown', event => {
            var keycode = event.code;
            if(keycode == 'Escape'){
                this.openModal = false;
                event.preventDefault();
                event.stopImmediatePropagation();
            }
        }, true);
    }
    
    //don't forget to credit https://www.salesforcepoint.com/2020/07/LWC-modal-popup-example-code.html
    @track openModal = false;
    showModal() {
        this.openModal = true;
    }
    closeModal() {
        this.openModal = false;
    }
    
}