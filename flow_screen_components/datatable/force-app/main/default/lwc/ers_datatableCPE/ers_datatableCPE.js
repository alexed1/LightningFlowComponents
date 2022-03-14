/**
 * Lightning Web Component for Flow Screens:       ers_datatableCPE
 * 
 * When the datatable LWC is running in configuration mode
 * It sends values back to the Datatable Configuration Wizard Flow
 * Which passes them back to the ers_datatableCPE LWC as Output Variables
 * Which dispatches them to the Flow where a datatable LWC is being configured
 * 
 * CREATED BY:          Eric Smith
 * 
 * VERSION:             3.x.x
 * 
 * RELEASE NOTES:       https://github.com/alexed1/LightningFlowComponents/tree/master/flow_screen_components/datatable/README.md
**/

import {LightningElement, track, api} from 'lwc';
import getCPEReturnResults from '@salesforce/apex/ers_DatatableController.getCPEReturnResults';
import { getConstants } from 'c/ers_datatableUtils';

const CONSTANTS = getConstants();   // From ers_datatableUtils : VERSION_NUMBER, MAXROWCOUNT, ROUNDWIDTH, MYDOMAIN, ISCOMMUNITY, WIZROWCOUNT
const CB_TRUE = CONSTANTS.CB_TRUE;
const CB_FALSE = CONSTANTS.CB_FALSE;
const CB_PREFIX = CONSTANTS.CB_ATTRIB_PREFIX;

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
    blue: '#4C6E96',        //Brand is #1B5297, decreasing shades: #346096, #4C6E96, #657B96
    blue_light: '#657B96',
    green: '#659668',
    green_light: '#7E967F',
    red: '#966594',
    red_light: '#967E95'
}

export default class ers_datatableCPE extends LightningElement {

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
    _automaticOutputVariables;

    // These are the parameter values being seeded to & coming back from the Wizard Flow
    _wiz_columnFields;
    _wiz_columnAlignments;
    _wiz_columnEdits;
    _wiz_columnFilters;
    _wiz_columnIcons;
    _wiz_columnLabels;
    _wiz_columnWidths;
    _wiz_columnWraps;
    _wiz_columnCellAttribs;
    _wiz_columnTypeAttribs;
    _wiz_columnOtherAttribs;

    vSelectionMethod;
    vFieldList = '';
    isEarlyExit = true;
    colFieldList = [];
    validateErrors = [];

    selectedSObject = '';
    isRecordCollectionSelected = false;
    isSerializedSelected = false;
    isApexSelected = false;
    disableAllowALl = false;
    isCheckboxColumnHidden = false;
    isShowCheckboxColumn = false;
    isNoEdits = true;
    isNoFilters = true;
    isFlowLoaded = false;
    myBanner = 'My Banner';
    wizardHeight = defaults.dualListboxHeight;
    @api showColumnAttributesToggle = false; // TODO remove api
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
    get isSerializedRecordDataInput() {                                                 
        return this.inputValues.isSerializedRecordData.value;                           
    }
    
    @api
    get serializedRecordData() {
        return this.inputValues.serializedRecordData.value;
    }
    set serializedRecordData(value) {
        this.inputValues.serializedRecordData.value = value;
    }

    @api 
    get isSerializedRecordDataSelected() {                                              //DELETE
        return false;                                                                   //DELETE
    }                                                                                   //DELETE

    @api
    get isDisplayAll() {
        return this.inputValues.displayAll.value;
    }
    set isDisplayAll(value) {
        this.inputValues.displayAll.value = value;
    }

