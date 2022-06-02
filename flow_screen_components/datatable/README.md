# Datatable

Lightning Web Component for Flow Screens:       **Datatable**

**This component allows the user to configure and display a datatable in a Flow screen.**

Additional components packaged with this LWC:

                Apex Classes:       ers_QueryNRecords
                                    ers_QueryNRecordsTest
                                    ers_DatatableController 
                                    ers_DatatableControllerTest
                                    ers_EncodeDecodeURL
                                    ers_EncodeDecodeURLTest

                LWCs:               ers_comboboxColumnType
                                    ers_customLightningDatatable
                                    ers_datatableUtils
                                    ers_datatableCPE
                                    ers_richTextColumnType

                Custom Objects:     ers_datatableConfig (replaced in v3.5.0 by FlowTableViewDefinition from the FlowScreenComponentsBasePack)

                Page Layouts:       ers_datatableConfig Layout

                Tabs:               ers_datatableConfig

                StaticResources:    ers_customLightningDatatableStyles

                Flows:              Datatable_Configuration_Wizard4

                Permission Set:     USF Flow Screen Component - Datatable          
                                                  
**Documentation:**  https://unofficialsf.com/datatable-lightning-web-component-for-flow-screens-2/ 
  
**Created by:**	Eric Smith  
**Date:**		2019 - 2022
  
LinkedIn: 	https://www.linkedin.com/in/ericrsmith2  
Salesforce: https://trailblazer.me/id/ericsmith  
Blog:		https://ericsplayground.wordpress.com/blog/  
Twitter: 	https://twitter.com/esmith35  

---
**You must install these components FIRST in order to install and use the Datatable component**     
FlowActionsBasePack Version 3.0.0 or later  
FlowScreenComponentsBasePack Version 3.0.7 or later  
  
Both Base Packs are available here:   
https://unofficialsf.com/flow-action-and-screen-component-basepacks/
  
