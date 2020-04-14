# datatableLwcFsc

## Lightning Web Component for Flow Screens    

This component allows the user to configure and display a datatable in a Flow screen.

Additional components packaged with this LWC:

                    Lightning Web Components:   

                    Apex Classes:               SObjectController 
                                                SObjectControllerTest

04/01/20 -  Eric Smith -    Version 1.0

Features:
* The only required paramters are the SObject collection of records and a list of field API names
* The field label and field type will default to what is defined in the object
* Numeric fields will display with the correct number of decimal places as defined in the object
* Lookup fields are supported and will display the referenced record's name field as a clickable link
* All columns are sortable, including lookups (by name)
* The selection column can be multi-select (Checkboxes), single-select (Radio Buttons), or hidden
* A collection of pre-selected rows can be passed into the component
* Inline editing is supported with changed values passed back to the flow
* Unlike the original datatable component, only the edited records will be passed back to the flow
* The maximum number of rows to display can be set by the user
* Optional attribute overrides are supported and can be specified by list, column # or by field name, including:
  * Alignment
  * Editable
  * Header Icon
  * Header Label
  * Initial Column Width
  * Custom Cell Attributes with nested values {name: {name:value}}
  * Custom Type Attributes with nested values {name: {name:value}}
  * Other Custom Column Attributes with nested values {name: {name:value}}


04/14/20 -  Eric Smith -    Version 1.1

Additions:  New Column Attribute to support column filtering


