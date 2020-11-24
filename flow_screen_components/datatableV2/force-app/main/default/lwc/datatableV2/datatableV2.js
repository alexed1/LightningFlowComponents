/**
 * Lightning Web Component for Flow Screens:       datatableV2
 * 
 * VERSION:             2.48
 * 
 * RELEASE NOTES:       https://github.com/ericrsmith35/DatatableV2/blob/master/README.md
**/

const VERSION_NUMBER = 2.48;

import { LightningElement, api, track } from 'lwc';
import getReturnResults from '@salesforce/apex/SObjectController2.getReturnResults';
import { FlowAttributeChangeEvent } from 'lightning/flowSupport';

const MAXROWCOUNT = 1000;   // Limit the total number of records to be handled by this component
const ROUNDWIDTH = 5;       // Used to round off the column widths during Config Mode to nearest value

const reverse = str => str.split('').reverse().join('');    // Reverse all the characters in a string

// Get domain url by replacing the last occurance of '--c' in the current url
const MYDOMAIN = 'https://' + reverse(reverse(window.location.hostname.split('.')[0]).replace(reverse('--c'),''));

export default class DatatableV2 extends LightningElement {

    // Component Input & Output Attributes
    @api tableData = [];
    @api columnFields = [];
    @api columnAlignments = [];
    @api columnCellAttribs = [];
    @api columnEdits = '';
    @api columnFilters = '';
    @api columnIcons = [];
    @api columnLabels = [];
    @api columnOtherAttribs = [];
    @api columnTypeAttribs = [];
    @api columnWidths = [];
    @api columnWraps = [];
    @api keyField = 'Id';
    @api matchCaseOnFilters;
    @api maxNumberOfRows;
    @api preSelectedRows = [];
    @api numberOfRowsSelected = 0;
    @api isRequired;
    @api isConfigMode;
    @api hideCheckboxColumn;
    @api singleRowSelection;
    @api suppressBottomBar = false;
    @api suppressNameFieldLink = false;
    @api tableHeight;
    @api outputSelectedRows = [];
    @api outputSelectedRow;
    @api outputEditedRows = [];
    @api tableBorder;
    @api isDisplayHeader;                   // Only referenced in the CPE
    @api tableIcon;
    @api tableLabel;
    @api not_tableBorder = false;           // Only referenced in the CPE - Used so a boolean value can default to True
    @api not_suppressNameFieldLink;         // Only referenced in the CPE - Used so a boolean value can default to True

    // JSON Version Attributes (User Defined Object)
    @api isUserDefinedObject = false;
    @api tableDataString = [];
    @api preSelectedRowsString = [];
    @api outputSelectedRowsString = '';
    @api outputEditedRowsString = '';
    @api columnScales = [];
    @api columnTypes = [];
    @api scaleAttrib = [];
    @api typeAttrib = [];
    
    // Configuration Wizard Only - Input Attributes
    @api objectName;

    // Configuration Wizard Only - Output Attributes
    @api wizSObject;
    @api wizColumnFields;
    @api wizColumnAlignments;
    @api wizColumnEdits;
    @api wizColumnFilters;
    @api wizColumnLabels;
    @api wizColumnIcons;
    @api wizColumnWidths;
    @api wizColumnWraps;

    // JSON Version Variables
    @api scales = [];
    @api types = [];
        
    // Other Datatable attributes
    @api sortedBy;
    @api sortDirection; 
    @api maxRowSelection;
    @api errors;
    @api columnWidthValues;
    @track columns = [];
    @track mydata = [];
    @track selectedRows = [];
    @track roundValueLabel;
    @track columnWidthsLabel;
    @track isAllEdit = false;
    @track isAllFilter = false;
    @track showClearButton = false;
    @track tableHeightAttribute = 'height:';

    // Handle Lookup Field Variables   
    @api lookupId;
    @api objectNameLookup;
    @api objectLinkField;
    @track lookupName;

    // Column Filter variables
    @api filterColumns;
    @api columnFilterValues = [];
    @api columnType;
    @api columnNumber;
    @api baseLabel;
    @api isFiltered;
    @api saveOriginalValue;
    @track columnFilterValue = null;
    @track columnIconValue = null;
    @track isOpenFilterInput = false;
    @track isOpenIconInput = false;
    @track inputLabel;
    @track inputType = 'text';
    @track inputFormat = null;    

    // Component working variables
    @api savePreEditData = [];
    @api editedData = [];
    @api outputData = [];
    @api errorApex;
    @api dtableColumnFieldDescriptorString;
    @api lookupFieldDataString;
    @api basicColumns = [];
    @api lookupFieldArray = [];
    @api columnArray = [];
    @api percentFieldArray = [];
    @api noEditFieldArray = [];
    @api timeFieldArray = [];
    @api picklistFieldArray = [];
    @api picklistReplaceValues = false;
    @api picklistFieldMap = [];
    @api picklistMap = [];
    @api edits = [];
    @api isEditAttribSet = false;
    @api editAttribType = 'none';
    @api filters = [];
    @api filterAttribType = 'none';
    @api alignments = [];
    @api cellAttribs = [];
    @api cellAttributes;
    @api icons = [];
    @api labels = [];
    @api otherAttribs = [];
    @api typeAttribs = [];
    @api typeAttributes;
    @api widths = [];
    @api wraps = [];
    @api lookups = [];
    @api cols = [];
    @api attribCount = 0;
    @api recordData = [];
    @api timezoneOffset = 0;
    @track isInvalid = false;
    @track isWorking = false;
    @track showSpinner = true;
    @track borderClass;
    @track columnFieldParameter;
    @track columnAlignmentParameter;
    @track columnLabelParameter;
    @track columnWidthParameter;
    @track columnWrapParameter;
    @track columnEditParameter;
    @track columnFilterParameter;

    get formElementClass() {
        return this.isInvalid ? 'slds-form-element slds-has-error' : 'slds-form-element';
    }

    get requiredSymbol() {
        return this.isRequired ? '*' : '';
    }

    get hasIcon() {
        return (this.tableIcon && this.tableIcon.length > 0);
    }

    get formattedTableLabel() {
        return (this.tableLabel && this.tableLabel.length > 0) ? '<h2>&nbsp;'+this.tableLabel+'</h2>' : '';
    }

