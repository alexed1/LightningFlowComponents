/**
 * Lightning Web Component for Flow Screens:       datatableCPE
 * 
 * When the datatableV2 LWC is running in configuration mode
 * It sends values back to the Datatable Configuration Wizard Flow
 * Which passes them back to the datatableCPE LWC as Output Variables
 * Which dispatches them to the Flow where a datatableV2 LWC is being configured
 * 
 * VERSION:             2.48
 * 
 * RELEASE NOTES:       https://github.com/ericrsmith35/DatatableV2/blob/master/README.md
**/

import {LightningElement, track, api} from 'lwc';

const defaults = {
    apexDefinedTypeInputs: false,
    inputAttributePrefix: 'select_',
    wizardAttributePrefix: 'wiz_',
    dualListboxHeight: '570',
    customHelpDefinition: 'CUSTOM',
};

const COLORS = { 
    blue: '#4C6E96',    //Brand is #1B5297, decreasing shades: 346096, 4C6E96, 657B96
    blue_light: '#657B96',
    green: '#659668',
    green_light: '#7E967F',
    red: '#966594',
    red_light: '#967E95'
}

export default class DatatableCPE extends LightningElement {

    // Define any banner overrides you want to use (see fsc_flowBanner.js)
    _bannerMargin = 'slds-m-top_small slds-m-bottom_xx-small';
    _bannerClass = 'slds-text-color_inverse slds-text-heading_medium slds-m-bottom_xx-small';
    _defaultBannerColor = COLORS.blue;
    _colorWizardOverride = COLORS.green;
    _colorAdvancedOverride = COLORS.red;
    _defaultModalHeaderColor = COLORS.blue_light;
    _modalHeaderColorWizardOverride = COLORS.green_light;
    _modalHeaderColorAdvancedOverride = COLORS.red_light;

    _inputVariables = [];
    _builderContext = [];
    _elementInfo = {};
    _flowVariables;
    _elementType;
    _elementName;

    // These are the parameter values coming back from the Wizard Flow
    _wiz_columnFields;
    _wiz_columnAlignments;
    _wiz_columnEdits;
    _wiz_columnFilters;
    _wiz_columnIcons;
    _wiz_columnLabels;
    _wiz_columnWidths;
    _wiz_columnWraps;

    selectedSObject = '';
    isSObjectInput = true;
    isCheckboxColumnHidden = false;
    isHideCheckboxColumn = true;
    isAnyEdits = false;
    isFlowLoaded = false;
    myBanner = 'My Banner';
    wizardHeight = defaults.dualListboxHeight;
    showColumnAttributesToggle = false;
    firstPass = true;
    isNextDisabled = true;
    nextLabel = 'Next';