---
**Install Datatable**  
[Version 4.0.5 (Production or Developer)](https://login.salesforce.com/packaging/installPackage.apexp?p0=04t5G000003rUyKQAU)   
[Version 4.0.5 (Sandbox)](https://test.salesforce.com/packaging/installPackage.apexp?p0=04t5G000003rUyKQAU)
 
---
**Starting with the Winter '21 Release, Salesforce requires that a User's Profile or Permission Set is given specific permission to access any @AuraEnabled Apex Method.**  

Release Notes: https://releasenotes.docs.salesforce.com/en-us/winter21/release-notes/rn_lc_restrict_apex_authenticated_users.htm  

This will affect any Aura or Lightning Web Component that uses @AuraEnabled Apex Classes.  

In order to use **datatable**, permission must be given to access the following Apex Classes:  

    ers_QueryNRecords   
    ers_DatatableController
    ers_EncodeDecodeURL  

A Permission Set (**USF Flow Screen Component - Datatable**) is included with the install package.  
    
---
# Release Notes
 
## 05/22/22 -  Eric Smith -     Version 4.0.5 
**Updates:** 
-   Added new Output Attribute - selectedRowKeyValue
    This outputs the value of the KeyField(Id) when single row selection is enabled.  This is designed to support inputs to other
    components on the same screen when Reactive Screens are implemented 
-   Enhanced how Column Wizard configuration files are created and updated 
-   Saved Column Wizard configuration files now support >255 characters per attribute 
 
**Bug Fixes:** 
-   Fix Column Wizard error when reselecting after saving a flow 
-   Column Wizard configuration files now store the column widths values
-   Fix test class for orgs without Orders enabled
 
## 05/15/22 -  Eric Smith -     Version 4.0.4 
**Bug Fixes:** 
-   Changed the Date timezone offset to start at Noon instead of Midnight in order to avoid DST issues with the offset
 
## 04/14/22 -  Alex Edelstein - Version 4.0.3 
**Updates:** 
-   Updated to use the new v3 versions of the Base Packs
 
## 03/25/22 -  Eric Smith -    Version 3.5.1 
**Bug Fixes:** 
-   Fixed a bug where table sorting, edits and column widths were getting reset when using the datatable on a screen with Sections or in an
    org with the Reactive Screens pilot activated
 
## 03/15/22 -  Eric Smith -    Version 3.5.0 
**Updates:** 
-   Eliminate padding/margin for Table Border (Thanks to Jerry Poon)
-   Add option to Navigate Next when selecting the Save button for inline editing (Thanks to Idan Damari)
-   Rearranged the order of the options in the Table Behavior Section
-   Changed the Configuration Wizard to use the new FlowTableViewDefinition object from the ScreenComponentsBasePack instead of the ers_datatableConfig object
-   Added Created and Modified Date columns to the Configuration Record selection datatable
-   Added optional Record Count to Table Header
-   Added option to suppress the currency conversion introduced in v3.1.1
  
**Bug Fixes:** 
-   Fixed bug when using a % character in a column label [Issue-1069]
  
## 02/16/22 -  Eric Smith -    Version 3.4.5 
**Updates:** 
-   Updated all component API versions to 53.0 (Winter '22)
-   Changed tableData attribute to support Reactive Screens (pilot) see PR_944
-   Replaced hardcoded messages with Custom Labels to allow for translations
 
**Bug Fixes:** 
-   Fixed horizontal scroll bar disappearing after a field edit (This will increase the table's height while the footer is present) [Issue-890]
-   Fix for clicking the dropdown arrow not expanding the selections when editing a picklist [Issue-883]
-   Fix lookup links when the datatable is on a non-home Community(Experience) page
-   Reapply timezone offset on date fields for edited records 
-   Fix for currency conversion on manually created records when the object has no records [Issue-1047]
-   Fix conditional display of Clear Selection button
-   Allow the clearing of a header icon in the Column Wizard
-   Fix pre-selected records being highlighted and passed through to the output if no additional selections are made

## 02/11/22 -  Alex Edelstein -    Version 3.4.4 
**Updates:**
-   Updated default table border styling

**Bug Fixes:** 
-   Misc Fixes

## 01/30/22 – Alex Edelstein – Version 3.4.2
**Updates:** 
-   Supports a JSON datastring as an input and output 
-   Supports reactive screens pilot 
-   Visible Left border where there wasn’t one previously 
 
**Bug Fixes:** 
-   Misc Fixes
 
## 08/13/21 -  Eric Smith -    Version 3.3.2 
**Updates:** 
-   Converted interface elements to Custom Labels so they can be Translated 
-   Added support for Screen Readers for the visually impaired
-   Updated all component API versions to 52.0
 
**Bug Fixes:** 
-   Added missing variable in the CPE to support automaticOutputVariables
-   Check for CurrencyConversion returning null values before committing any changes
-   Fix filtering on Date and Datetime column types
-   Keep Checkbox selection instead of Radio Button when table size is 1 and Single Row Selection is not activated
 
## 07/18/21 -  Eric Smith -    Version 3.3.0 
**Updates:** 
-   Added a custom object (ers_datatableConfig) to provide the ability to Save and Retrieve column configuration attributes
-   Added an attribute to allow the datatable to overflow its container (helpful when editing picklists on a table with only a few records)
-   Changed the number of rows in the Configuration Wizard datatable from 10 to 6
 
**Bug Fixes:** 
-   Fixed an error that ocurred when trying to save an edited row from a datatable that contained a time field 
-   Fixed a bug that kept Date and Time fields from displaying in datatables when the User's locale displays numbers with a . separator
-   Rows with editable picklist fields will not default to a taller height (Even without picklist fields, all rows will still be slightly taller if any fields are editable)
 
## 06/26/21 -  Eric Smith -    Version 3.2.4 
**Updates:** 
-   New Output Attribute for the Number of Rows Edited (Because even when no rows are edited, the OutputEditedRows attribute is not null)
-   The Datatable CPE now supports Automatic Output Variables in the Flow Builder
 
**Bug Fixes:** 
-   Orgs with multi-currency enabled can now add currency rollup and currency formula fields to the datatable 
-   The edit picklist dropdown will overflow the displayed table if necessary (Only if the Table Height attribute is not set)
-   The dropdown picklist values when editing will show the picklist labels instead of the picklist API names (The selected edit prior to selecting Save will show as the API name)
 
## 06/13/21 -  Eric Smith -    Version 3.2.3 
**Updates:** 
-   When the running User doesn't have Read access to the Datatable's SObject, Record Type Id for Picklist Values is ignored
    and all picklist values will be available when editing a picklist field
-   Fields that are Read Only to the running User can still be edited when the Flow is running in System Mode
 
 ## 06/11/21 -  Eric Smith -    Version 3.2.2 
**Updates:** 
-   Editable picklist fields now show a pencil icon when editable (Same behavior as all other field edits) 
-   Icon Pickers in the CPE and Configure Column Wizard have been updated to the latest version 
-   Added a new attribute to optionaly hide the Clear Selection button that appears on a table with radio button selection
 
**Bug Fixes:** 
-   Fixed alignment of picklist fields when selecting Center or Right alignment 
-   Adjust edited Date fields by the running User's timezone offset to keep the correct day 
-   Enforced no edits on fields such as Rollups and Formulas 
-   Fixed occasional error message about the not_suppressNameFieldLink attribute  
-   Fixed v3.2.1 bug where pre-selected rows did not display as selected  
 
## 05/18/21 -  Eric Smith -    Version 3.2.1 
**Updates:** 
-   Picklist values can now be restricted to a single record type 
 
**Bug Fixes:** 
-   Text formula fields will now wrap correctly (This had regressed in v3.2.0) 
-   Output Selected Rows is no longer null if the screen containing the Datatable also has a Section 
 
## 05/03/21 -  Eric Smith -    Version 3.2.0 
**Updates:** 
-   Picklist fields are now editable.  Big thanks to Jerry Poon and Guillaume Davies.
    (Does not yet support Dependent picklists nor filtering by Record Type)
-   Changed Table Header font from 1.5em to 1.2em to match the format of List Views
-   Renamed components used by Datatable to reduce conflicts and allow easier upgrading from older versions
 
**Bug Fixes:**
-   Do not display a header if there is a Header Label value but the Display Table Header attribute is not checked
-   Make output attributes available to visibility filters (this was inadvertantly removed from some prior releases)
-   Better handling of number & percent fields from different locales (Thanks to GDuboc-hub)
    (Edited percent fields must be the actual number ie: .25 = 25%)
    (Edited percent fields lose 2 decimal places during the edit from what is defined for the field)
-   Edited date fields will stay in the User's local time-zone rather than switching to UTC
 
## 04/15/21 -  Eric Smith -    Version 3.1.1 
**Updates:** 
-   Moved the "Display ALL Objects for Selection" choice in the CPE from Advanced to Data Source
-   Added an attribute to hide all column header actions such as Sort, Clip/Wrap Text and Filters
-   If Multi-Currency is enabled, convert currency field values to the User's currency (Thanks to Novarg1)
 
**Bug Fixes:**
-   Text formula fields will now wrap correctly
-   Display ALL Objects for Selection attribute is now persistent
-   Input data is Apex-Defined attribute is now persistent
-   The number of pre-selected rows will now not exceed the maximum number of records to be displayed attribute value
-   Don't require the key field to be explicitly listed in the Column Edits attribute for Apex Defined Objects
-   Clear Selection button will no longer appear on single row tables when Disallow row selection is checked
-   Clear Selection button will clear the Output Selected Record String for Apex Defined Objects
-   Fixed Column Filter on Checkbox Fields when the filter value is 'false' 
-   Fixed vertical alignment of table header text
  
## 02/27/21 -  Eric Smith -    Version 3.0.10 
**Updates:** 
-   Record links updated to support a Flow running in a Community
-   Added a new Table Behavior option to specify if Links should open in the same Tab
-   Allow the use of a Flow variable to set the Maximum Number of Rows value 
-   Changed display of error messages to match Salesforce standard
-   Allow full TypeAttibutes for Date fields (This will switch datetime fields to UTC)
-   Added a Permission Set that gives access to the @AuraEnabled Apex Classes that are part of the Datatable Flow Screen LWC
  
**Bug Fixes:**
-   Fixed links when running in a Sandbox whose name started with the letter c
-   Stop requiring Checkbox column if any columns are selected for editing 
-   Set the Number of Rows Selected to 0 when clearing the row selections
-   Retain the setting when clearing a checkbox in the CPE
-   Fixed error when trying to exit the CPE after selecting the Apex Defined Object option
-   Fixed delay when selecting a large (>200) number of records
-   Fixed delay when editing multiple (>20) number of records
-   Fixed issue with being unable to edit Apex-Defined columns unless Type was specified
-   Made sure that the Key Field could not be edited
-   Allow regular Textarea fields of 255 characters or less to be edited
  
## 01/19/21 -  Eric Smith -    Version 3.0.9 
**Updates:** 
-   Add option to Display Row Numbers (default=false)
-   Allow setting of Table Header for Apex Defined Objects
-   Display the current Version # at the bottom of the CPE
  
**Bug Fixes:**
-   Allow a TypeAttribute to set the Maximum number of decimal places to display to be less than the field default Minimum
-   Fix initial attribute display in the CPE when using an Apex Defined Object
-   Fix attribute corruption when updating multiple times
  
## 01/08/21 -  Eric Smith -    Version 3.0.8 
**Updates:** 
-   Relocate to correct packaging org
-   Users with version 3.0.3 through 3.0.6 will need to uninstall & reinstall
  
## 01/06/21 -  Eric Smith -    Version 3.0.6  
**Bug Fixes:**  
-   Fixed checkbox behavior in the CPE 
-   Fixed an error selecting checkboxes in the CPE  
-   Fixed an error with attributes not being able to be cleared  
-   Fixed an error with Textarea not showing Rich Text correctly  
   
## 01/01/21 -  Eric Smith -    Version 3.0.5 
**Updates:**
-   Added Icon Pickers to the CPE and Column Wizard  (Requires FlowScreenComponentBasePack v2.1.2 or later)
-   Changed 'Display ALL Objects for Selection' checkbox to default to unchecked  
 
**Bug Fixes:**
-   Removed field names from Empty Table Header
-   Fixed "Apex CPU time limit exceeded" error (FlowActionsBasePack v2.9 or greater)    
  
## 12/14/20 -  Eric Smith -    Version 3.0.0 
**Updates:**
-   New Custom Property Editor for Configuration  
-   Clear button added when using single record selection  
-   Fixed row number display when >99 rows
 
**Bug Fixes:**
-   Sandbox URLs with __c in their name will now provide valid links for lookups  
  
## 10/14/20 -  Eric Smith -    Version 2.47 
**Bug Fix:**
-   Display correct icon for Table Header (was always showing standard:account icon)
  
## 10/07/20 -  Eric Smith -    Version 2.46 
**Updates:**
-   Added new Output Parameter for the # of Selected Records 
-   (this can be used for conditional visibility on the same screen as the datatable)   
-   New Selected Record Output Parameter - Returns an SObject record if just a single record is selected 
-   New Required? Parameter - Requires the user to select at least 1 row to proceed  
-   New option to suppress the link for the object's standard Name field  
-   New optional Table Header with Table Icon and Table Label Parameters  
-   Switched DualListbox to the fbc version  
-   Added spinners while sorting & filtering data  
-   Allow case insensitive field API names  
-   Allow custom field API names w/o the __c suffix  
 
**Bug Fixes:**
-   Display Picklist Labels instead of API Names for Picklist and Multipicklist fields  
-   Added a Clear Selection button for tables with just a single record
  
## 09/22/20 -  Eric Smith -    Version 2.45 
**Bug Fix:**
-   Fixed inability to edit some field types (introduced by v2.44)
  
## 09/20/20 -  Kevin Hart -    Version 2.44 
**Updates:**
-   Added ability to display Rich Text fields  
 
**Bug Fix:** - Eric Smith
-   Fixed error when selecting column action of WrapText or ClipText  
                
## 09/01/20 -  Eric Smith -    Version 2.43 
**Bug Fix:**
-   Update Percent Field Handling and set Formula Fields to be Non-Editable  
              
## 08/26/20 -  Eric Smith -    Version 2.42 
**Bug Fixes:**
-   Update Time fields with the User's Timezone Offset value so they display as intended  
-   Fix field type so Datetime fields display correctly    
                
## 08/14/20 -  Eric Smith -    Version 2.41 
**Bug Fix:**
-   Fixed issue with time and date-time fields being displayed as a day earlier     
               
## 08/11/20 -  Eric Smith -    Version 2.40 
**Updates:**
-   Added attribute to allow the suppression of the record link on the SObject's 'Name' field  
 
**Bug Fix:**
-   Fixed code so the 'Name' Field column now sorts correctly  
              
## 07/31/20 -  Eric Smith -    Version 2.39 
**Updates:**
-   Added Datatable Configuration Helper Flow  
**REQUIRES:**
-   Flow Base Components (https://unofficialsf.com/introducing-flowbasecomponents/)  
-   Dual List Box (https://unofficialsf.com/duallistbox/)   
-   Remote Site Setting (Setup)
                  
## 07/31/20 -  Andy Hass -     Version 2.38 
**Updates:**
-   Added support for Checkbox Field Type
                
## 07/07/20 -  Eric Smith -    Version 2.37 
**Bug Fix:**
-   Fixed issue with the date being displayed as a day earlier   
              
## 07/01/20 -  Eric Smith -    Version 2.36 
**Updates:**
-   Now displays the primary "Name" field as a Link (textWrap = true)  
-   Added button in Config Mode to round off Column Width values  
              
## 06/30/20 -  Eric Smith -    Version 2.35 
**Updates:**
-   Extended Configuration Mode to handle Column Alignments, Labels, Widths, Allow Edit & Allow Filter  
-   Added Configuration Mode buttons to select all columns for Edit and/or Filter  
-   Selecting an attribute string now copies the contents into the system Clipboard  
                              
## 06/24/20 -  Eric Smith -    Version 2.34 
**Updates:**
-   Added Configuration Mode parameter (Used by Datatable Configuration Flow)  
 
 **Bug Fix:**
-   Fixed issue with column widths resetting when filtering  
  
## 06/19/20 -  Eric Smith -    Version 2.33 
**Updates:**
-   Removed default value for Table Height
 
 **Bug Fix:**
 -   Fixed issue with lookup fields being blank in the first record                                                    
  
## 06/03/20 -  Eric Smith -    Version 2.32 
**Bug Fix:**
-   Fixed error when editing more than one column in a single row while suppressing the Cancel/Save buttons
  
## 06/03/20 -  Eric Smith -    Version 2.31 
**Updates:**
-   Changed SObjectController to SObjectController2 to allow for easier deployment to orgs that already have an earlier version of the datatable component    
                                                                                   
## 06/03/20 -  Eric Smith -    Version 2.3 
**Updates:**
-   Changed SObjectController to SObjectController2 to allow for easier deployment to orgs that already have an earlier version of the datatable component
  
## 06/03/20 -  Eric Smith -    Version 2.2 
**Enhancements:**
-   Added datatable border attribute
 
**Updates:**
-   Fixed attribute parsing, Fixed Spinner
  
## 06/01/20 -  Eric Smith -    Version 2.1 
**Enhancements:**
-   Updated with features from v1.2 & v1.3                                                
  
## 04/22/20 -  Eric Smith -    Version 2.0 (Summer '20) 
**Enhancements:**
-   Summer '20 New Feature - Dynamic Object Type
-   One version of the component now supports ALL Standard & Custom SObjects
  
## 05/23/20 -  Eric Smith -    Version 1.3 
**Updates:**
-   Added support for a serialized JSON string of records of a user defined object
-   Added an attribute to specify the height of the datatable
-   Bug Fix - Fixed error when editing multiple rows           
  
## 05/06/20 -  Eric Smith -    Version 1.2 
**Updates:**
-   Handle lookup Objects without a Name field & 
-   Trap non-updatable Master/Detail fields
  
## 04/14/20 -  Eric Smith -    Version 1.1 
**Enhancements:**
-   New Column Attribute to support column filtering  
  
## 04/01/20 -  Eric Smith -    Version 1.0 
**Features:**
-   The only required paramters are the SObject collection of records and a list of field API names  
-   The field label and field type will default to what is defined in the object  
-   Numeric fields will display with the correct number of decimal places as defined in the object  
-   Lookup fields are supported and will display the referenced record's name field as a clickable link  
-   All columns are sortable, including lookups (by name)  
-   The selection column can be multi-select (Checkboxes), single-select (Radio Buttons), or hidden  
-   A collection of pre-selected rows can be passed into the component  
-   Inline editing is supported with changed values passed back to the flow  
-   Unlike the original datatable component, only the edited records will be passed back to the flow  
-   The maximum number of rows to display can be set by the user  
-   Optional attribute overrides are supported and can be specified by list, column # or by field name, including:  
 
                - Alignment               
                - Editable
                - Header Icon
                - Header Label
                - Initial Column Width
                - Custom Cell Attributes including those with nested values {name: {name:value}}               
                - Custom Type Attributes including those with nested values {name: {name:value}}
                - Other Custom Column Attributes including those with nested values {name: {name:value}}
  
---