    connectedCallback() {

        // Display the component version number in the console log
        const logStyleText = 'color: green; font-size: 16px';
        const logStyleNumber = 'color: red; font-size: 16px';
        console.log("%cdatatableV2 VERSION_NUMBER: %c"+VERSION_NUMBER, logStyleText, logStyleNumber);
        console.log('MYDOMAIN', MYDOMAIN);

        // Decode config mode attributes
        if (this.isConfigMode) { 
            this.columnAlignments = decodeURIComponent(this.columnAlignments);
            this.columnEdits = decodeURIComponent(this.columnEdits);
            this.columnFilters = decodeURIComponent(this.columnFilters);
            this.columnIcons = decodeURIComponent(this.columnIcons);
            this.columnLabels = decodeURIComponent(this.columnLabels);
            this.columnWidths = decodeURIComponent(this.columnWidths);
            this.columnWraps = decodeURIComponent(this.columnWraps);
            this.columnFields = decodeURIComponent(this.columnFields);
            console.log("Config Mode Input columnAlignments:", this.columnAlignments);
            console.log("Config Mode Input columnEdits:", this.columnEdits);
            console.log("Config Mode Input columnFilters:", this.columnFilters);
            console.log("Config Mode Input columnIcons:", this.columnIcons);
            console.log("Config Mode Input columnLabels:", this.columnLabels);
            console.log("Config Mode Input columnWidths:", this.columnWidths);
            console.log("Config Mode Input columnWraps:", this.columnWraps);
            console.log("Config Mode Input columnFields:", this.columnFields);
            this.suppressNameFieldLink = true;
        }

        // JSON input attributes
        if (this.isUserDefinedObject) {
            console.log('tableDataString - ',this.tableDataString);
            if (this.tableDataString.length == 0) {
                this.tableDataString = '[{"'+this.keyField+'":"(empty table)"}]';
                this.columnFields = this.keyField;
                this.columnTypes = [];
                this.columnScales = [];
            }
            this.tableData = JSON.parse(this.tableDataString);
            console.log('tableData - ',this.tableData);    
            this.preSelectedRows = (this.preSelectedRowsString.length > 0) ? JSON.parse(this.preSelectedRowsString) : [];  
        }

        // Restrict the number of records handled by this component
        let min = Math.min(MAXROWCOUNT, this.maxNumberOfRows);
        if (this.tableData.length > min) {
            this.tableData = [...this.tableData].slice(0,min);
        }

        // Set roundValue for setting Column Widths in Config Mode
        this.roundValueLabel = `Snap each Column Width to the Nearest ${ROUNDWIDTH} pixel Boundary`;

        // Get array of column field API names
        this.columnArray = (this.columnFields.length > 0) ? this.columnFields.replace(/\s/g, '').split(',') : [];
        this.columnFieldParameter = this.columnArray.join(', ');
        console.log('columnArray - ',this.columnArray);  

        // JSON Version - Build basicColumns default values
        if (this.isUserDefinedObject) {
            this.columnArray.forEach(field => {
                this.basicColumns.push({
                    label: field,
                    fieldName: field,
                    type: 'richtext',
                    scale: 0
                });
            });       
        }

        // Parse Column Alignment attribute
        const parseAlignments = (this.columnAlignments.length > 0) ? this.columnAlignments.replace(/\s/g, '').split(',') : [];
        this.attribCount = (parseAlignments.findIndex(f => f.search(':') != -1) != -1) ? 0 : 1;
        parseAlignments.forEach(align => {
            this.alignments.push({
                column: this.columnReference(align),
                alignment: this.columnValue(align)
            });
        });

        // Parse Column Edit attribute
        if (this.columnEdits.toLowerCase() != 'all') {
            const parseEdits = (this.columnEdits.length > 0) ? this.columnEdits.replace(/\s/g, '').split(',') : [];
            this.attribCount = (parseEdits.findIndex(f => f.search(':') != -1) != -1) ? 0 : 1;
            this.editAttribType = 'none';
            parseEdits.forEach(edit => {
                let colEdit = (this.columnValue(edit).toLowerCase() == 'true') ? true : false;
                this.edits.push({
                    column: this.columnReference(edit),
                    edit: colEdit
                });
                this.editAttribType = 'cols';
            });
        } else {
            this.editAttribType = 'all';
            this.isAllEdit = true;
        }

        // Parse Column Filter attribute
        if (this.columnFilters.toLowerCase() != 'all') {
            const parseFilters = (this.columnFilters.length > 0) ? this.columnFilters.replace(/\s/g, '').split(',') : [];
            this.attribCount = (parseFilters.findIndex(f => f.search(':') != -1) != -1) ? 0 : 1;
            this.filterAttribType = 'none';
            parseFilters.forEach(filter => {
                let colFilter = (this.columnValue(filter).toLowerCase() == 'true') ? true : false;
                let col = this.columnReference(filter);
                this.filters.push({
                    column: col,
                    filter: colFilter,
                    actions: [
                        {label: 'Set Filter', disabled: false, name: 'filter_' + col, iconName: 'utility:filter'},
                        {label: 'Clear Filter', disabled: true, name: 'clear_' + col, iconName: 'utility:clear'}
                    ]
                });
                this.filterAttribType = 'cols';
            });
        } else {
            this.filterAttribType = 'all';
            this.isAllFilter = true;
        }

        // Parse Column Icon attribute
        const parseIcons = (this.columnIcons.length > 0) ? this.columnIcons.replace(/\s/g, '').split(',') : [];
        this.attribCount = (parseIcons.findIndex(f => f.search(':') != -1) != -1) ? 0 : 1;
        parseIcons.forEach(icon => {
            this.icons.push({
                column: this.columnReference(icon),
                icon: this.columnValue(icon)
            });
        });

        // Parse Column Label attribute
        const parseLabels = (this.columnLabels.length > 0) ? this.removeSpaces(this.columnLabels).split(',') : [];
        this.attribCount = (parseLabels.findIndex(f => f.search(':') != -1) != -1) ? 0 : 1;
        parseLabels.forEach(label => {
            this.labels.push({
                column: this.columnReference(label),
                label: this.columnValue(label)
            });
        });

        if (this.isUserDefinedObject) {

            // JSON Version - Parse Column Scale attribute
            const parseScales = (this.columnScales.length > 0) ? this.removeSpaces(this.columnScales).split(',') : [];
            this.attribCount = (parseScales.findIndex(f => f.search(':') != -1) != -1) ? 0 : 1;
            parseScales.forEach(scale => {
                this.scales.push({
                    column: this.columnReference(scale),
                    scale: this.columnValue(scale)
                });
                this.basicColumns[this.columnReference(scale)].scale = this.columnValue(scale);
            });

            // JSON Version - Parse Column Type attribute
            const parseTypes = (this.columnTypes.length > 0) ? this.removeSpaces(this.columnTypes).split(',') : [];
            this.attribCount = (parseTypes.findIndex(f => f.search(':') != -1) != -1) ? 0 : 1;
            parseTypes.forEach(type => {
                this.types.push({
                    column: this.columnReference(type),
                    type: this.columnValue(type)
                });
                this.basicColumns[this.columnReference(type)].type = this.columnValue(type);
            });
        }

        // Parse Column Width attribute
        const parseWidths = (this.columnWidths.length > 0) ? this.columnWidths.replace(/\s/g, '').split(',') : [];
        this.attribCount = (parseWidths.findIndex(f => f.search(':') != -1) != -1) ? 0 : 1;
        parseWidths.forEach(width => {
            this.widths.push({
                column: this.columnReference(width),
                width: parseInt(this.columnValue(width))
            });
        });

        // Parse Column Wrap attribute
        const parseWraps = (this.columnWraps.length > 0) ? this.columnWraps.replace(/\s/g, '').split(',') : [];
        this.attribCount = (parseWraps.findIndex(f => f.search(':') != -1) != -1) ? 0 : 1;
        parseWraps.forEach(wrap => {
            this.wraps.push({
                column: this.columnReference(wrap),
                wrap: (this.columnValue(wrap).toLowerCase() == 'true') ? true : false
            });
        });

        // Parse Column CellAttribute attribute (Because multiple attributes use , these are separated by ;)
        const parseCellAttribs = (this.columnCellAttribs.length > 0) ? this.removeSpaces(this.columnCellAttribs).split(';') : [];
        this.attribCount = 0;   // These attributes must specify a column number or field API name
        parseCellAttribs.forEach(cellAttrib => {
            this.cellAttribs.push({
                column: this.columnReference(cellAttrib),
                attribute: this.columnValue(cellAttrib)
            });
        });

        // Parse Column Other Attributes attribute (Because multiple attributes use , these are separated by ;)
        const parseOtherAttribs = (this.columnOtherAttribs.length > 0) ? this.removeSpaces(this.columnOtherAttribs).split(';') : [];
        this.attribCount = 0;   // These attributes must specify a column number or field API name
        parseOtherAttribs.forEach(otherAttrib => {
            this.otherAttribs.push({
                column: this.columnReference(otherAttrib),
                attribute: this.columnValue(otherAttrib)
            });
        });

        // Parse Column TypeAttribute attribute (Because multiple attributes use , these are separated by ;)
        const parseTypeAttribs = (this.columnTypeAttribs.length > 0) ? this.removeSpaces(this.columnTypeAttribs).split(';') : [];
        this.attribCount = 0;   // These attributes must specify a column number or field API name
        parseTypeAttribs.forEach(ta => {
            this.typeAttribs.push({
                column: this.columnReference(ta),
                attribute: this.columnValue(ta)
            });
        });

        // Set table height
        this.tableHeightAttribute = 'height:' + this.tableHeight;
        console.log('tableHeightAttribute',this.tableHeightAttribute);

        // Set table border display
        this.borderClass = (this.tableBorder != false) ? 'slds-box' : '';

        // Generate datatable
        if (this.tableData) {

            // Set other initial values here
            this.maxRowSelection = (this.singleRowSelection) ? 1 : this.tableData.length;
            this.wizColumnFields = this.columnFields;

            console.log('Processing Datatable');
            this.processDatatable();

        } else {
            this.showSpinner = false;
        }

        // Handle pre-selected records
        this.outputSelectedRows = this.preSelectedRows;
        this.updateNumberOfRowsSelected(this.outputSelectedRows);
        if (this.isUserDefinedObject) {
            this.outputSelectedRowsString = JSON.stringify(this.outputSelectedRows);                                        //JSON Version
            this.dispatchEvent(new FlowAttributeChangeEvent('outputSelectedRowsString', this.outputSelectedRowsString));    //JSON Version
        } else {
            this.dispatchEvent(new FlowAttributeChangeEvent('outputSelectedRows', this.outputSelectedRows));
        }    
        const selected = JSON.parse(JSON.stringify([...this.preSelectedRows]));
        selected.forEach(record => {
            this.selectedRows.push(record[this.keyField]);            
        });

    }