    @api
    get isObjectSelected() { 
        return !!this.selectedSObject;
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
    get defaultBannerColor() {
        return this._defaultBannerColor;
    }

    @api
    get colorWizardOverride() { 
        return this._colorWizardOverride;
    }

    @api
    get colorAdvancedOverride() { 
        return this._colorAdvancedOverride;
    }

    @api
    get defaultModalHeaderColor() {
        return this._defaultModalHeaderColor;
    }
    
    @api
    get modalHeaderColorWizardOverride() {
        return this._modalHeaderColorWizardOverride;
    }
    
    @api
    get modalHeaderColorAdvancedOverride() {
        return this._modalHeaderColorAdvancedOverride;
    }

    @api
    get showColumnAttributes() { 
        return (this.showColumnAttributesToggle || !this.isSObjectInput);
    }

    @api
    get wiz_columnFields() { 
        return this._wiz_columnFields;
    }
    set wiz_columnFields(value) { 
        const name = 'columnFields';
        this._wiz_columnFields = value;
        this.dispatchFlowValueChangeEvent(name, value, 'String');
    }

    @api
    get wiz_columnAlignments() { 
        return this._wiz_columnAlignments;
    }
    set wiz_columnAlignments(value) { 
        const name = 'columnAlignments';
        this._wiz_columnAlignments = value;
        this.dispatchFlowValueChangeEvent(name, value, 'String');
    }

    @api
    get wiz_columnEdits() { 
        return this._wiz_columnEdits;
    }
    set wiz_columnEdits(value) { 
        const name = 'columnEdits';
        this._wiz_columnEdits = value;
        this.dispatchFlowValueChangeEvent(name, value, 'String');
    }

    @api
    get wiz_columnFilters() { 
        return this._wiz_columnFilters;
    }
    set wiz_columnFilters(value) { 
        const name = 'columnFilters';
        this._wiz_columnFilters = value;
        this.dispatchFlowValueChangeEvent(name, value, 'String');
    }

    @api
    get wiz_columnIcons() { 
        return this._wiz_columnIcons;
    }
    set wiz_columnIcons(value) { 
        const name = 'columnIcons';
        this._wiz_columnIcons = value;
        this.dispatchFlowValueChangeEvent(name, value, 'String');
    }

    @api
    get wiz_columnLabels() { 
        return this._wiz_columnLabels;
    }
    set wiz_columnLabels(value) { 
        const name = 'columnLabels';
        this._wiz_columnLabels = value;
        this.dispatchFlowValueChangeEvent(name, value, 'String');
    }

    @api
    get wiz_columnWidths() { 
        return this._wiz_columnWidths;
    }
    set wiz_columnWidths(value) { 
        const name = 'columnWidths';
        this._wiz_columnWidths = value;
        this.dispatchFlowValueChangeEvent(name, value, 'String');
    }

    @api
    get wiz_columnWraps() { 
        return this._wiz_columnWraps;
    }
    set wiz_columnWraps(value) { 
        const name = 'columnWraps';
        this._wiz_columnWraps = value;
        this.dispatchFlowValueChangeEvent(name, value, 'String');
    }

    // These names have to match the input attribute names in your <myLWCcomponent>.js-meta.xml file
    @track inputValues = { 
        objectName: {value: null, valueDataType: null, isCollection: false, label: 'Select Object', 
            helpText: 'Select the Object to use in the Datatable'},
        fieldName: {value: null, valueDataType: null, isCollection: false, label: 'Select Field', 
            helpText: null},
        tableData: {value: null, valueDataType: null, isCollection: true, label: 'Display which records?', 
            helpText: 'Record Collection variable containing the records to display in the datatable.'},
        preSelectedRows: {value: null, valueDataType: null, isCollection: true, label: 'Which records are already selected?', 
            helpText: 'Record Collection variable containing the records to show as pre-selected in the datatable.'},
        tableDataString: {value: null, valueDataType: null, isCollection: false, label: 'Datatable Record String', 
            helpText: 'Object Collection string variable containing the records to display in the datatable.'},
        preSelectedRowsString: {value: null, valueDataType: null, isCollection: false, label: 'Pre-Selected Rows String', 
            helpText: 'Object Collection string variable containing the records to show as pre-selected in the datatable.'},
        columnFields: {value: null, valueDataType: null, isCollection: false, label: 'Column Fields', 
            helpText: "REQUIRED: Comma separated list of field API Names to display in the datatable."},  
        columnAlignments: {value: null, valueDataType: null, isCollection: false, label: 'Column Alignments (Col#:alignment,...)', 
            helpText: "Comma separated list of ColID:Alignment Value (left,center,right)\n" +   
            "NOTE: ColIDs can be either the column number or the field API Name"},
        columnEdits: {value: null, valueDataType: null, isCollection: false, label: 'Column Edits (Col#:true,...) or All', 
            helpText: "'All' or a Comma separated list of ColID:true or false\n" +   
            "NOTE: Some data types cannot be edited in a datable (lookup, picklist, location, encrypted, rich text, long text area)\n" + 
            "NOTE: ColIDs can be either the column number or the field API Name"},
        columnFilters: {value: null, valueDataType: null, isCollection: false, label: 'Column Filters (Col#:true,...) or All', 
            helpText: "'All' or a Comma separated list of ColID:true or false\n" +   
            "NOTE: Some data types cannot be filtered in a datable (location, encrypted)\n" + 
            "NOTE: ColIDs can be either the column number or the field API Name"},              
        columnIcons: {value: null, valueDataType: null, isCollection: false, label: 'Column Icons (Col#:icon,...)', 
            helpText: "Comma separated list of ColID:Icon Identifier  --  EXAMPLE: 1:standard:account (Display the first column with the Account icon)\n" + 
            "NOTE: ColIDs can be either the column number or the field API Name"},
        columnLabels: {value: null, valueDataType: null, isCollection: false, label: 'Column Labels (Col#:label,...)', 
            helpText: "Comma separated list of ColID:Label (These are only needed if you want a label that is different from the field's defined label)\n" + 
            "NOTE: ColIDs can be either the column number or the field API Name"},
        columnWidths: {value: null, valueDataType: null, isCollection: false, label: 'Column Widths (Col#:width,...)', 
            helpText: "Comma separated list of ColID:Width (in pixels).\n" + 
            "NOTE: ColIDs can be either the column number or the field API Name"},
        columnWraps: {value: null, valueDataType: null, isCollection: false, label: 'Column Wraps (Col#:true,...)', 
            helpText: "Comma separated list of ColID:true or false (Default:false)\n" + 
            "NOTE: ColIDs can be either the column number or the field API Name"},
        tableLabel: {value: null, valueDataType: null, isCollection: false, label: 'Header Label', 
            helpText: '(Optional) Provide a value here if you want a header label to appear above the datatable.'},
        tableIcon: {value: null, valueDataType: null, isCollection: false, label: 'Header Icon', 
            helpText: '(Optional) Provide a value here if you want a header icon to appear above the datatable.  Example: standard:account'},
        tableBorder: {value: null, valueDataType: null, isCollection: false, label: 'Add Border', 
            helpText: 'When selected, a thin border will be displayed around the entire datatable.  This is the default setting.'},
        tableHeight: {value: null, valueDataType: null, isCollection: false, label: 'Table Height',
            helpText: 'CSS specification for the height of the datatable (Examples: 30rem, 200px, calc(50vh - 100px)  If you leave this blank, the datatable will expand to display all records.)'},
        maxNumberOfRows: {value: null, valueDataType: null, isCollection: false, label: 'Maximum Number of Records to Display', 
            helpText: 'Enter a number here if you want to restrict how many rows will be displayed in the datatable.'},
        suppressNameFieldLink: {value: null, valueDataType: null, isCollection: false, label: "No link on 'Name field", 
            helpText: "Suppress the default behavior of displaying the SObject's 'Name' field as a link to the record"},
        hideCheckboxColumn: {value: null, valueDataType: null, isCollection: false, label: 'Hide checkbox column', 
            helpText: 'Select to hide the row selection column.  --  NOTE: The checkbox column will always display when inline editing is enabled.'},
        isRequired: {value: null, valueDataType: null, isCollection: false, label: 'Require', 
            helpText: 'When this option is selected, the user will not be able to advance to the next Flow screen unless at least one row is selected in the datatable.'},
        singleRowSelection: {value: null, valueDataType: null, isCollection: false, label: 'Single row selection only', 
            helpText: 'When this option is selected, Radio Buttons will be displayed and only a single row can be selected.  The default (False) will display Checkboxes and allow multiple records to be selected.'},
        isUserDefinedObject: {value: null, valueDataType: null, isCollection: false, label: 'Use Apex-Defined Object', 
            helpText: 'Select if you are providing a User(Apex) Defined object rather than a Salesforce SObject.'},
        keyField: {value: 'Id', valueDataType: null, isCollection: false, label: 'Key Field', 
            helpText: 'This is normally the Id field, but you can specify a different field if all field values are unique.'},
    };

    wizardHelpText = 'The Column Wizard Button runs a special Flow where you can select your column fields, manipulate the table to change column widths, '
        + 'select columns for editing and filtering, update labels and formats and much more.';

    sectionEntries = { 
        dataSource: {label: 'Data Source', info: []},
        // columnWizard: {label: 'Column Wizard', info: [ {label: 'Column Wizard', helpText: this.wizardHelpText} ]},
        tableFormatting: {label: 'Table Formatting', info: []},
        tableBehavior: {label: 'Table Behavior', info: []},
        advancedAttributes: {label: 'Advanced', info: []}
    }

    helpSections = [ 
        {name: 'dataSource', 
            attributes: [
                {name: 'objectName'},
                {name: 'tableData'},
                {name: 'preSelectedRows'},
                {name: defaults.customHelpDefinition, 
                    label: 'Apex Defined Object Attributes', 
                    helpText: 'The Datatable component expects a serialized string of the object’s records and fields like the text seen here:\n' + 
                    '[{"field1":"StringRec1Value1","field2":"StringRec1Value2","field3":false,"field4":10},\n' + 
                    '{"field1":"StringRec2Value1","field2":"StringRec2Value2","field3":true,"field4":20},\n' + 
                    '{"field1":"StringRec3Value1","field2":"StringRec3Value2","field3":true,"field4":30}]'},
                {name: 'tableDataString'},
                {name: 'preSelectedRowsString'},
                {name: defaults.customHelpDefinition, 
                    label: 'For more information on using Apex Defined Objects with Datatable',
                    helpText: 'https://ericsplayground.wordpress.com/how-to-use-an-apex-defined-object-with-my-datatable-flow-component/'}
            ]
        },
        {name: 'tableFormatting',
            attributes: [
                {name: 'tableLabel'},
                {name: 'tableIcon'},
                {name: 'tableHeight'},
                {name: 'maxNumberOfRows'},
                {name: 'tableBorder'},
            ]
        },
        {name: 'tableBehavior',
            attributes: [
                {name: 'isRequired'},
                {name: 'suppressNameFieldLink'},
                {name: 'hideCheckboxColumn'},
                {name: 'singleRowSelection'}
            ]
        },
        {name: 'advancedAttributes',
            attributes: [
                {name: 'isUserDefinedObject'},
                {name: defaults.customHelpDefinition, 
                    label: 'Apex Defined Object Attributes', 
                    helpText: 'The Datatable component expects a serialized string of the object’s records and fields like the text seen here:\n' + 
                    '[{"field1":"StringRec1Value1","field2":"StringRec1Value2","field3":false,"field4":10},\n' + 
                    '{"field1":"StringRec2Value1","field2":"StringRec2Value2","field3":true,"field4":20},\n' + 
                    '{"field1":"StringRec3Value1","field2":"StringRec3Value2","field3":true,"field4":30}]'},
                {name: defaults.customHelpDefinition, 
                    label: 'For more information on using Apex Defined Objects with Datatable',
                    helpText: 'https://ericsplayground.wordpress.com/how-to-use-an-apex-defined-object-with-my-datatable-flow-component/'},
                {name: 'columnFields'},
                {name: 'columnAlignments'},
                {name: 'columnEdits'},
                {name: 'columnFilters'},
                {name: 'columnIcons'},
                {name: 'columnLabels'},
                {name: 'columnWidths'},
                {name: 'columnWraps'},
                {name: 'keyField'},
            ]
        }
    ]

    settings = { 
        attributeObjectName: 'objectName',
        attributeFieldName: 'fieldName',
        flowDataTypeString: 'String',
    }

    selectDataSourceOptions = [
        {label: 'SObject Collection', value: !this.inputValues.isUserDefinedObject},
        {label: 'Apex Defined Object String', value: this.inputValues.isUserDefinedObject}
    ];

    // Field Selection Method Radio Buttons
    // fieldSelectionOptionsLabel = 'How do you want to pick your columns?'
    // fieldSelectionOptions = [
    //     {'label': 'Pick your table columns from a list', value: 'Pick'},
    //     {'label': 'Manually specify the column fields', value: 'Manual'}
    // ];
    // fieldSelectionMethod = 'Pick';

    // handleFieldSelectionMethod(event) { 
    //     this.fieldSelectionMethod = event.detail.value;
    //     this.updateFlowParam('vSelectionMethod', this.fieldSelectionMethod);
    // }

    // Input attributes for the Wizard Flow
    @api flowParams = [
        {
            name: 'vSObject',
            type: 'String',
            value: null
        },
        { 
            name: 'vSelectionMethod',
            type: 'String',
            value: ''
        }
    ]

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

    @api 
    get inputVariables() {
        return this._inputVariables;
    }

    set inputVariables(variables) {
        this._inputVariables = variables || [];
        this.initializeValues();
    }

    initializeValues() {
        this._inputVariables.forEach(curInputParam => {
            if (curInputParam.name && curInputParam.value) {
                if (curInputParam.name && this.inputValues[curInputParam.name]) {
                    this.inputValues[curInputParam.name].value = (curInputParam.valueDataType === 'reference') ? '{!' + curInputParam.value + '}' : curInputParam.value;
                    this.inputValues[curInputParam.name].valueDataType = curInputParam.valueDataType;
                    if (curInputParam.name == 'objectName') { 
                        this.selectedSObject = curInputParam.value;    
                    }
                }
            }
        });
        if (this.firstPass) { 
            this.handleDefaultAttributes();
            this.handleBuildHelpInfo();
        }
        this.firstPass = false;
    }

    handleDefaultAttributes() {

    }

    handleBuildHelpInfo() {
        this.helpSections.forEach(section => {
            this.sectionEntries[section.name].info = [];
            section.attributes.forEach(attribute => {
                if (attribute.name == defaults.customHelpDefinition) { 
                    this.sectionEntries[section.name].info.push({label: attribute.label, helpText: attribute.helpText});
                } else {
                    this.sectionEntries[section.name].info.push({label: this.inputValues[attribute.name].label, helpText: this.inputValues[attribute.name].helpText});
                }
            });
        });
    }

    handleDynamicTypeMapping(event) { 
        console.log('handling a dynamic type mapping');
        console.log('event is ' + JSON.stringify(event));
        let typeValue = event.detail.objectType;
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
        this.updateFlowParam('vSObject', typeValue);
        if (this.selectedSObject != typeValue) {
            this.inputValues.tableData.value = null;
            this.inputValues.preSelectedRows.value = null;
            this.dispatchFlowValueChangeEvent('tableData', null, 'String');
            this.dispatchFlowValueChangeEvent('preSelectedRows', null, 'String');
            this.selectedSObject = typeValue;
            this.dispatchFlowValueChangeEvent('objectName', typeValue, 'String');
        }
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
                if (!this.isSObjectInput) { 
                    this.inputValues.objectName.value = null;
                    this.selectedSObject = null;
                    this.dispatchFlowValueChangeEvent('objectName',this.selectedSObject, 'String');
                }
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

    handleShowColumnAttributesToggle(event) { 
        this.showColumnAttributesToggle = !this.showColumnAttributesToggle;
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

    dispatchFlowActionEvent(action) { 
        const flowActionEvent = new CustomEvent('flowAction', { 
            bubbles: true,
            cancelable: false,
            composed: true,
            detail: { 
                id: 'flowAction',
                name: action
            }
        });
        this.dispatchEvent(flowActionEvent);
    }

    updateFlowParam(name, value) {
        this.flowParams.find(param => param.name === name).value = value;
    }

    get wizardParams() {
        return JSON.stringify(this.flowParams);
    }
    
    // handlePickObjectAndFieldValueChange(event) { 
    //     if (event.detail) {
    //         this.dispatchFlowValueChangeEvent(this.settings.attributeObjectName, event.detail.objectType, this.settings.flowDataTypeString);
    //         this.dispatchFlowValueChangeEvent(this.settings.attributeFieldName, event.detail.fieldName, this.settings.flowDataTypeString);
    //     }
    // }

    // These are values coming back from the Wizard Flow
    handleFlowStatusChange(event) {
        this.isFlowLoaded = true;
        event.detail.flowParams.forEach(attribute => {
            let name = attribute.name;
            let value = attribute.value; 
            if (name == 'vSelectionMethod') { 
                this.flowParams.find(param => param.name === name).value = value || '';
                this.isNextDisabled = (value) ? false : true;
            }
            if (name.substring(0,defaults.wizardAttributePrefix.length) == defaults.wizardAttributePrefix) {
                let changedAttribute = name.replace(defaults.wizardAttributePrefix, '');                
                if (event.detail.flowExit) { 
                    // Update the wizard variables to force passing the changed values back to the CPE which will the post to the Flow Builder
                    switch (changedAttribute) { 
                        case 'columnFields':
                            this.wiz_columnFields = value;
                            break;
                        case 'columnAlignments':
                            this.wiz_columnAlignments = value;
                            break;
                        case 'columnEdits':
                            this.wiz_columnEdits = value;
                            break;
                        case 'columnFilters':
                            this.wiz_columnFilters = value;
                            break;
                        case 'columnIcons':
                            this.wiz_columnIcons = value;
                            break;
                        case 'columnLabels':
                            this.wiz_columnLabels = value;
                            break;
                        case 'columnWidths':
                            this.wiz_columnWidths = value;
                            break;
                        case 'columnWraps':
                            this.wiz_columnWraps = value;
                            break;
                        default:
                    }
                    this.isFlowLoaded = false;
                }
            }
        });
    }

    handleWizardCancel() { 
        console.log('handleWizardCancel');
    }

    handleWizardRestart() { 
        console.log('handleWizardRestart');
    }
    
    handleWizardNext() { 
        console.log('handleWizardNext');      
        this.dispatchFlowActionEvent('next');
    }

    connectedCallback() {
        this.template.addEventListener('keydown', this.handleKeyDown.bind(this), true);

        // this.template.querySelector('.nextButton').addEventListener('click', event => { 
        //     console.log('Next Button Clicked');
        //     this.handleWizardNext();
        // });  

        // this.template.addEventListener('keydown', event => {
        //     var keycode = event.code;
        //     if(keycode == 'Escape'){
        //         console.log('CPE ESC Key Pressed');
        //         this.openModal = false;
        //         event.preventDefault();
        //         event.stopImmediatePropagation();
        //     }
        // }, true);
    }

    disconnectedCallback() { 
        this.template.removeEventListener('keydown', this.handleKeyDown.bind(this), true);
    }

    handleKeyDown(event) { 
        var keycode = event.code;
        if(keycode == 'Escape'){
            console.log('CPE ESC Key Pressed');
            this.openModal = false;
            event.preventDefault();
            event.stopImmediatePropagation();
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
    
}