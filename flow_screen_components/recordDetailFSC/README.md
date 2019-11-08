# Record Detail LWC Component

This component displays fields from a record and allows them to be directly edited. It takes as an input a comma-separated list of fields for specified record 

## Attributes

recordId  - The record we are displaying

mode - can be either 'edit' or 'view'. When edit mode selected, a "Save" button is displayed. Default is 'view'.

fields - comma separated list of fields to be rendered, if empty component will fetch all fields from current object