    removeSpaces(string) {
        return string
            .replace(/, | ,/g,',')
            .replace(/: | :/g,':')
            .replace(/{ | {/g,'{')
            .replace(/} | }/g,'}')
            .replace(/; | ;/g,';');
    }

    columnReference(attrib) {
        // The column reference can be either the field API name or the column sequence number (1,2,3 ...)
        // If no column reference is specified, the values are assigned to columns in order (There must be a value provided for each column)
        // Return the actual column # (0,1,2 ...)
        let colRef = 0;
        if (this.attribCount == 0) {
            let colDescriptor = attrib.split(':')[0];
            colRef = Number(colDescriptor)-1;
            if (isNaN(colRef)) {
                colRef = this.columnArray.indexOf(colDescriptor);
                colRef = (colRef != -1) ? colRef : 999; // If no match for the field name, set to non-existent column #
            }
        } else {
            colRef = this.attribCount-1;
            this.attribCount += 1;
        }
        return colRef;
    }

    columnValue(attrib) {
        // Extract the value from the column attribute
        return attrib.slice(attrib.search(':')+1);
    }

    processDatatable() {
        if (this.isUserDefinedObject && !this.isConfigMode) {

            // JSON Version set recordData
            this.recordData = [...this.tableData];

            // JSON Version Special Field Types
            this.types.forEach(t => {
                switch(t.type) {
                    case 'percent':
                        this.percentFieldArray.push(this.basicColumns[t.column].fieldName);
                        this.basicColumns[t.column].type = 'percent';
                        break;
                    case 'time':
                        this.timeFieldArray.push(this.basicColumns[t.column].fieldName);
                        this.basicColumns[t.column].type = 'time';
                        break;
                    case 'lookup':
                        this.lookupFieldArray.push(this.basicColumns[t.column].fieldName);
                        this.lookups.push(this.basicColumns[t.column].fieldName); 
                        this.basicColumns[t.column].type = 'lookup';         
                        break;
                    case 'richtext':
                        this.lookupFieldArray.push(this.basicColumns[t.column].fieldName);
                        this.lookups.push(this.basicColumns[t.column].fieldName); 
                        this.basicColumns[t.column].type = 'richtext';         
                }
            });

            // Update row data for lookup, time and percent fields
            this.updateDataRows();

            // Custom column processing
            this.updateColumns();

            if(this.cols[0].fieldName.endsWith('_lookup')) {
                this.sortedBy = this.cols[0].fieldName;
                this.doSort(this.sortedBy, 'asc');
            }

            // Done processing the datatable
            this.showSpinner = false;

        } else {

            // Call Apex Controller and get Column Definitions and update Row Data
            let data;
            if (!this.isUserDefinedObject) {
                data = (this.tableData) ? JSON.parse(JSON.stringify([...this.tableData])) : [];
            } else { 
                data = (this.tableData) ? JSON.parse(this.tableDataString) : [];
                data.forEach(record => { 
                    delete record['attributes'];    // When running the Column Wizard, clean up the record string before getting the field details from SObjectController2
                });
            }

            let fieldList = (this.columnFields.length > 0) ? this.columnFields.replace(/\s/g, '') : ''; // Remove spaces
            console.log('Passing data to Apex Controller', data);
            getReturnResults({ records: data, fieldNames: fieldList })
            .then(result => {
                let returnResults = JSON.parse(result);

                // Assign return results from the Apex callout
                this.recordData = [...returnResults.rowData];
                this.lookups = returnResults.lookupFieldList;
                this.percentFieldArray = (returnResults.percentFieldList.length > 0) ? returnResults.percentFieldList.toString().split(',') : [];
                this.timeFieldArray = (returnResults.timeFieldList.length > 0) ? returnResults.timeFieldList.toString().split(',') : [];
                this.picklistFieldArray = (returnResults.picklistFieldList.length > 0) ? returnResults.picklistFieldList.toString().split(',') : [];
                this.picklistReplaceValues = (this.picklistFieldArray.length > 0);  // Flag value dependent on if there are any picklists in the datatable field list  
                this.picklistFieldMap = returnResults.picklistFieldMap;
                this.objectNameLookup = returnResults.objectName;
                this.objectLinkField = returnResults.objectLinkField;
                this.lookupFieldArray = JSON.parse('[' + returnResults.lookupFieldData + ']');
                this.timezoneOffset = returnResults.timezoneOffset.replace(/,/g, '');

                // Check for differences in picklist API Values vs Labels
                if (this.picklistReplaceValues) {
                    let noMatch = false;
                    this.picklistFieldArray.forEach(picklist => {
                        Object.keys(this.picklistFieldMap[picklist]).forEach(map => {                         
                            if (map != this.picklistFieldMap[picklist][map]) {                              
                                noMatch = true;
                            }
                        });
                    });
                    this.picklistReplaceValues = noMatch;
                }

                // Basic column info (label, fieldName, type) taken from the Schema in Apex
                this.dtableColumnFieldDescriptorString = '[' + returnResults.dtableColumnFieldDescriptorString + ']';
                this.basicColumns = JSON.parse(this.dtableColumnFieldDescriptorString);
                console.log('dtableColumnFieldDescriptorString',this.dtableColumnFieldDescriptorString,this.basicColumns);
                this.noEditFieldArray = (returnResults.noEditFieldList.length > 0) ? returnResults.noEditFieldList.toString().split(',') : [];
                
                // Update row data for lookup, time, picklist and percent fields
                this.updateDataRows();

                // Custom column processing
                this.updateColumns();

                // Pass object name back to wizard
                this.wizSObject = this.objectNameLookup;

                // Done processing the datatable
                this.showSpinner = false;

            })  // Handle any errors from the Apex Class
            .catch(error => {
                console.log('getReturnResults error is: ' + JSON.stringify(error));
                if (error.body) {
                    this.errorApex = 'Apex Action error: ' + error.body.message;
                    alert(this.errorApex + '\n');  // Present the error to the user
                }
                this.showSpinner = false;
                return this.errorApex; 
            });

        }
        
    }

