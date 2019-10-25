# Pick Object And Field FSC

It's often necessary when building Salesforce configuration UI to provide a way for a user to select an Object and/or select a field. This component provides an attractive lwc solution that can be used in another lwc components, flexipages or in Flows.

## Avaliable Parameters

`masterLabel` - Master label of the component

`objectLabel(default "Object")`- Label for "Choose Object" field 

`fieldLabel(default "Field")` - Label for "Choose Field" field 

`objectType `- initialization value for object name, supports all standard and custom objects

`field` - initialization value for field name, should be valid field on selected object, can not be specified if objectType is empty

`availableObjectTypes `- comma separated list of selectable object names, which should be available to select in  objectType field. If this value is not set, objectType will show all existing standard and custom objects

`availableFields()` - comma separated list of supported reference types, f.e. "User, Account" will result only fields of these types to be shown in "set field" component, all other references will be avoided.

`disableObjectPicklist( default = false) `- Object picklist is visible, but disabled. If this is true, a value must be provided for objectType

`hideObjectPicklist( default = false)` - Object picklist is hidden. If this is true, a value must be provided for objectType

`hideFieldPicklist( default = false)` - will show only object selection and field select will be hidden

`displayFieldType( default = false) `- if field is selected it will show field type
    
    