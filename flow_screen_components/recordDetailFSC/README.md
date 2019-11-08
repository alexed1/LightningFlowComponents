# Record Detail LWC Component

This component displays fields from a record and allows them to be directly edited. It takes as an input a comma-separated list of fields for specified record 

## Attributes

recordId  - The record we are displaying

mode - can be either 'edit' or 'view'. When edit mode selected, a "Save" button is displayed. Default is 'view'.

elementSize  - Size of each field. Can take values from 1 till 12. The bigger value is the more space element occupies on the layout. One line can hold up to 12 size points, so in case if you have 4 elements and each of them has size = '4', this will render two lines with first 3 fields in first line and the last one in a second line. Default is 6. For more information on using sizing, see https://developer.salesforce.com/docs/component-library/bundle/lightning:layout/documentation