    updateDataRows() {
        // Process Incoming Data Collection
        console.log('Processing updateDataRows')
        let data = (this.recordData) ? JSON.parse(JSON.stringify([...this.recordData])) : [];
        let lookupFields = this.lookups;
        let lufield = '';
        let timeFields = this.timeFieldArray;
        let percentFields = this.percentFieldArray;
        let picklistFields = this.picklistFieldArray;
        let lookupFieldObject = '';

        data.forEach(record => {

            // Prepend a date to the Time field so it can be displayed and calculate offset based on User's timezone
            timeFields.forEach(time => {
                if (record[time]) {
                    record[time] = "2020-05-12T" + record[time];
                    let dt = Date.parse(record[time]);
                    let d = new Date();
                    record[time] = d.setTime(Number(dt) - Number(this.timezoneOffset));
                }
            });

            // Store percent field data as value/100
            percentFields.forEach(pct => {
                record[pct] = record[pct]/100;
            });

            // Flatten returned data
            lookupFields.forEach(lookup => {
                if (this.isUserDefinedObject) {
                    lufield = lookup;
                    record[lufield + '_lookup'] = MYDOMAIN + record[lufield + '_lookup'];                    
                } else {
                    if(lookup.toLowerCase().endsWith('id')) {
                        lufield = lookup.replace(/Id$/gi,'');
                    } else {
                        lufield = lookup.replace(/__c$/gi,'__r');
                    }

                    // Get the lookup field details
                    lookupFieldObject = this.lookupFieldArray.filter(obj => Object.keys(obj).some(key => obj[key].includes(lufield)))[0];

                    if (record[lufield]) {               
                        record[lufield + '_name'] = record[lufield][lookupFieldObject['nameField']];
                        record[lufield + '_id'] = record[lufield]['Id'];
                        // Add new column with correct Lookup urls
                        record[lufield + '_lookup'] = MYDOMAIN + '.lightning.force.com/lightning/r/' + lookupFieldObject['object'] + '/' + record[lufield + '_id'] + '/view';
                    }
                }
            }); 
            
            // Handle Lookup for the SObject's "Name" Field
            record[this.objectLinkField + '_name'] = record[this.objectLinkField];
            record[this.objectLinkField + '_lookup'] = MYDOMAIN + '.lightning.force.com/lightning/r/' + this.objectNameLookup + '/' + record['Id'] + '/view';

            // Handle replacement of Picklist API Names with Labels
            if (this.picklistReplaceValues) {
                picklistFields.forEach(picklist => {
                    if (record[picklist]) {
                        let picklistLabels = [];
                        record[picklist].split(';').forEach(picklistValue => {                    
                            picklistLabels.push(this.picklistFieldMap[picklist][picklistValue]);
                        });
                        record[picklist] = picklistLabels.join(';');
                    }
                });
            }

            // If needed, add more fields to datatable records
            // (Useful for Custom Row Actions/Buttons)
            // record['addField'] = 'newValue';

        });

        // Set table data attributes
        this.mydata = [...data];
        this.savePreEditData = [...this.mydata];
        this.editedData = JSON.parse(JSON.stringify([...this.tableData]));  // Must clone because cached items are read-only
        console.log('selectedRows',this.selectedRows);
        console.log('keyField:',this.keyField);
        console.log('tableData',this.tableData);
        console.log('mydata:',this.mydata);
    }