    @api
    get isAllowOverflow() {
        return this.inputValues.allowOverflow.value;
    }
    set isAllowOverflow(value) {
        this.inputValues.allowOverflow.value = value;
    }

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
        return (this.showColumnAttributesToggle || !this.isSObjectInput || this.inputValues.isSerializedRecordData.value);
    }
    
    @api
    get isShowColumnAttributesToggle() { 
        return (this.isObjectSelected && !this.inputValues.isSerializedRecordData.value);
    }

    @api
    get showHideColumnAttributes() {
        return this.showColumnAttributes ? 'slds-show' : 'slds-hide';
    }

    @api
    get isNoLinks() {
        return (this.inputValues.cb_not_suppressNameFieldLink.value == CB_FALSE);
    }

    @api
    get isDisableNavigateNext() {
        return (this.isNoEdits || this.inputValues.suppressBottomBar.value);
    }

    @api
    get isDisableSuppressBottomBar() {
        return (this.isNoEdits || this.inputValues.navigateNextOnSave.value);
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
        try{
            this.dispatchValue = (value) ? decodeURIComponent(value) : '';
        }
        catch(err) {    // Handle column label that includes a % character
            this.dispatchValue = value;
        }
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

    @api
    get wiz_columnCellAttribs() { 
        return this._wiz_columnCellAttribs;
    }
    set wiz_columnCellAttribs(value) { 
        const name = 'columnCellAttribs';
        this._wiz_columnCellAttribs = value;
        this.dispatchValue = (value) ? decodeURIComponent(value) : '';
        this.dispatchFlowValueChangeEvent(name, this.dispatchValue, 'String');
        this.updateFlowParam(defaults.wizardAttributePrefix + name, value, '');
    }

    @api
    get wiz_columnTypeAttribs() { 
        return this._wiz_columnTypeAttribs;
    }
    set wiz_columnTypeAttribs(value) { 
        const name = 'columnTypeAttribs';
        this._wiz_columnTypeAttribs = value;
        this.dispatchValue = (value) ? decodeURIComponent(value) : '';
        this.dispatchFlowValueChangeEvent(name, this.dispatchValue, 'String');
        this.updateFlowParam(defaults.wizardAttributePrefix + name, value, '');
    }

    @api
    get wiz_columnOtherAttribs() { 
        return this._wiz_columnOtherAttribs;
    }
    set wiz_columnOtherAttribs(value) { 
        const name = 'columnOtherAttribs';
        this._wiz_columnOtherAttribs = value;
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
            helpText: "Comma separated list of ColID:Alignment Value (left,center,right)  \n" +   
            "NOTE: ColIDs can be either the column number or the field API Name"},
        columnEdits: {value: null, valueDataType: null, isCollection: false, label: 'Column Edits (Col#:true,...) or All', 
            helpText: "'All' or a Comma separated list of ColID:true or false  \n" +   
            "NOTE: Some data types cannot be edited in a datable (lookup, picklist, location, encrypted, rich text, long text area)\n" + 
            "NOTE: ColIDs can be either the column number or the field API Name"},
        columnFilters: {value: null, valueDataType: null, isCollection: false, label: 'Column Filters (Col#:true,...) or All', 
            helpText: "'All' or a Comma separated list of ColID:true or false  \n" +   
            "NOTE: Some data types cannot be filtered in a datable (location, encrypted)  \n" + 
            "NOTE: ColIDs can be either the column number or the field API Name"},              
        columnIcons: {value: null, valueDataType: null, isCollection: false, label: 'Column Icons (Col#:icon,...)', 
            helpText: "Comma separated list of ColID:Icon Identifier  --  EXAMPLE: 1:standard:account (Display the first column with the Account icon)  \n" + 
            "NOTE: ColIDs can be either the column number or the field API Name"},
        columnLabels: {value: null, valueDataType: null, isCollection: false, label: 'Column Labels (Col#:label,...)', 
            helpText: "Comma separated list of ColID:Label (These are only needed if you want a label that is different from the field's defined label)  \n" + 
            "NOTE: ColIDs can be either the column number or the field API Name"},
        columnScales: {value: null, valueDataType: null, isCollection: false, label: 'Column Scales (Col#:scale,...)', 
            helpText: "(Apex Defined Only) Comma separated list of ColID:Scale (The number of digits to display to the right of the decimal point in currency, number and percent fields (default = 0))  \n" + 
            "NOTE: ColIDs can be either the column number or the field API Name"},
        columnTypes: {value: null, valueDataType: null, isCollection: false, label: 'Column Types (Col#:type,...)', 
            helpText: "(Apex Defined Only) Comma separated list of ColID:FieldType (boolean, currency, date, datetime, number, email, id, location, percent, phone, time, url, text(default))  \n" + 
            "NOTE: ColIDs can be either the column number or the field API Name"},
        columnWidths: {value: null, valueDataType: null, isCollection: false, label: 'Column Widths (Col#:width,...)', 
            helpText: "Comma separated list of ColID:Width (in pixels).  \n" + 
            "NOTE: ColIDs can be either the column number or the field API Name"},
        columnWraps: {value: null, valueDataType: null, isCollection: false, label: 'Column Wraps (Col#:true,...)', 
            helpText: "Comma separated list of ColID:true or false (Default:false)  \n" + 
            "NOTE: ColIDs can be either the column number or the field API Name"},
        columnCellAttribs: {value: null, valueDataType: null, isCollection: false, label: 'Special Cell Attributes',
            helpText: "(Col#:{name:value,...};...) Use ; as the separator -- \n" + 
            "EXAMPLE: FancyField__c:{class: 'slds-theme_shade slds-theme_alert-texture', iconName: {fieldName: IconValue__c}, iconPosition: left}"},
        columnTypeAttribs: {value: null, valueDataType: null, isCollection: false, label: 'Special Type Attributes',
            helpText: "(Col#:{name:value,...};...) Use ; as the separator -- \n" + 
            "EXAMPLE: DateField__c:{year:'numeric', day:'2-digit', month:'long'}; NumberField__c:{minimumFractionDigits:4}"},
        columnOtherAttribs: {value: null, valueDataType: null, isCollection: false, label: 'Special Other Attributes',
            helpText: "(Col#:{name:value,...};...) Use ; as the separator -- \n" + 
            "EXAMPLE: Description:{wrapText: true, wrapTextMaxLines: 5}"},
        isDisplayHeader: {value: null, valueDataType: null, isCollection: false, label: 'Display Table Header', 
            helpText: '(Optional) Select this option if you want a header to appear above the datatable.'}, 
        cb_isDisplayHeader: {value: null, valueDataType: null, isCollection: false, label: ''},    
        tableLabel: {value: null, valueDataType: null, isCollection: false, label: 'Header Label', 
            helpText: '(Optional) Provide a value here for the header label.'},
        tableIcon: {value: null, valueDataType: null, isCollection: false, label: 'Header Icon', 
            helpText: '(Optional) Provide a value here for the header icon.  Example: standard:account'},
        tableBorder: {value: null, valueDataType: null, isCollection: false, label: 'Add Border', 
            helpText: 'When selected, a thin border will be displayed around the entire datatable.'},
        cb_tableBorder: {value: CB_TRUE, valueDataType: null, isCollection: false, label: ''},
        tableHeight: {value: null, valueDataType: null, isCollection: false, label: 'Table Height',
            helpText: 'CSS specification for the height of the datatable (Examples: 30rem, 200px, calc(50vh - 100px)  If you leave this blank, the datatable will expand to display all records.)  \n' +
            'NOTE: This value will be ignored if the Allow Overflow attribute is set to True.'},
        maxNumberOfRows: {value: null, valueDataType: null, isCollection: false, label: 'Maximum Number of Records to Display', 
            helpText: 'Enter a number here if you want to restrict how many rows will be displayed in the datatable.'},
        suppressNameFieldLink: {value: null, valueDataType: null, isCollection: false, label: "No link on 'Name field",                     // OBSOLETE as of v3.0.10
            helpText: "Suppress the default behavior of displaying the SObject's 'Name' field as a link to the record"},
        hideCheckboxColumn: {value: null, valueDataType: null, isCollection: false, label: 'Disallow row selection', 
            helpText: 'Select to hide the row selection column.  --  NOTE: The checkbox column will always display when inline editing is enabled.'},
        cb_hideCheckboxColumn: {value: null, valueDataType: null, isCollection: false, label: ''}, 
        hideHeaderActions: {value: null, valueDataType: null, isCollection: false, label: 'Hide Column Header Actions', 
            helpText: 'Set to True to hide all column header actions including Sort, Clip Text, Wrap Text & Filter.'},
        cb_hideHeaderActions: {value: null, valueDataType: null, isCollection: false, label: ''}, 
        hideClearSelectionButton: {value: null, valueDataType: null, isCollection: false, label: 'Hide Clear Selection Button', 
            helpText: 'Set to True to hide the Clear Selection Button that would normally appear on a radio button selection table.'},
        cb_hideClearSelectionButton: {value: null, valueDataType: null, isCollection: false, label: ''}, 
        showRowNumbers: {value: null, valueDataType: null, isCollection: false, label: 'Show Row Numbers', 
            helpText: 'Display a row number column as the first column in the table.'}, 
        cb_showRowNumbers: {value: null, valueDataType: null, isCollection: false, label: ''},    
        showRecordCount: {value: null, valueDataType: null, isCollection: false, label: 'Show Record Count in Header', 
            helpText: 'Display the number of records in the table header.  This will match what is shown in a List View header.'}, 
        cb_showRecordCount: {value: null, valueDataType: null, isCollection: false, label: ''},         
        isRequired: {value: null, valueDataType: null, isCollection: false, label: 'Require', 
            helpText: 'When this option is selected, the user will not be able to advance to the next Flow screen unless at least one row is selected in the datatable.'},
        cb_isRequired: {value: null, valueDataType: null, isCollection: false, label: ''},
        singleRowSelection: {value: null, valueDataType: null, isCollection: false, label: 'Single row selection only', 
            helpText: 'When this option is selected, Radio Buttons will be displayed and only a single row can be selected.  The default (False) will display Checkboxes and allow multiple records to be selected.'},
        cb_singleRowSelection: {value: null, valueDataType: null, isCollection: false, label: ''},    
        matchCaseOnFilters: {value: null, valueDataType: null, isCollection: false, label: 'Match case on column filters',
            helpText: "Select if you want to force an exact match on case for column filter values."},
        cb_matchCaseOnFilters: {value: null, valueDataType: null, isCollection: false, label: ''},
        suppressBottomBar: {value: null, valueDataType: null, isCollection: false, label: 'Hide Cancel/Save buttons',
            helpText: "Cancel/Save buttons will appear by default at the very bottom of the table once a field is edited. \n" +  
            "When hiding these buttons, field updates will be applied as soon as the user Tabs out or selects a different field."},
        cb_suppressBottomBar: {value: null, valueDataType: null, isCollection: false, label: ''},
        navigateNextOnSave: {value: null, valueDataType: null, isCollection: false, label: 'Navigate to Next Flow Element on Save',
            helpText: "When selecting Save after inline editing, immediately navigate to the next Flow element. \n" +  
            "This removes the need for the User to select the Next button after saving. "},
        cb_navigateNextOnSave: {value: null, valueDataType: null, isCollection: false, label: ''},        
        isUserDefinedObject: {value: null, valueDataType: null, isCollection: false, label: 'Input data is Apex-Defined', 
            helpText: 'Select if you are providing a User(Apex) Defined object rather than a Salesforce SObject.'},
        cb_isUserDefinedObject: {value: null, valueDataType: null, isCollection: false, label: ''},
        keyField: {value: 'Id', valueDataType: null, isCollection: false, label: 'Key Field', 
            helpText: 'This is normally the Id field, but you can specify a different field if all field values are unique.'},
        not_tableBorder: {value: null, valueDataType: null, isCollection: false, label: 'No Border'},                                       // OBSOLETE as of v3.0.10 - Used so tableBorder can default to True
        not_suppressNameFieldLink: {value: null, valueDataType: null, isCollection: false, label: 'Show navigation links on Name fields',   // Default value is to show the links
            helpText: "Display the SObject's 'Name' field as a link to the record."},
        cb_not_suppressNameFieldLink: {value: CB_TRUE, valueDataType: null, isCollection: false, label: ''},
        openLinkinSameTab: {value: null, valueDataType: null, isCollection: false, label: 'Open links in the same Tab', 
            helpText: 'When this option is selected, clicking on a link will open the record in the same browser or console Tab instead of a new browser Tab.  This is especially useful when the user is running in a Console.'},
        cb_openLinkinSameTab: {value: null, valueDataType: null, isCollection: false, label: ''},
        displayAll: {value: null, valueDataType: null, isCollection: false, label: 'Display ALL Objects for Selection', 
            helpText: 'Select if you want the Object picklist to display all Standard and Custom Salesforce Objects.'},
        cb_displayAll: {value: null, valueDataType: null, isCollection: false, label: ''},
        recordTypeId: {value: null, valueDataType: null, isCollection: false, label: 'Record Type Id for Picklist Values',
            helpText: "Specify a Record Type Id value here to restrict the values in editable picklists to be only those supported by the specified Record Type. \n" +
            "This selection will apply to all records in the table no matter their individual Record Type."},
        allowNoneToBeChosen: {value: null, valueDataType: null, isCollection: false, label: 'Include a --None-- Picklist Option', 
            helpText: 'Select if you want editable picklist fields to include a --None-- (null) option. (default=true)'},
        cb_allowNoneToBeChosen: {value: CB_TRUE, valueDataType: null, isCollection: false, label: ''},
        allowOverflow: {value: null, valueDataType: null, isCollection: false, label: 'Allow table to overflow its container', 
            helpText: 'Select if you want the datatable to be able to overflow its container.  Useful when editing picklists on a table with only a few records.  Not recommended for wide tables in narrow containers'},
        cb_allowOverflow: {value: null, valueDataType: null, isCollection: false, label: ''},
        suppressCurrencyConversion: {value: null, valueDataType: null, isCollection: false, label: 'Suppress Currency Conversion', 
            helpText: 'In multi-currency orgs, suppress the default conversion of currency fields to the User\'s currency'},
        cb_suppressCurrencyConversion: {value: null, valueDataType: null, isCollection: false, label: ''},
        serializedRecordData: {value: null, valueDataType: null, isCollection: false, label: 'Input serialized data', 
            helpText: 'Select if you want the datatable to be able to accept serialized data.'},
        isSerializedRecordData: {value: null, valueDataType: null, isCollection: false, label: 'Input data is Serialized', 
            helpText: 'Select if you want the datatable to be able to accept serialized data.'},
        cb_isSerializedRecordData: {value: null, valueDataType: null, isCollection: false, label: ''},
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
                {name: 'displayAll'},
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
                {name: 'showRecordCount'},
                {name: 'tableBorder'},
            ]
        },
        {name: 'tableBehavior',
            attributes: [
                {name: 'isRequired'},
                {name: 'singleRowSelection'},                
                {name: 'hideCheckboxColumn'},
                {name: 'hideHeaderActions'},                
                {name: 'matchCaseOnFilters'},
                {name: 'hideClearSelectionButton'},
                {name: 'suppressBottomBar'},
                {name: 'navigateNextOnSave'},
                {name: 'not_suppressNameFieldLink'},
                {name: 'openLinkinSameTab'},
            ]
        },
        {name: 'advancedAttributes',
            attributes: [
                {name: 'isUserDefinedObject'},
                {name: 'isSerializedRecordData'},                                                                     // LY
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
                {name: 'recordTypeId'},
                {name: 'allowNoneToBeChosen'},
                {name: 'suppressCurrencyConversion'},
                {name: 'allowOverflow'},
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
        {name: 'wiz_columnCellAttribs', type: 'String', value: ''},
        {name: 'wiz_columnTypeAttribs', type: 'String', value: ''},
        {name: 'wiz_columnOtherAttribs', type: 'String', value: ''},
        {name: 'vWizRecordCount', type: 'String', value: ''},
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
    get automaticOutputVariables () {
        return this._automaticOutputVariables;
    }

    set automaticOutputVariables(value) {
        this._automaticOutputVariables = value;
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
        console.log('ers_datatableCPE - initializeValues');
        this.isCheckboxColumnHidden = false;
        this._inputVariables.forEach(curInputParam => {
            if (curInputParam.name && curInputParam.value != null) {
                console.log('Init:', curInputParam.name, curInputParam.valueDataType, curInputParam.value);             
                if (curInputParam.name && this.inputValues[curInputParam.name] != null) {

                    try {
                        this.inputValues[curInputParam.name].value = (curInputParam.valueDataType === 'reference') ? '{!' + curInputParam.value + '}' : decodeURIComponent(curInputParam.value);
                    }
                    catch(err) {    // Handle column label that includes a % character
                        this.inputValues[curInputParam.name].value = curInputParam.value
                    }
                    this.inputValues[curInputParam.name].valueDataType = curInputParam.valueDataType;

                    if (curInputParam.name == 'objectName') { 
                        this.selectedSObject = curInputParam.value;    
                    }
                    if (curInputParam.name == 'columnFields') { 
                        this.vFieldList = curInputParam.value;
                        this.updateFlowParam('vFieldList', this.vFieldList, null, defaults.NOENCODE);
                        this.createFieldCollection(this.vFieldList);
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
                    if ((curInputParam.name == 'hideCheckboxColumn') && curInputParam.value) {
                        this.isCheckboxColumnHidden = true;
                    }

                    // Handle Wizard Attributes
                    let wizName = defaults.wizardAttributePrefix + curInputParam.name;
                    if (this.flowParams.find(fp => fp.name == wizName)) {
                        this.updateFlowParam(wizName, this.inputValues[curInputParam.name].value, '');
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
            this.dispatchFlowValueChangeEvent('serializedRecordData', null, 'String');
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
        }
    }

    handleCheckboxChange(event) {
        if (event.target && event.detail) {
            let changedAttribute = event.target.name.replace(defaults.inputAttributePrefix, '');
            this.dispatchFlowValueChangeEvent(changedAttribute, event.detail.newValue, event.detail.newValueDataType);
            this.dispatchFlowValueChangeEvent(CB_PREFIX+changedAttribute, event.detail.newStringValue, 'String');

            // Handle isDisplayHeader
            if ((changedAttribute == 'isDisplayHeader') && this.isObjectSelected) {
                if (event.detail.newValue) { 
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

            // Handle displayALl
            if (changedAttribute == 'displayAll') {
                this.inputValues.objectName.value = null;
                this.selectedSObject = null;
                this.dispatchFlowValueChangeEvent('objectName',this.selectedSObject, 'String');
            }

            // Change the displayed Data Sources if the Apex Defined Object is selected
            if (changedAttribute == 'isUserDefinedObject') {
                this.isApexSelected = event.detail.newValue;
                if (event.detail.newValue) {
                    this.isDisplayAll = false;                          // Clear & Disable Display All Selection when selecting User Defined Object
                    if (this.inputValues.objectName.value == null) {    // Have to force Dynamic Type Mapping to avoid an error when trying to exit CPE
                        let typeValue = 'User';                         // Aribtrary Object just so we can dispatch the event
                        const typeName = this._elementType === "Screen" ? 'T' : 'T__record'; 
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
                    }
                }
                this.disableAllowAll = event.detail.newValue;
            }

            if (changedAttribute == 'isSerializedRecordData') {
                this.isSerializedSelected = event.detail.newValue;
                if (event.detail.newValue) {
                    this.isDisplayAll = false;                          
                    if (this.inputValues.objectName.value == null) {    // Have to force Dynamic Type Mapping to avoid an error when trying to exit CPE
                        let typeValue = 'Account';                         // Aribtrary Object just so we can dispatch the event
                        const typeName = this._elementType === "Screen" ? 'T' : 'T__record'; 
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
                    }
                }
            }

            // Don't allow hide the checkbox column if a selection is required
            if (changedAttribute == 'isRequired') {
                this.isShowCheckboxColumn = event.detail.newValue;
                if (this.isShowCheckboxColumn) {
                    this.updateCheckboxValue('hideCheckboxColumn', false);
                }
            }
            
            // Skip is required and single row options if the checkbox column is hidden
            if (changedAttribute == 'hideCheckboxColumn') { 
                this.isCheckboxColumnHidden = event.detail.newValue;
                this.updateCheckboxValue('isRequired', false);
                this.updateCheckboxValue('singleRowSelection', false);
            }

            // Don't allow Navigate Next on Save when bottom bar (Save button) is suppressed
            if (changedAttribute == 'suppressBottomBar') { 
                this.isDisableNavigateNext = event.detail.newValue;
                if (this.isDisableNavigateNext) {
                    this.updateCheckboxValue('navigateNextOnSave', false);
                }
            }            

            // Don't allow bottom bar to be suppressed when Navigate Next on Save is selected
            if (changedAttribute == 'navigateNextOnSave') { 
                this.isDisableSuppressBottomBar = event.detail.newValue;
                if (this.isDisableSuppressBottomBar) {
                    this.updateCheckboxValue('suppressBottomBar', false);
                }
            }     

        }

    }

    updateCheckboxValue(name, value) {
        this.inputValues[name].value = value;
        this.dispatchFlowValueChangeEvent(name, value, 'boolean');
        this.inputValues[CB_PREFIX+name].value = (value) ? CB_TRUE : CB_FALSE;
        this.dispatchFlowValueChangeEvent(CB_PREFIX+name, this.inputValues[CB_PREFIX+name].value, 'String');
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
            let newType = event.detail.newValueDataType;
            let newValue = event.detail.newValue;
            if (changedAttribute == 'maxNumberOfRows' && newType != 'reference') {
                newType = 'Number';
            }
            this.dispatchFlowValueChangeEvent(changedAttribute, newValue, newType);

            if (changedAttribute == 'columnEdits') {
                if (!newValue) {
                    this.updateCheckboxValue('suppressBottomBar', false);
                    this.updateCheckboxValue('navigateNextOnSave', false);
                    this.isNoEdits = true;
                } else {
                    this.isNoEdits = false;
                }
            }

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
        this.updateFlowParam('vWizRecordCount', CONSTANTS.WIZROWCOUNT);
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
                                    this.updateCheckboxValue('suppressBottomBar', false);
                                    this.updateCheckboxValue('navigateNextOnSave', false);
                                    this.isDisableSuppressBottomBar = true;
                                    this.isDisableNavigateNext = true;
                                }
                                break;
                            case 'columnFilters':
                                this.wiz_columnFilters = value;
                                this.isNoFilters = (value) ? false : true;
                                if (this.isNoFilters) {
                                    this.updateCheckboxValue('matchCaseOnFilters', false);
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
                            case 'columnCellAttribs': 
                                this.wiz_columnCellAttribs = value;
                                break;
                            case 'columnTypeAttribs': 
                                this.wiz_columnTypeAttribs = value;
                                break;
                            case 'columnOtherAttribs': 
                                this.wiz_columnOtherAttribs = value;
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
            this.checkError((!this.isRecordCollectionSelected && !this.inputValues.isSerializedRecordData.value), 'tableData', 'You must provide a Collection of Records to display');
            this.checkError((!this.vFieldList), 'columnFields', 'At least 1 column must be selected');
        }
        this.checkError(this.inputValues.isSerializedRecordData.value && this.inputValues.isUserDefinedObject.value, 'isSerializedRecordData', 'Select only one option (Input data is Apex-Defined or Input data is Serialized)');

        let allComboboxes = this.template.querySelectorAll('c-fsc_flow-combobox');
        if (allComboboxes) {
            allComboboxes.forEach(curCombobox => {
                if (!curCombobox.reportValidity()) {
                    resultErrors.push('error');
                    console.log('ComboBox Error:', error);
                }
            });
        }

        return this.validateErrors;
    }

    checkError(isError, key, errorString) {
        this.inputValues[key].class = 'slds-form-element';
        if (isError) { 
            this.validateErrors.push({key: key, errorString: errorString});
            this.inputValues[key].isError = true;
            this.inputValues[key].errorMessage = errorString;
            this.inputValues[key].class += ' slds-has-error';
            console.log('CPE generated error:', key, isError, errorString);
        } else { 
            this.inputValues[key].isError = false;
        }
    }

}