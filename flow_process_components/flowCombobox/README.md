# Flow Combobox

This extended version of standard combobox lwc component, that enhanced to be aware of flow context. It provides user interface to filter and select flow variables.

## Public Attributes

`name` (required) - unique String, that represents name of the component, used as a key in "valuechange" events.

`label` (required) - String used to display a label above the combobox

`flowContext` (required) - flowContext attribute from parent Custom Property Editor (CPE)

`value` (optional) - String, determines value, the component will be initialized with, must be a valid value from flowContext. In case if variable of type SObject is passed on input, flowCombobox searches flowContext for object api name and then performs an attempt to fetch SObject fields from Salesforce Metadata. User is able to choose from fields of specific SObject. Also, it is possible to type in  a literal, so it will be passed in `valuechanged` event as it is with a valueType = `String`, if user chooses from one of flow variables or from SObject field, it will be considered as reference. All reference variables are surrounded by {!`variableName`} in edit mode, if user removes {! }, value will be converted in a literal automatically. If user types in a variable that is surrounded by {! }, component will perform an attempt to find this variable in flow context, and in case of failure will render an error, thus `reportValidity` public method will return `false`. If selected parameter is valid flowContext variable it will be rendered as a pill with no errors.

`valueType` (optional) - String(accepts only 'reference' or 'String'), that determines variable type, that is set on input in `value` public attribute. If not specified, will be set to "String"

`flowContextFilterType` (optional) - String, name of a flow context variable type, which will be available for select in combobox. All variables with type !== to this param will not be shown in the component. Can be omitted, in this case flowCombobox will allow to select any variable from flowContext  

`flowContextFilterCollectionBoolean` (optional) - Boolean, if true, flowCombobox will allow to chose only from collection variables

## Events

`valuechanged` - triggered any time some value is chosen or user clicks outside the component. Contains following structure in event.detail

{
    
    `id` - name of the component, comes from `name` public attribute
    
    `newValue` - selected value
    
    `newValueDataType` - data type of selected value
 
}

## Methods

`reportValidity` - returns `false` in case if component has any validation errors

## Search behavior 

Component allows to search for apiNames of flowContext variables, it only renders values that satisfy selected filter criteria (`searchString`, `flowContextFilterType`, `flowContextFilterCollectionBoolean`). For "String" type, however, it also shows SObject records, so user is able to choose from child String variables of an SObject. In case if user opened a variable of "SObject" type by clicking on ">" next to variable api name, user will be able to perform a search for fields inside this SObject. Component automatically determines SObject type and renders only its own set of fields.

