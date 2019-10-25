# Pick Obkect And Field FSC

This component allows to select object and a field on that object. Can be used in another lwc components, flexi pages or in lightning flows.

## Avaliable Parameters

`masterLabel(optional)` - Master label of the component

`objectLabel(optional;default "Object")`- Label for "choose Object" field 

`fieldLabel(optional;default "Field")` - Label for "choose Field" field 

`objectType(optional) `- initialization value for object name, supports all standard and custom objects

`field(optional)` - initialization value for field name, should be valid field on selected object, can not be specified if objectType is empty

`supportedObjectTypes(optional) `- comma separated list of object names, which should be available to select in  objectType field. If not determined objectType will show all existing standard and custom objects

`supportedFieldRelationTypes(optional)` - comma separated list of supported reference types, f.e. "User, Account" will result only fields of these types to be shown in "set field" component, all other references will be avoided.

`objectDisabled(optional; default = false) `- will disable object select picklist, in this case objectType is required

`hideObjectTypeSelect(optional; default = false)` - will not show object select picklist, in this case objectType is required

`hideFieldSelect(optional; default = false)` - will show only object selection and field select will be hidden

`showFieldType(optional; default = false) `- if field is selected it will show field type
    
    