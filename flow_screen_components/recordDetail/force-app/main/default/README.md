# Record Detail LWC Component

This component is designed to take comma separated list of fields for specified record and show it on layout.

## Public attributes

recordId  - Salesforce id of a record we are displaying details for
mode - can be either 'edit' or 'view', determines either user is able to edit current record or not. In case if edit mode selected, "Save" button will be renderred so record can be saved.
elementSize  - Size of each field. Can take values from 1 till 12. The bigger value is the more space element occupies on the layout. One line can hold up to 12 size points, so in case if you have 4 elements and each of them has size = '4', this will render two lines with first 3 fields in first line and the last one in a second line