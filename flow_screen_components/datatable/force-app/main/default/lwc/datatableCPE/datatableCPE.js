/**
 * Lightning Web Component for Flow Screens:       datatableCPE
 * 
 * When the datatable LWC is running in configuration mode
 * It sends values back to the Datatable Configuration Wizard Flow
 * Which passes them back to the datatableCPE LWC as Output Variables
 * Which dispatches them to the Flow where a datatable LWC is being configured
 * 
 * CREATED BY:          Eric Smith
 * 
 * VERSION:             3.x.x
 * 
 * RELEASE NOTES:       https://github.com/alexed1/LightningFlowComponents/tree/master/flow_screen_components/datatable/README.md
**/

import {LightningElement, track, api} from 'lwc';
import getCPEReturnResults from '@salesforce/apex/SObjectController2.getCPEReturnResults';
import { getConstants } from 'c/datatableUtils';

const CONSTANTS = getConstants();   // From datatableUtils : VERSION_NUMBER, MAXROWCOUNT, ROUNDWIDTH

const defaults = {
    tableBorder: true,
    apexDefinedTypeInputs: false,
    inputAttributePrefix: 'select_',
    wizardAttributePrefix: 'wiz_',
    dualListboxHeight: '770',
    customHelpDefinition: 'CUSTOM',
    type: 'Type',
    pick: 'Pick',
    NOENCODE: true,
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

    versionNumber;

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

    // These are the parameter values being seeded to & coming back from the Wizard Flow
    _wiz_columnFields;
    _wiz_columnAlignments;
    _wiz_columnEdits;
    _wiz_columnFilters;
    _wiz_columnIcons;
    _wiz_columnLabels;
    _wiz_columnWidths;
    _wiz_columnWraps;

    vSelectionMethod;
    vFieldList = '';
    isEarlyExit = true;
    colFieldList = [];
    validateErrors = [];

    selectedSObject = '';
    isRecordCollectionSelected = false;
    disableAllowALl = false;
    isDisplayAll = false;
    isDisplayAll_Label = 'Display ALL Objects for Selection';
    isDisplayAll_HelpText = 'Select if you want the Object picklist to display all Standard and Custom Salesforce Objects.';
    isCheckboxColumnHidden = false;
    isShowCheckboxColumn = false;
    isNoEdits = true;
    isNoFilters = true;
    isFlowLoaded = false;
    myBanner = 'My Banner';
    wizardHeight = defaults.dualListboxHeight;
    showColumnAttributesToggle = false;
    disallowHeaderChange = false;
    firstPass = true;
    isNextDisabled = true;
    nextLabel = 'Next';
    errorApex;
    objectLabel;
    objectPluralLabel;
    objectIconName;
    dispatchValue;

    @api 
    get isSObjectInput() {
        return !this.inputValues.isUserDefinedObject.value;
    }

    @api
    get isObjectSelected() { 
        return (!!this.selectedSObject && this.isSObjectInput);
    }

    @api
    get availableObjectTypes() {        // Allow admin to specify All object types
        return (this.isDisplayAll) ? 'All' : '';
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
        this.dispatchValue = (value) ? decodeURIComponent(value) : '';
        this.dispatchFlowValueChangeEvent(name, this.dispatchValue, 'String');
        this.updateFlowParam(defaults.wizardAttributePrefix + name, value, ''); 
        if (value) {
            this.vFieldList = value;
            this.updateFlowParam('vFieldList', this.vFieldList, null, defaults.NOENCODE);
            this.createFieldCollection(this.vFieldList);
        }
    }

    @api
    get wiz_columnAlignments() { 
        return this._wiz_columnAlignments;
    }
    set wiz_columnAlignments(value) { 
        const name = 'columnAlignments';
        this._wiz_columnAlignments = value;
        this.dispatchValue = (value) ? decodeURIComponent(value) : '';
        this.dispatchFlowValueChangeEvent(name, this.dispatchValue, 'String');
        this.updateFlowParam(defaults.wizardAttributePrefix + name, value, '');    
    }

    @api
    get wiz_columnEdits() { 
        return this._wiz_columnEdits;
    }
    set wiz_columnEdits(value) { 
        const name = 'columnEdits';
        this._wiz_columnEdits = value;
        this.dispatchValue = (value) ? decodeURIComponent(value) : '';
        this.dispatchFlowValueChangeEvent(name, this.dispatchValue, 'String');
        this.updateFlowParam(defaults.wizardAttributePrefix + name, value, '');
    }

    @api
    get wiz_columnFilters() { 
        return this._wiz_columnFilters;
    }
    set wiz_columnFilters(value) { 
        const name = 'columnFilters';
        this._wiz_columnFilters = value;
        this.dispatchValue = (value) ? decodeURIComponent(value) : '';
        this.dispatchFlowValueChangeEvent(name, this.dispatchValue, 'String');
        this.updateFlowParam(defaults.wizardAttributePrefix + name, value, '');
    }

    @api
    get wiz_columnIcons() { 
        return this._wiz_columnIcons;
    }
    set wiz_columnIcons(value) { 
        const name = 'columnIcons';
        this._wiz_columnIcons = value;
        this.dispatchValue = (value) ? decodeURIComponent(value) : '';
        this.dispatchFlowValueChangeEvent(name, this.dispatchValue, 'String');
        this.updateFlowParam(defaults.wizardAttributePrefix + name, value, '');
    }

    @api
    get wiz_columnLabels() { 
        return this._wiz_columnLabels;
    }
    set wiz_columnLabels(value) { 
        const name = 'columnLabels';
        this._wiz_columnLabels = value;
        this.dispatchValue = (value) ? decodeURIComponent(value) : '';
        this.dispatchFlowValueChangeEvent(name, this.dispatchValue, 'String');
        this.updateFlowParam(defaults.wizardAttributePrefix + name, value, '');
    }

    @api
    get wiz_columnWidths() { 
        return this._wiz_columnWidths;
    }
    set wiz_columnWidths(value) { 
        const name = 'columnWidths';
        this._wiz_columnWidths = value;
        this.dispatchValue = (value) ? decodeURIComponent(value) : '';
        this.dispatchFlowValueChangeEvent(name, this.dispatchValue, 'String');
        this.updateFlowParam(defaults.wizardAttributePrefix + name, value, '');
    }

    @api
    get wiz_columnWraps() { 
        return this._wiz_columnWraps;
    }
    set wiz_columnWraps(value) { 
        const name = 'columnWraps';
        this._wiz_columnWraps = value;
        this.dispatchValue = (value) ? decodeURIComponent(value) : '';
        this.dispatchFlowValueChangeEvent(name, this.dispatchValue, 'String');
        this.updateFlowParam(defaults.wizardAttributePrefix + name, value, '');
    }

    // These names have to match the input attribute names in your <myLWCcomponent>.js-meta.xml file
    @track inputValues = { 
        objectName: {value: null, valueDataType: null, isCollection: false, label: 'Select Object', 
            helpText: 'Select the Object to use in the Datatable',
            isError: false, errorMessage: null},
        fieldName: {value: null, valueDataType: null, isCollection: false, label: 'Select Field', 
            helpText: null},
        tableData: {value: null, valueDataType: null, isCollection: true, label: 'Display which records?', 
            helpText: 'Record Collection variable containing the records to display in the datatable.',
            isError: false, errorMessage: null},
        preSelectedRows: {value: null, valueDataType: null, isCollection: true, label: 'Which records are already selected?', 
            helpText: 'Record Collection variable containing the records to show as pre-selected in the datatable.'},
        tableDataString: {value: null, valueDataType: null, isCollection: false, label: 'Datatable Record String', 
            helpText: 'Object Collection string variable containing the records to display in the datatable.'},
        preSelectedRowsString: {value: null, valueDataType: null, isCollection: false, label: 'Pre-Selected Rows String', 
            helpText: 'Object Collection string variable containing the records to show as pre-selected in the datatable.'},
        columnFields: {value: null, valueDataType: null, isCollection: false, label: 'Column Fields', 
            helpText: "REQUIRED: Comma separated list of field API Names to display in the datatable.",
            isError: false, errorMessage: null},  
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
        columnScales: {value: null, valueDataType: null, isCollection: false, label: 'Column Scales (Col#:scale,...)', 
            helpText: "(Apex Defined Only) Comma separated list of ColID:Scale (The number of digits to display to the right of the decimal point in currency, number and percent fields (default = 0))\n" + 
            "NOTE: ColIDs can be either the column number or the field API Name"},
        columnTypes: {value: null, valueDataType: null, isCollection: false, label: 'Column Types (Col#:type,...)', 
            helpText: "(Apex Defined Only) Comma separated list of ColID:FieldType (boolean, currency, date, datetime, number, email, id, location, percent, phone, time, url, text(default))\n" + 
            "NOTE: ColIDs can be either the column number or the field API Name"},
        columnWidths: {value: null, valueDataType: null, isCollection: false, label: 'Column Widths (Col#:width,...)', 
            helpText: "Comma separated list of ColID:Width (in pixels).\n" + 
            "NOTE: ColIDs can be either the column number or the field API Name"},
        columnWraps: {value: null, valueDataType: null, isCollection: false, label: 'Column Wraps (Col#:true,...)', 
            helpText: "Comma separated list of ColID:true or false (Default:false)\n" + 
            "NOTE: ColIDs can be either the column number or the field API Name"},
        columnCellAttribs: {value: null, valueDataType: null, isCollection: false, label: 'Special CellAttributes',
            helpText: "(Col#:{name:value,...};...) Use ; as the separator -- \n" + 
            "EXAMPLE: FancyField__c:{class: 'slds-theme_shade slds-theme_alert-texture', iconName: {fieldName: IconValue__c}, iconPosition: left}"},
        columnTypeAttribs: {value: null, valueDataType: null, isCollection: false, label: 'Special TypeAttributes',
            helpText: "(Col#:{name:value,...};...) Use ; as the separator -- \n" + 
            "EXAMPLE: DateField__c:{year:'numeric', day:'2-digit', month:'long'}; NumberField__c:{minimumFractionDigits:4}"},
        columnOtherAttribs: {value: null, valueDataType: null, isCollection: false, label: 'Special Other Attributes',
            helpText: "(Col#:{name:value,...};...) Use ; as the separator -- \n" + 
            "EXAMPLE: Description:{wrapText: true, wrapTextMaxLines: 5}"},
        isDisplayHeader: {value: null, valueDataType: null, isCollection: false, label: 'Display Table Header', 
            helpText: '(Optional) Select this option if you want a header to appear above the datatable.'}, 
        tableLabel: {value: null, valueDataType: null, isCollection: false, label: 'Header Label', 
            helpText: '(Optional) Provide a value here for the header label.'},
        tableIcon: {value: null, valueDataType: null, isCollection: false, label: 'Header Icon', 
            helpText: '(Optional) Provide a value here for the header icon.  Example: standard:account'},
        tableBorder: {value: null, valueDataType: null, isCollection: false, label: 'Add Border', 
            helpText: 'When selected, a thin border will be displayed around the entire datatable.'},
        tableHeight: {value: null, valueDataType: null, isCollection: false, label: 'Table Height',
            helpText: 'CSS specification for the height of the datatable (Examples: 30rem, 200px, calc(50vh - 100px)  If you leave this blank, the datatable will expand to display all records.)'},
        maxNumberOfRows: {value: null, valueDataType: null, isCollection: false, label: 'Maximum Number of Records to Display', 
            helpText: 'Enter a number here if you want to restrict how many rows will be displayed in the datatable.'},
        suppressNameFieldLink: {value: null, valueDataType: null, isCollection: false, label: "No link on 'Name field", 
            helpText: "Suppress the default behavior of displaying the SObject's 'Name' field as a link to the record"},
        hideCheckboxColumn: {value: null, valueDataType: null, isCollection: false, label: 'Disallow row selection', 
            helpText: 'Select to hide the row selection column.  --  NOTE: The checkbox column will always display when inline editing is enabled.'},
        showRowNumbers: {value: null, valueDataType: null, isCollection: false, label: 'Show Row Numbers', 
            helpText: 'Display a row number column as the first column in the table.'},            
        isRequired: {value: null, valueDataType: null, isCollection: false, label: 'Require', 
            helpText: 'When this option is selected, the user will not be able to advance to the next Flow screen unless at least one row is selected in the datatable.'},
        singleRowSelection: {value: null, valueDataType: null, isCollection: false, label: 'Single row selection only', 
            helpText: 'When this option is selected, Radio Buttons will be displayed and only a single row can be selected.  The default (False) will display Checkboxes and allow multiple records to be selected.'},
        matchCaseOnFilters: {value: null, valueDataType: null, isCollection: false, label: 'Match case on column filters',
            helpText: "Select if you want to force an exact match on case for column filter values."},
        suppressBottomBar: {value: null, valueDataType: null, isCollection: false, label: 'Hide Cancel/Save buttons',
            helpText: "Cancel/Save buttons will appear by default at the very bottom of the table once a field is edited. \n" +  
            "When hiding these buttons, field updates will be applied as soon as the user Tabs out or selects a different field."},
        isUserDefinedObject: {value: null, valueDataType: null, isCollection: false, label: 'Input data is Apex-Defined', 
            helpText: 'Select if you are providing a User(Apex) Defined object rather than a Salesforce SObject.'},
        keyField: {value: 'Id', valueDataType: null, isCollection: false, label: 'Key Field', 
            helpText: 'This is normally the Id field, but you can specify a different field if all field values are unique.'},
        not_tableBorder: {value: null, valueDataType: null, isCollection: false, label: 'No Border'},                                       // Used so tableBorder can default to True
        not_suppressNameFieldLink: {value: null, valueDataType: null, isCollection: false, label: 'Show navigation links on Name fields',   // Used so suppressNameFieldLink can be exposed as !suppressNameFieldLink
            helpText: "Display the SObject's 'Name' field as a link to the record."},
    };

    wizardHelpText = 'The Column Wizard Button runs a special Flow where you can select your column fields, manipulate the table to change column widths, '
        + 'select columns for editing and filtering, update labels and formats and much more.';

    sectionEntries = { 
        dataSource: {label: 'Data Source', info: []},
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
                {name: defaults.customHelpDefinition, 
                    label: 'Configure Columns Button',
                    helpText: 'Click this button to select the columns(fields) to display.  Additionaly, the Configure Column Wizard will display\n' +
                    'a sample datatable where you can manipulate it to create the attributes needed to reproduce the format you create.'},
                {name: 'isDisplayHeader'},    
                {name: 'tableLabel'},
                {name: 'tableIcon'},
                {name: defaults.customHelpDefinition,
                    label: 'Icon Picker',
                    helpText: 'Select More to show all Icon Types, Select an Icon Type tab to see a list of icons, Select any icon to update the Header Icon value, ' +
                    'Select SELECT TYPE to hide the list of icons.'},
                {name: 'maxNumberOfRows'},
                {name: 'showRowNumbers'},
                {name: 'tableBorder'},
            ]
        },
        {name: 'tableBehavior',
            attributes: [
                {name: 'isRequired'},
                {name: 'hideCheckboxColumn'},
                {name: 'singleRowSelection'},
                {name: 'matchCaseOnFilters'},
                {name: 'suppressBottomBar'},
                {name: 'not_suppressNameFieldLink'},
            ]
        },
        {name: 'advancedAttributes',
            attributes: [
                {name: defaults.customHelpDefinition,
                    label: this.isDisplayAll_Label,
                    helpText: this.isDisplayAll_HelpText},
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
                {name: 'columnScales'},
                {name: 'columnTypes'},
                {name: 'columnWidths'},
                {name: 'columnWraps'},
                {name: 'columnCellAttribs'},
                {name: 'columnTypeAttribs'},
                {name: 'columnOtherAttribs'},
                {name: 'tableHeight'},
                {name: 'keyField'},
            ]
        }
    ]

    // settings = { 
    //     attributeObjectName: 'objectName',
    //     attributeFieldName: 'fieldName',
    //     flowDataTypeString: 'String',
    // }

    // selectDataSourceOptions = [
    //     {label: 'SObject Collection', value: !this.inputValues.isUserDefinedObject},
    //     {label: 'Apex Defined Object String', value: this.inputValues.isUserDefinedObject}
    // ];

    // Input attributes for the Wizard Flow
    @api flowParams = [
        {name: 'vSObject', type: 'String', value: null},
        {name: 'vSelectionMethod', type: 'String', value: ''},
        {name: 'vFieldList', type: 'String', value: ''},
        {name: 'colFieldList', type: 'String', value: []},
        {name: 'wiz_columnAlignments', type: 'String', value: ''},
        {name: 'wiz_columnEdits', type: 'String', value: ''},
        {name: 'wiz_columnFields', type: 'String', value: ''},
        {name: 'wiz_columnFilters', type: 'String', value: ''},
        {name: 'wiz_columnLabels', type: 'String', value: ''},
        {name: 'wiz_columnIcons', type: 'String', value: ''},
        {name: 'wiz_columnWidths', type: 'String', value: ''},
        {name: 'wiz_columnWraps', type: 'String', value: ''},
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
        console.log('datatableCPE - initializeValues');
        this._inputVariables.forEach(curInputParam => {
            if (curInputParam.name && curInputParam.value != null) {
                console.log('Init:', curInputParam.name, curInputParam.value);             
                if (curInputParam.name && this.inputValues[curInputParam.name] != null) {

                    this.inputValues[curInputParam.name].value = (curInputParam.valueDataType === 'reference') ? '{!' + curInputParam.value + '}' : decodeURIComponent(curInputParam.value);                
                    this.inputValues[curInputParam.name].valueDataType = curInputParam.valueDataType;

                    if (curInputParam.name == 'objectName') { 
                        this.selectedSObject = curInputParam.value;    
                    }
                    if (curInputParam.name == 'columnFields') { 
                        this.vFieldList = curInputParam.value;
                        this.updateFlowParam('vFieldList', this.vFieldList, null, defaults.NOENCODE);
                        this.createFieldCollection(this.vFieldList);
                    }
                    if (curInputParam.name == 'not_tableBorder') {
                        this.inputValues.tableBorder.value = !curInputParam.value;
                    }
                    if (curInputParam.name == 'tableBorder') {
                        this.inputValues.not_tableBorder.value = !curInputParam.value;
                    }
                    if (curInputParam.name == 'not_suppressNameFieldLink') {
                        this.inputValues.suppressNameFieldLink.value = !curInputParam.value;
                    }
                    if (curInputParam.name == 'suppressNameFieldLink') {
                        this.inputValues.not_suppressNameFieldLink.value = !curInputParam.value;
                    }
                    if ((curInputParam.name == 'columnEdits') && curInputParam.value) {
                        this.isNoEdits = false;
                    }
                    if ((curInputParam.name == 'columnFilters') && curInputParam.value) {
                        this.isNoFilters = false;
                    }
                    if ((curInputParam.name == 'tableData') && curInputParam.value) {
                        this.isRecordCollectionSelected = true;
                    }
                    
                    // Handle Wizard Attributes
                    let wizName = defaults.wizardAttributePrefix + curInputParam.name;
                    if (this.flowParams.find(fp => fp.name == wizName)) {
                        this.updateFlowParam(wizName, decodeURIComponent(curInputParam.value), '');
                    }

                }
                if (curInputParam.isError) { 
                    this.inputValues[curInputParam.name].isError = false;
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
        console.log('handle default attributes');
        if (this.inputValues.tableBorder.value == this.inputValues.not_tableBorder.value) {
            this.inputValues.tableBorder.value = !this.inputValues.not_tableBorder.value;
        }
        if (this.inputValues.not_suppressNameFieldLink.value == this.inputValues.suppressNameFieldLink.value) {
            this.inputValues.not_suppressNameFieldLink.value = !this.inputValues.suppressNameFieldLink.value;
        }
    }

    handleBuildHelpInfo() {
        console.log('build help info');
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
        this.handleGetObjectDetails(typeValue);
    }

    handleGetObjectDetails(objName) { 
        console.log('Passing object name to Apex Controller', objName);
        getCPEReturnResults({ objName: objName })
        .then(result => {
            let returnResults = JSON.parse(result);

            // Assign return results from the Apex callout
            this.objectLabel = returnResults.objectLabel;
            this.objectPluralLabel = returnResults.objectPluralLabel;
            this.objectIconName = returnResults.objectIconName;
            console.log(`Return Values for ${objName}, Label: ${this.objectLabel}, Plural: ${this.objectPluralLabel}, Icon: ${this.objectIconName}`);

        })  // Handle any errors from the Apex Class
        .catch(error => {
            console.log('getCPEReturnResults error is: ' + JSON.stringify(error));
            if (error.body) {
                this.errorApex = 'Apex Action error: ' + error.body.message;
                alert(this.errorApex + '\n');  // Present the error to the user
            }
            return this.errorApex; 
        });
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

            // Handle default checkbox assignments
            if (curAttributeName == 'tableBorder') {
                this.dispatchFlowValueChangeEvent('not_tableBorder', !curAttributeValue, curAttributeType);
            }
            if (curAttributeName == 'not_suppressNameFieldLink') {
                this.dispatchFlowValueChangeEvent('suppressNameFieldLink', !curAttributeValue, curAttributeType);
            }

            // Change the displayed Data Sources if the Apex Defined Object is selected
            if (curAttributeName == 'isUserDefinedObject') {
                // if (!this.isSObjectInput) { 
                //     this.inputValues.objectName.value = null;
                //     this.selectedSObject = null;
                //     this.dispatchFlowValueChangeEvent('objectName', this.selectedSObject, 'String');
                // }
                if (event.target.checked) {
                    this.isDisplayAll = false;    // Clear & Disable Display All Selection when selecting User Defined Object
                }
                this.disableAllowAll = event.target.checked;
            }

            // Handle isDisplayHeader
            if ((curAttributeName == 'isDisplayHeader') && this.isObjectSelected) {
                if (event.target.checked) { 
                    this.inputValues.tableLabel.value = this.objectPluralLabel;
                    this.dispatchFlowValueChangeEvent('tableLabel', this.inputValues.tableLabel.value, 'String');
                    this.inputValues.tableIcon.value = this.objectIconName;
                    this.dispatchFlowValueChangeEvent('tableIcon', this.inputValues.tableIcon.value, 'String');
                } else { 
                    this.inputValues.tableLabel.value = '';
                    this.dispatchFlowValueChangeEvent('tableLabel', this.inputValues.tableLabel.value, 'String');
                    this.inputValues.tableIcon.value = '';
                    this.dispatchFlowValueChangeEvent('tableIcon', this.inputValues.tableIcon.value, 'String');
                }
            }

            // Don't allow hide the checkbox column if a selection is required or any edits are allowed
            if (curAttributeName == 'isRequired') {
                this.isShowCheckboxColumn = event.target.checked;
                if (!this.isNoEdits || event.target.checked) {
                    this.isShowCheckboxColumn = true;
                    this.inputValues.hideCheckboxColumn.value = false;
                    this.dispatchFlowValueChangeEvent('hideCheckboxColumn', false, 'boolean');
                }
            }

            // Skip is required and single row options if the checkbox column is hidden
            if (curAttributeName == 'hideCheckboxColumn') { 
                this.isCheckboxColumnHidden = event.target.checked;
                this.inputValues.isRequired.value = false;
                this.inputValues.singleRowSelection.value = false;
                this.dispatchFlowValueChangeEvent('isRequired', false, 'boolean');
                this.dispatchFlowValueChangeEvent('singleRowSelection', false, 'boolean');
            }

        }
    
    }

    handleAllowAllChange(event) {
        this.isDisplayAll = event.target.checked;
        // this.inputValues.isUserDefinedObject.value = false;
        // this.dispatchFlowValueChangeEvent('isUserDefinedObject', false, 'Boolean');
        this.inputValues.objectName.value = null;
        this.selectedSObject = null;
        this.dispatchFlowValueChangeEvent('objectName',this.selectedSObject, 'String');
    }

    handleHeightChange(event) { 
        this.wizardHeight = event.target.value;
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

            if (changedAttribute == 'tableData') {
                this.isRecordCollectionSelected = !!event.detail.newValue;
            }
        }
    }

    handlePickIcon(event) {
        let changedAttribute = 'tableIcon';
        this.inputValues[changedAttribute].value = event.detail;
        this.dispatchFlowValueChangeEvent(changedAttribute, event.detail, 'String');
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
        console.log('dispatchFlowValueChangeEvent', id, newValue, newValueDataType);
        if (!newValue) { 
            this.inputValues[id].value = newValue;  // You need to force any cleared values back to inputValues
        }                
        if (newValue) {
            this.inputValues[id].isError = false;   // Clear any prior error before validating again if the field has any value
        }
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

    updateFlowParam(name, value, ifEmpty=null, noEncode=false) {  
        // Set parameter values to pass to Wizard Flow
        console.log('updateFlowParam:', name, value);        
        let currentValue = this.flowParams.find(param => param.name === name).value;
        if (value != currentValue) {
            if (noEncode) {
                this.flowParams.find(param => param.name === name).value = value || ifEmpty;
            } else { 
                this.flowParams.find(param => param.name === name).value = (value) ? encodeURIComponent(value) : ifEmpty;
            }
        }
    }

    // generateFieldDescriptor(label, name, required, type) { 
    //     return {
    //         label: label,
    //         name: name,
    //         required: required,
    //         type: type
    //     }
    // }

    get wizardParams() {
        // Parameter value string to pass to Wizard Flow
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
        console.log('=== handleFlowStatusChange ===');
        if (event.detail.flowStatus == "ERROR") { 
            console.log('Flow Error: ',JSON.stringify(event));
        } else {      
            this.isFlowLoaded = true;
            event.detail.flowParams.forEach(attribute => {
                let name = attribute.name;
                let value = attribute.value; 
                console.log('Output from Wizard Flow: ', name, value);

                if (name == 'vSelectionMethod') { 
                    this.vSelectionMethod = value;
                    this.updateFlowParam(name, value, '');
                    this.isNextDisabled = (value) ? false : true;
                }

                if (name == 'vFieldList' && value) { 
                    // Save Selected Fields & Create Collection
                    this.vFieldList = value.split(' ').join('');  //Remove all spaces  
                    this.updateFlowParam(name, value, null, defaults.NOENCODE);
                    this.createFieldCollection(this.vFieldList);
                }

                if (name == 'vEarlyExit') { 
                    // Determine which screen the user exited on
                    this.isEarlyExit = value;
                }

                if (name.substring(0,defaults.wizardAttributePrefix.length) == defaults.wizardAttributePrefix) {
                    let changedAttribute = name.replace(defaults.wizardAttributePrefix, '');                
                    if (event.detail.flowExit && !this.isEarlyExit) { 
                        // Update the wizard variables to force passing the changed values back to the CPE which will then post to the Flow Builder
                        switch (changedAttribute) { 
                            case 'columnFields':
                                this.wiz_columnFields = value;
                                break;
                            case 'columnAlignments':
                                this.wiz_columnAlignments = value;
                                break;
                            case 'columnEdits':
                                this.wiz_columnEdits = value;
                                this.isNoEdits = (value) ? false : true;
                                this.dispatchFlowValueChangeEvent('isRequired', false, 'boolean');
                                if (this.isNoEdits) {
                                    this.inputValues.suppressBottomBar.value = false;
                                    this.dispatchFlowValueChangeEvent('suppressBottomBar', false, 'boolean');
                                }
                                break;
                            case 'columnFilters':
                                this.wiz_columnFilters = value;
                                this.isNoFilters = (value) ? false : true;
                                if (this.isNoFilters) {
                                    this.inputValues.matchCaseOnFilters.value = false;
                                    this.dispatchFlowValueChangeEvent('matchCaseOnFilters', false, 'boolean');
                                }
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
    }

    createFieldCollection(fieldList) {
        // Create collection of fields from comma separated list
        if (fieldList && fieldList.length > 0) {
            this.colFieldList = [];
            fieldList.split(',').forEach(f => {
                this.colFieldList.push(f);
            });
            this.inputValues['columnFields'].isError = false;
            this.updateFlowParam('colFieldList', this.colFieldList, null, defaults.NOENCODE);
        }
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
        this.versionNumber = CONSTANTS.VERSION_NUMBER;
        
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
        // this.template.removeEventListener('keydown', this.handleKeyDown.bind(this)); //Causes: Error during LWC component disconnect phase: [Error during LWC component disconnect phase: [TypeError]] Failing descriptor: {builder_platform_interaction:screenEditor}
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

    @api
    validate() {
        this.validateErrors.length = 0;

        // Not Apex-Defined -- Check for Object, Record Collection, Columns
        if (this.isSObjectInput) {
            this.checkError((!this.isObjectSelected), 'objectName', 'You must select an Object');
            this.checkError((!this.isRecordCollectionSelected), 'tableData', 'You must provide a Collection of Records to display');
            this.checkError((!this.vFieldList), 'columnFields', 'At least 1 column must be selected');
        }

        let allComboboxes = this.template.querySelectorAll('c-flow-combobox');
        if (allComboboxes) {
            allComboboxes.forEach(curCombobox => {
                if (!curCombobox.reportValidity()) {
                    resultErrors.push('error');
                }
            });
        }

        return this.validateErrors;
    }

    checkError(isError, key, errorString) { 
        if (isError) { 
            this.validateErrors.push({key: key, errorString: errorString});
            this.inputValues[key].isError = true;
            this.inputValues[key].errorMessage = errorString;
        } else { 
            this.inputValues[key].isError = false;
        }
        // console.log('CPE generated error:', key, isError, (isError ? errorString : ''));
    }

}