    updateColumns() {
        // Parse column definitions
        console.log('Processing updateColumns')
        this.cols = [];
        let columnNumber = 0;
        let lufield = '';

        this.basicColumns.forEach(colDef => {

            // Standard parameters
            let label = colDef['label'];
            let fieldName = colDef['fieldName'];
            let type = colDef['type'];
            let scale = colDef['scale'];
            this.cellAttributes = {};
            this.typeAttributes = {};
            let alignment = '';
            let editAttrib = [];
            let filterAttrib = [];
            let widthAttrib = [];
            let wrapAttrib = [];
            this.typeAttrib.type = type;          

            // Update Alignment attribute overrides by column
            let alignmentAttrib = this.alignments.find(i => i['column'] == columnNumber);
            if (alignmentAttrib) {
                alignment = alignmentAttrib.alignment.toLowerCase();              
                switch (alignment) {
                    case 'left':
                    case 'center':
                    case 'right':
                        break;
                    default:
                        alignment = 'left';
                }
                this.cellAttributes = { alignment:alignment };
            }

            // Update Edit attribute overrides by column
            switch (this.editAttribType) {
                case 'cols':
                    editAttrib = this.edits.find(i => i['column'] == columnNumber);
                    break;
                case 'all': 
                    editAttrib.edit = true;
                    break;
                default:
                    editAttrib.edit = false;
            }

            // Some data types are not editable
            if(editAttrib) {
                switch (type) {
                    case 'location':
                    case 'lookup':
                    case 'time':
                        editAttrib.edit = false;
                        break;
                    case 'text':
                        if (this.noEditFieldArray.indexOf(fieldName) != -1) editAttrib.edit = false;
                        break;
                    default:                       
                }
                if (!editAttrib.edit) { 
                    this.isAllEdit = false;
                }
            }

            // Update Filter attribute overrides by column
            switch (this.filterAttribType) {
                case 'cols':
                    filterAttrib = this.filters.find(i => i['column'] == columnNumber);
                    if (!filterAttrib) {
                        filterAttrib = [];
                        filterAttrib.filter = false;
                    }
                    break;
                case 'all':
                    filterAttrib.column = columnNumber; 
                    filterAttrib.filter = true;
                    filterAttrib.actions = [
                        {label: 'Set Filter', disabled: false, name: 'filter_' + columnNumber, iconName: 'utility:filter'},
                        {label: 'Clear Filter', disabled: true, name: 'clear_' + columnNumber, iconName: 'utility:clear'}
                    ]; 
                    break;
                default:
                    filterAttrib.filter = false;
            }

            // Some data types are not filterable
            if(filterAttrib) {
                switch (type) {
                    case 'location':
                        filterAttrib.filter = false;
                        this.isAllFilter = false;
                        break;
                    default:
                }
            }

            if (this.isConfigMode) { 
                let wizardAlignLeft = (!alignmentAttrib) ? (this.convertType(type) != 'number') : (alignment == 'left');
                let wizardAlignCenter = (!alignmentAttrib) ? false : (alignment == 'center');
                let wizardAlignRight = (!alignmentAttrib) ? (this.convertType(type) == 'number') : (alignment == 'right');
                let wizardEdit = (!editAttrib) ? false : (editAttrib.edit || false);
                let wizardFilter = filterAttrib.filter || false;             
                filterAttrib.column = columnNumber; 
                filterAttrib.filter = true;             
                filterAttrib.actions = [
                    {label: 'Align Left', checked: wizardAlignLeft, name: 'alignl_' + columnNumber, iconName: 'utility:left_align_text'},
                    {label: 'Align Center', checked: wizardAlignCenter, name: 'alignc_' + columnNumber, iconName: 'utility:center_align_text'},
                    {label: 'Align Right', checked: wizardAlignRight, name: 'alignr_' + columnNumber, iconName: 'utility:right_align_text'},
                    {label: 'Select Icon', disabled: false, name: 'icon_' + columnNumber, iconName: 'utility:text'},
                    {label: 'Change Label', disabled: false, name: 'label_' + columnNumber, iconName: 'utility:text'},
                    {label: 'Cancel Change', disabled: true, name: 'clear_' + columnNumber, iconName: 'utility:clear'},
                    {label: 'Allow Edit', checked: wizardEdit, name: 'aedit_' + columnNumber, iconName: 'utility:edit'},
                    {label: 'Allow Filter', checked: wizardFilter, name: 'afilter_' + columnNumber, iconName: 'utility:filter'}
                ];
                this.cellAttributes = { alignment: alignment };
            }

            // Update Icon attribute overrides by column
            let iconAttrib = this.icons.find(i => i['column'] == columnNumber);

            // Update Label attribute overrides by column
            let labelAttrib = this.labels.find(i => i['column'] == columnNumber);

            if (this.isUserDefinedObject) {
                // JSON Version - Update Scale attribute overrides by column
                this.scaleAttrib = this.scales.find(i => i['column'] == columnNumber);
                if (!this.scaleAttrib) {
                    this.scaleAttrib = [];
                    this.scaleAttrib.scale = scale;
                }

                // JSON Version - Update Type attribute overrides by column
                if(type != 'lookup') {
                    this.typeAttrib = this.types.find(i => i['column'] == columnNumber);
                    if (!this.typeAttrib) {
                        this.typeAttrib = [];
                        this.typeAttrib.type = type;
                    }
                }
            }

            // Update Width attribute overrides by column
            widthAttrib = this.widths.find(i => i['column'] == columnNumber);

            // Update Wrap attribute overrides by column
            wrapAttrib = this.wraps.find(i => i['column'] == columnNumber);

            // Set default typeAttributes based on data type
            switch(type) {
                case 'date':
                case 'date-local':
                    this.typeAttributes = { year:'numeric', month:'numeric', day:'numeric' }
                    break;
                case 'datetime':
                    type = 'date';
                    this.typeAttrib.type = type;
                    this.typeAttributes = { year:'numeric', month:'numeric', day:'numeric', hour:'2-digit', minute:'2-digit', timeZoneName:'short' };
                    break;           
                case 'time':
                    type = 'date';
                    this.typeAttrib.type = type;
                    this.typeAttributes = { hour:'2-digit', minute:'2-digit', timeZoneName:'short' };
                    break;
                case 'currency':
                case 'number':
                case 'percent':
                    if (this.isUserDefinedObject) {
                        let minDigits = (this.scaleAttrib) ? this.scaleAttrib.scale : scale;
                        this.typeAttributes = { minimumFractionDigits: minDigits };      // JSON Version
                    } else {
                        this.typeAttributes = { minimumFractionDigits:scale };   // Show the number of decimal places defined for the field
                    }
                    break;
                case 'richtext':
                    this.typeAttrib.type = 'richtext';
                    break;
                default:
                    
            }

            // Change lookup to url and reference the new fields that will be added to the datatable object
            if(type == 'lookup') {
                if(this.lookups.includes(fieldName)) {
                    this.typeAttrib.type = 'url';
                    if(fieldName.toLowerCase().endsWith('id')) {
                        lufield = fieldName.replace(/Id$/gi,'');
                    } else {
                        lufield = fieldName.replace(/__c$/gi,'__r');
                    }
                    fieldName = lufield + '_lookup';
                    this.typeAttributes = { label: { fieldName: lufield + '_name' }, target: '_blank' };
                } else {
                    this.typeAttrib.type = 'text';      // Non reparentable Master-Detail fields are not supported
                }
            }

            // Switch the SObject's "Name" Field to a Lookup
            if (fieldName == this.objectLinkField && !this.suppressNameFieldLink) {
                this.typeAttrib.type = 'url';
                fieldName = fieldName + '_lookup';
                this.typeAttributes = { label: { fieldName: this.objectLinkField }, target: '_blank' };
                this.cellAttributes.wrapText = true;
            }

            // Update CellAttribute attribute overrides by column
            this.parseAttributes('cell',this.cellAttribs,columnNumber);

            // Update TypeAttribute attribute overrides by column
            this.parseAttributes('type',this.typeAttribs,columnNumber);

            // Save the updated column definitions
            this.cols.push({
                label: (labelAttrib) ? labelAttrib.label : label,
                iconName: (iconAttrib) ? iconAttrib.icon : null,
                fieldName: fieldName,
                type: this.typeAttrib.type,
                cellAttributes: this.cellAttributes,
                typeAttributes: this.typeAttributes,
                editable: (editAttrib) ? editAttrib.edit : false,
                actions: (filterAttrib.filter) ? filterAttrib.actions : null,
                sortable: (this.isConfigMode) ? false : true,
                initialWidth: (widthAttrib) ? widthAttrib.width : null,
                wrapText: (wrapAttrib) ? wrapAttrib.wrap : false
            });
            console.log('this.cols',this.cols);

            // Update Other Attributes attribute overrides by column
            this.parseAttributes('other',this.otherAttribs,columnNumber);

            // Repeat for next column
            columnNumber += 1;
        });
        this.columns = this.cols;

    }

    parseAttributes(propertyType,inputAttributes,columnNumber) {
        // Parse regular and nested name:value attribute pairs
        let result = [];
        let fullAttrib = inputAttributes.find(i => i['column'] == columnNumber);
        if (fullAttrib) {
            let attribSplit = this.removeSpaces(fullAttrib.attribute.slice(1,-1)).split(',');
            attribSplit.forEach(ca => {
                let subAttribPos = ca.search('{');
                if (subAttribPos != -1) {
                    // This attribute value has another attribute object definition {name: {name:value}}
                    let value = {};
                    let name = ca.split(':')[0];
                    let attrib = ca.slice(subAttribPos).slice(1,-1);
                    let rightName = attrib.split(':')[0];
                    let rightValue = attrib.slice(attrib.search(':')+1);
                    value[rightName] = rightValue.replace(/["']{1}/gi,"");  // Remove single or double quotes
                    result['name'] = name;
                    result['value'] = value;
                } else {
                    // This is a standard attribute definition {name:value}
                    let attrib = ca.split(':');
                    result['name'] = attrib[0];
                    attrib.shift();
                    result['value'] = attrib.join(':').replace(/["']{1}/gi,"");  // Remove single or double quotes;                           
                }

                switch(propertyType) {
                    case 'cell':
                        this.cellAttributes[result['name']] = result['value'];
                        break;
                    case 'type':
                        this.typeAttributes[result['name']] = result['value'];
                        break;
                    default: // 'other'
                        this.cols[columnNumber][result['name']] = result['value'];
                }
            });
        }    
    }

    handleRowAction(event) {
        // Process the row actions here
        const action = event.detail.action;
        const row = JSON.parse(JSON.stringify(event.detail.row));
        const keyValue = row[this.keyField];
        this.mydata = this.mydata.map(rowData => {
            if (rowData[this.keyField] === keyValue) {
                switch (action.name) {
                    // case 'action': goes here
                        //
                        // break;
                    default:
                }
            }
            return rowData;
        });
    }

    handleCellChange(event) {
        // If suppressBottomBar is false, wait for the Save or Cancel button
        if (this.suppressBottomBar) {
            this.handleSave(event);
        }
    }

    handleSave(event) {
        // Only used with inline editing
        const draftValues = event.detail.draftValues;

        // Apply drafts to mydata
        let data = [...this.mydata];
        data = data.map(item => {
            const draft = draftValues.find(d => d[this.keyField] == item[this.keyField]);
            if (draft != undefined) {
                let fieldNames = Object.keys(draft);
                fieldNames.forEach(el => item[el] = draft[el]);
            }
            return item;
        });

        // Apply drafts to editedData
        let edata = [...this.editedData];
        edata = edata.map(eitem => {
            const edraft = draftValues.find(d => d[this.keyField] == eitem[this.keyField]);
            if (edraft != undefined) {
                let efieldNames = Object.keys(edraft);
                efieldNames.forEach(ef => {
                    // if(this.percentFieldArray.indexOf(ef) != -1) {
                    //     eitem[ef] = Number(edraft[ef])*100; // Percent field
                    // }
                    eitem[ef] = edraft[ef];
                });

                // Add/update edited record to output collection
                const orecord = this.outputEditedRows.find(o => o[this.keyField] == eitem[this.keyField]);   // Check to see if already in output collection      
                if (orecord) {
                    const otherEditedRows = [];
                    this.outputEditedRows.forEach(er => {   // Remove current row so it can be replaced with the new edits
                        if (er[this.keyField] != eitem[this.keyField]) {
                            otherEditedRows.push(er);
                        }
                    });
                    this.outputEditedRows = [...otherEditedRows];
                } 
                this.outputEditedRows = [...this.outputEditedRows,eitem];     // Add to output attribute collection
                if (this.isUserDefinedObject) {
                    this.outputEditedRowsString = JSON.stringify(this.outputEditedRows);                                        //JSON Version
                    this.dispatchEvent(new FlowAttributeChangeEvent('outputEditedRowsString', this.outputEditedRowsString));    //JSON Version
                } else {
                    this.dispatchEvent(new FlowAttributeChangeEvent('outputEditedRows', this.outputEditedRows));
                }
            }
            return eitem;
        });  

        this.savePreEditData = [...data];   // Resave the current table values
        this.mydata = [...data];            // Reset the current table values
        if (!this.suppressBottomBar) {
            this.columns = [...this.columns];   // Force clearing of the edit highlights
        }
    }

    cancelChanges(event) {
        // Only used with inline editing
        this.mydata = [...this.savePreEditData];
    }

    handleRowSelection(event) {
        // Only used with row selection
        // Update values to be passed back to the Flow
        let currentSelectedRows = event.detail.selectedRows;
        this.updateNumberOfRowsSelected(currentSelectedRows);
        this.setIsInvalidFlag(false);
        if(this.isRequired && this.numberOfRowsSelected == 0) {
            this.setIsInvalidFlag(true);
        }
        let sdata = [];
        currentSelectedRows.forEach(srow => {
            const selData = this.tableData.find(d => d[this.keyField] == srow[this.keyField]);
            sdata.push(selData);
        });
        this.outputSelectedRows = [...sdata]; // Set output attribute values
        if (this.isUserDefinedObject) {
            this.outputSelectedRowsString = JSON.stringify(this.outputSelectedRows);                                        //JSON Version
            this.dispatchEvent(new FlowAttributeChangeEvent('outputSelectedRowsString', this.outputSelectedRowsString));    //JSON Version             
        } else {
            this.dispatchEvent(new FlowAttributeChangeEvent('outputSelectedRows', this.outputSelectedRows));
        }
        console.log('outputSelectedRows',this.outputSelectedRows);
    }

    updateNumberOfRowsSelected(currentSelectedRows) {
        // Handle updating output attribute for the number of selected rows
        this.numberOfRowsSelected = currentSelectedRows.length;
        this.dispatchEvent(new FlowAttributeChangeEvent('numberOfRowsSelected', this.numberOfRowsSelected));
        // Return an SObject Record if just a single row is selected
        this.outputSelectedRow = (this.numberOfRowsSelected == 1) ? currentSelectedRows[0] : null;
        this.dispatchEvent(new FlowAttributeChangeEvent('outputSelectedRow', this.outputSelectedRow));
        this.showClearButton = this.numberOfRowsSelected == 1 && (this.tableData.length == 1 || this.singleRowSelection);   //Thanks to Jeff Olmstead for updated formula
    }

    handleClearSelection() {
        this.showClearButton = false;
        this.selectedRows = [];
        this.outputSelectedRows = this.selectedRows;
        this.dispatchEvent(new FlowAttributeChangeEvent('outputSelectedRows', this.outputSelectedRows));
    }

    updateColumnSorting(event) {
        // Handle column sorting
        console.log('Sort:',event.detail.fieldName,event.detail.sortDirection);
        this.sortedBy = event.detail.fieldName;
        this.sortedDirection = event.detail.sortDirection;
        this.doSort(this.sortedBy, this.sortedDirection);
    }

    doSort(sortField, sortDirection) {
        // Change sort field from Id to Name for lookups
        if (sortField.endsWith('_lookup')) {
            sortField = sortField.slice(0,sortField.lastIndexOf('_lookup')) + '_name';   
        }       
        let fieldValue = row => row[sortField] || '';
        let reverse = sortDirection === 'asc'? 1: -1;

        this.isWorking = true;
        new Promise((resolve, reject) => {
            setTimeout(() => {
                this.mydata = [...this.mydata.sort(
                    (a,b)=>(a=fieldValue(a),b=fieldValue(b),reverse*((a>b)-(b>a)))
                )];
                resolve();
            }, 0);
        })
        .then(
            () => this.isWorking = false
        );        
    }
    
    handleHeaderAction(event) {
        // Handle Set Filter and Clear Filter
        const actionName = event.detail.action.name;
        if (!this.isConfigMode && actionName.substr(actionName.length - 4) == 'Text') {   // Exit if system header action of wrapText or clipText
            return;
        }
        this.isFiltered = false;
        const colDef = event.detail.columnDefinition;
        this.filterColumns = JSON.parse(JSON.stringify([...this.columns]));
        this.columnNumber = Number(colDef.actions[0].name.split("_")[1]);
        this.baseLabel = this.filterColumns[this.columnNumber].label.split(' [')[0];
        const prompt = (this.isConfigMode) ? 'Label' : 'Filter';
        this.inputLabel = 'Column ' + prompt + ': ' + this.baseLabel;
        switch(actionName.split('_')[0]) {

            case 'alignl':   // Config Mode Only
                this.filterColumns[this.columnNumber].cellAttributes = {alignment: 'left'};
                this.filterColumns[this.columnNumber].actions.find(a => a.name == 'alignl_'+this.columnNumber).checked = true;
                this.filterColumns[this.columnNumber].actions.find(a => a.name == 'alignc_'+this.columnNumber).checked = false;
                this.filterColumns[this.columnNumber].actions.find(a => a.name == 'alignr_'+this.columnNumber).checked = false;
                this.columns = [...this.filterColumns]; 
                this.updateAlignmentParam();
                break;

            case 'alignc':   // Config Mode Only
                this.filterColumns[this.columnNumber].cellAttributes = {alignment: 'center'};
                this.filterColumns[this.columnNumber].actions.find(a => a.name == 'alignl_'+this.columnNumber).checked = false;
                this.filterColumns[this.columnNumber].actions.find(a => a.name == 'alignc_'+this.columnNumber).checked = true;
                this.filterColumns[this.columnNumber].actions.find(a => a.name == 'alignr_'+this.columnNumber).checked = false;
                this.columns = [...this.filterColumns]; 
                this.updateAlignmentParam();
                break;

            case 'alignr':   // Config Mode Only
                this.filterColumns[this.columnNumber].cellAttributes = {alignment: 'right'};
                this.filterColumns[this.columnNumber].actions.find(a => a.name == 'alignl_'+this.columnNumber).checked = false;
                this.filterColumns[this.columnNumber].actions.find(a => a.name == 'alignc_'+this.columnNumber).checked = false;
                this.filterColumns[this.columnNumber].actions.find(a => a.name == 'alignr_'+this.columnNumber).checked = true;
                this.columns = [...this.filterColumns]; 
                this.updateAlignmentParam();
                break;

            case 'aedit':   // Config Mode Only
                this.filterColumns[this.columnNumber].actions.find(a => a.name == 'aedit_'+this.columnNumber).checked ^= true;      // Flip True-False Value
                this.columns = [...this.filterColumns]; 
                this.updateEditParam();
                break;

            case 'afilter': // Config Mode Only
                this.filterColumns[this.columnNumber].actions.find(a => a.name == 'afilter_'+this.columnNumber).checked ^= true;    // Flip True-False Value
                this.columns = [...this.filterColumns]; 
                this.updateFilterParam();
                break;

            case 'wrapText': // Config Mode Only
                this.filterColumns[this.columnNumber].wrapText = true;
                this.columns = [...this.filterColumns];
                this.updateWrapParam();
                break;

            case 'clipText':
                this.filterColumns[this.columnNumber].wrapText = false;
                this.columns = [...this.filterColumns];
                this.updateWrapParam();
                break;

            case 'icon':   // Config Mode Only
                this.columnIconValue = this.filterColumns[this.columnNumber].iconName;
                this.handleOpenSelectIcon();
                break;

            case 'label':   // Config Mode Only
                this.columnFilterValue = this.columnFilterValues[this.columnNumber];
                this.columnFilterValue = (this.columnFilterValue) ? this.columnFilterValue : this.baseLabel;
                this.columnType = 'richtext';
                this.inputType = this.convertType(this.columnType);
                this.inputFormat = (this.inputType == 'number') ? this.convertFormat(this.columnType) : null;
                this.handleOpenFilterInput();
                break;

            case 'filter':
                this.columnFilterValue = this.columnFilterValues[this.columnNumber];
                this.columnFilterValue = (this.columnFilterValue) ? this.columnFilterValue : null;
                this.columnType = colDef.type;
                this.inputType = this.convertType(this.columnType);
                this.inputFormat = (this.inputType == 'number') ? this.convertFormat(this.columnType) : null;
                this.handleOpenFilterInput();
                break;

            case 'clear':
                this.filterColumns[this.columnNumber].label = (this.isConfigMode) ? this.cols[this.columnNumber].label : this.baseLabel;
                this.columnFilterValue = null;
                this.columnFilterValues[this.columnNumber] = this.columnFilterValue;
                if (this.isConfigMode) {
                    this.updateLabelParam();
                }

                this.isWorking = true;
                new Promise((resolve, reject) => {
                    setTimeout(() => {
                        this.filterColumnData();
                        resolve();
                    }, 0);
                })
                .then(
                    () => this.isWorking = false
                );

                this.filterColumns[this.columnNumber].actions.find(a => a.name == 'clear_'+this.columnNumber).disabled = true;
                if (this.sortedBy != undefined) {
                    this.doSort(this.sortedBy, this.sortedDirection);       // Re-Sort the data
                }
                break;

            default:
        }

        this.columns = [...this.filterColumns];
    }

    convertType(colType) {
        // Set Input Type based on column Data Type
        switch(colType) {
            case 'boolean':
                return 'text';
            case 'date':
                return 'date';
            case 'date-local':
                return 'date';
            case 'datetime':
                return 'datetime';
            case 'time':
                return 'time';
            case 'email':
                return 'email';
            case 'phone':
                return 'tel';
            case 'url':
                return 'url';
            case 'number':
                return 'number';
            case 'currency':
                return 'number';
            case 'percent':
                return 'number';
            case 'text':
                return 'text';
            default:
                return 'richtext';
        }
    }

    convertFormat(colType) {
        // Set Input Formatter value for different number types
        switch(colType) {
            case 'currency':
                return 'currency';
            case 'percent':
                // return 'percent-fixed';  // This would be to enter 35 to get 35% (0.35)
                return 'percent';
            default:
                return null;
        }
    }

    handleResize(event) {
        // Save the current column widths and update the config parameter
        this.columnWidthValues = event.detail.columnWidths;
        this.setWidth(this.columnWidthValues);
    }

    handleRoundWidths() {
        // Round the Width values to the nearest ROUNDWIDTH 
        let widths = [];     
        this.columnWidthValues.forEach(w => {
            widths.push(Math.round(w/ROUNDWIDTH)*ROUNDWIDTH);
        });
        this.setWidth(widths);
        this.columns = [...this.columns];
    }

    setWidth(sizes) {
        // Update the column width values and the Config Mode parameter
        let colNum = 0;
        let colString = '';
        let colWidthsTotal = 0;
        this.basicColumns.forEach(colDef => {
            this.columns[colNum]['initialWidth'] = sizes[colNum];
            if (this.filterColumns) {
                this.filterColumns[colNum]['initialWidth'] = sizes[colNum];
            }
            colString = colString + ', ' + colDef['fieldName'] + ':' + sizes[colNum];
            colWidthsTotal += parseInt(sizes[colNum], 10);        
            colNum += 1;
        });
        let displayWidths = colString.substring(2);
        this.columnWidthParameter = `${displayWidths} (Total: ${colWidthsTotal})`;
        this.wizColumnWidths = this.columnWidthParameter;
        this.columnWidthsLabel = `Column Data`;
    }

    handleChange(event) {
        // Update the filter value as the user types it in
        this.columnFilterValue = event.target.value;
        this.columnFilterValues[this.columnNumber] = this.columnFilterValue;
        this.isFiltered = false;
    }

    handleSelectAllEdit() {
        // Set the Allow Edit Value to True for All Columns
        this.isAllEdit = !this.isAllEdit;
        this.filterColumns = JSON.parse(JSON.stringify([...this.columns]));
        let colNum = 0;
        this.filterColumns.forEach(colDef => {
            colDef['actions'].find(a => a.name == 'aedit_'+colNum).checked = this.isAllEdit;
            colNum += 1;
        });
        this.columnEditParameter = (this.isAllEdit) ? 'All' : '';
        this.wizColumnEdits = this.columnEditParameter;
        this.columns = [...this.filterColumns]; 
    }

    handleSelectAllFilter(event) {
        // Set the Allow Edit Value to True for All Columns
        this.isAllFilter = !this.isAllFilter;
        this.filterColumns = JSON.parse(JSON.stringify([...this.columns]));
        let colNum = 0;
        this.filterColumns.forEach(colDef => {
            colDef['actions'].find(a => a.name == 'afilter_'+colNum).checked = this.isAllFilter;
            colNum += 1;
        });
        this.columnFilterParameter = (this.isAllFilter) ? 'All' : '';
        this.wizColumnFilters = this.columnFilterParameter;
        this.columns = [...this.filterColumns]; 
    }

    handleOpenSelectIcon() { 
        // Display the input dialog for the icon selection
        this.isOpenIconInput = true;
    }

    handleCloseIconModal() {
        // Close the input dialog and cancel any changes
        this.isOpenIconInput = false;
    }

    handleCommitIconSelection(event) { 
        // Update the column icon value
        let newValue = event.target.value;
        if (newValue) {
            this.filterColumns[this.columnNumber].iconName = newValue;
            this.columns = [...this.filterColumns]; 
            this.updateIconParam();
        }
        this.isOpenIconInput = false;
    }

    handleOpenFilterInput() {
        // Display the input dialog for the filter value
        this.saveOriginalValue = this.columnFilterValue;
        this.isOpenFilterInput = true;
    }

    handleCommit() {
        // Handle the filter input when the user clicks out of the input dialog
        if (this.columnFilterValue != null) {
            this.handleCloseFilterInput();
        }
    }

    handleCloseFilterInput() {
        // Close the input dialog and handle the new column filter value
        this.isOpenFilterInput = false; 
        if (this.columnType == 'boolean') {
            let firstChar = this.columnFilterValue.substring(0, 1).toLowerCase();
            if (firstChar == 't' || firstChar == 'y' || firstChar == '1') { // True, Yes, 1 - allow multiple ways to select a True value
                this.columnFilterValue = 'true';
            } else {
                this.columnFilterValue = 'false';
            }
            this.columnFilterValues[this.columnNumber] = this.columnFilterValue;
        }

        if (!this.isFiltered) this.filterColumnData();

        if (this.isConfigMode) {
            this.filterColumns[this.columnNumber].label = this.columnFilterValue;
            this.updateLabelParam();
        } else {
            this.filterColumns[this.columnNumber].label = this.baseLabel + ' [' + this.columnFilterValue + ']';
        }
        this.columnFilterValues[this.columnNumber] = this.columnFilterValue;
        // Force a redisplay of the datatable with the filter value shown in the column header
        this.columns = [...this.filterColumns]; 
    }

    handleCloseModal() {
        // Close the input dialog and cancel any changes
        this.columnFilterValue = this.saveOriginalValue;
        this.columnFilterValues[this.columnNumber] = this.columnFilterValue;
        this.isOpenFilterInput = false;
    }

    filterColumnData() {
        // Filter the rows based on the current column filter values
        this.isWorking = true;
        new Promise((resolve, reject) => {
            setTimeout(() => {
                if (!this.isConfigMode) {
                    const rows = [...this.savePreEditData];
                    const cols = this.columnFilterValues;
                    let filteredRows = [];
                    rows.forEach(row => {
                        let match = true;
                        for (let col = 0; col < cols.length; col++) {
                            let fieldName = this.filterColumns[col].fieldName;
                            if (fieldName.endsWith('_lookup')) {
                                fieldName = fieldName.slice(0,fieldName.lastIndexOf('_lookup')) + '_name';   
                            }                
                            if (this.columnFilterValues[col] && this.columnFilterValues[col] != null) {
                                if (!row[fieldName] || row[fieldName] == null) {    // No match because the field is empty
                                    match = false;
                                    break; 
                                }                   

                                switch(this.filterColumns[col].type) {
                                    case 'number':
                                    case 'currency':
                                    case 'percent':
                                    case 'date':
                                    case 'date-local':
                                    case 'datetime':
                                    case 'time':
                                        if (row[fieldName] != this.columnFilterValues[col]) {    // Check for exact match on numeric and date fields
                                            match = false;
                                            break;                                
                                        }
                                        break;
                                    default:
                                        let fieldValue = row[fieldName].toString();
                                        let filterValue = this.columnFilterValues[col];
                                        if (!this.matchCaseOnFilters) {
                                            fieldValue = fieldValue.toLowerCase();
                                            filterValue = filterValue.toLowerCase();
                                        }
                                        if (fieldValue.search(filterValue) == -1) {  // Check for filter value within field value
                                            match = false;
                                            break;
                                        }                            
                                }
                            }
                        }
                        if (match) {
                            filteredRows.push(row);
                        }
                    });
                    this.mydata = filteredRows;
                }
                resolve();
            }, 0);
        })
        .then(
            () => this.isWorking = false
        );
        
        this.filterColumns[this.columnNumber].actions.find(a => a.name == 'clear_'+this.columnNumber).disabled = false;
        this.isFiltered = true;
    }

    updateAlignmentParam() {
        // Create the Alignment Label parameter for Config Mode
        let colNum = 0;
        let colString = '';
        this.filterColumns.forEach(colDef => {
            let configAlign = (this.convertType(colDef['type']) != 'number') ? 'left' : 'right';
            if (colDef['cellAttributes']['alignment'] != configAlign) {
                colString = colString + ', ' + colDef['fieldName'] + ':' + colDef['cellAttributes']['alignment'];
            }
            colNum += 1;
        });
        this.columnAlignmentParameter = colString.substring(2);
        this.wizColumnAlignments = this.columnAlignmentParameter;      
    }

    updateLabelParam() {
        // Create the Column Label parameter for Config Mode
        let colNum = 0;
        let colString = '';
        this.basicColumns.forEach(colDef => {
            if (colDef['label'] != this.filterColumns[colNum].label) {
                colString = colString + ', ' + colDef['fieldName'] + ':' + this.filterColumns[colNum].label;
            }
            colNum += 1;
        });
        this.columnLabelParameter = colString.substring(2);
        this.wizColumnLabels = this.columnLabelParameter;
    }

    updateIconParam() {
        // Create the Column Icon parameter for Config Mode
        let colNum = 0;
        let colString = '';
        this.basicColumns.forEach(colDef => {
            if (colDef['icon'] != this.filterColumns[colNum].iconName) {
                colString = colString + ', ' + colDef['fieldName'] + ':' + this.filterColumns[colNum].iconName;
            }
            colNum += 1;
        });
        this.columnIconParameter = colString.substring(2);
        this.wizColumnIcons = this.columnIconParameter;
    }

    updateWrapParam() { 
        // Create the Column WrapText parameter for Config Mode
        let colNum = 0;
        var colString = '';
        this.basicColumns.forEach(colDef => {
            if (colDef['wrapText'] != this.filterColumns[colNum].wrapText) {
                colString = colString + ', ' + colDef['fieldName'] + ':' + this.filterColumns[colNum].wrapText;
            }
console.log("DatatableV2 -> updateWrapParam -> this.filterColumns[colNum].wrapText", colNum, this.filterColumns[colNum].wrapText);
            colNum += 1;
        });
        this.columnWrapParameter = colString.substring(2);
        this.wizColumnWraps = this.columnWrapParameter;    
    }

    updateEditParam() {
        // Create the Column Edit parameter for Config Mode
        let colNum = 0;
        let colString = '';
        let allSelected = true;
        this.filterColumns.forEach(colDef => {
            if (colDef['actions'].find(a => a.name == 'aedit_'+colNum).checked) {          
                colString = colString + ', ' + colDef['fieldName'] + ':true';   
            } else {
                allSelected = false;
            }
            colNum += 1;
        });
        this.columnEditParameter = (allSelected) ? 'All' : colString.substring(2);
        this.wizColumnEdits = this.columnEditParameter;
        this.isAllEdit = allSelected;
    }

    updateFilterParam() {
        // Create the Column Filter parameter for Config Mode
        let colNum = 0;
        let colString = '';
        let allSelected = true;
        this.filterColumns.forEach(colDef => {
            if (colDef['actions'].find(a => a.name == 'afilter_'+colNum).checked) {
                colString = colString + ', ' + colDef['fieldName'] + ':true';
            } else {
                allSelected = false;
            }
            colNum += 1;
        });
        this.columnFilterParameter = (allSelected) ? 'All' : colString.substring(2);
        this.wizColumnFilters = this.columnFilterParameter;
        this.isAllFilter = allSelected;
    }

    @api
    validate() {
        // Validation logic to pass back to the Flow
        if(!this.isRequired || this.numberOfRowsSelected > 0) { 
            this.setIsInvalidFlag(false);
            return { isValid: true }; 
        } 
        else { 
            // If the component is invalid, return the isValid parameter 
            // as false and return an error message. 
            this.setIsInvalidFlag(true);
            return { 
                isValid: false, 
                errorMessage: 'This is a required entry.  At least 1 row must be selected.' 
            }; 
        }
    }

    setIsInvalidFlag(value) {
        this.isInvalid = value;
    }
}