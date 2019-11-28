# Dual List Box 

This package contains two lwc components: generic dualListBox, which can be used everywhere in lightning environment and wrapper for this component, which can be used in flows. 
It is based on standard lightning-dual-listbox lwc component and inherits all inputs from it, but extends functionality with own attributes. It can accept String, List<String> or ApexDefined object on input and throw selected values back in format of admins choice.

## dualListBox - generic lwc

### Attributes

#### options
Input options, which will be renderred in left side of dualListBox. 
##### Supported types: 
csv - comma separated string of values ('Id,Name,WebSite') 
list - array of strings (['value1','value2','value3','value4'])
object - any object with own set of fields
#### selectedValues
Contains values that are preselected and showed in right side of dualListBox
##### Supported types: 
csv - comma separated string of values ('Id,Name,WebSite') 
list - array of strings (['value1','value2','value3','value4'])
#### optionsInputType
expects one of these types csv,list. Determines logic for parsing value that is set on input
#### optionsOutputType
csv,list,object. Determines type of data, which will be given back in selectedValues field.
#### optionsType
csv,list,object. Type of data which is set on input in 'options' attribute
#### valueFieldName (default='value')
Important only for output type = 'object'. Allows to choose a field on object, that is going to be used for output values. In case if object that is passed on input does not contain field 'value', or developer wants to use some other field for value. 
#### labelFieldName(default='label')
Important only for output type = 'object'. Same as above but for label
#### useValueAsOutput(default=false)
If set to true, output parameters will contain values, otherwise labels.

## dualListBoxFSC

This is a wrapper for generic dualListBox component that allows inserting it to flows and accepting different types on input. In current version we use Apex Defined class for input data.
Inherits all standard attributes from lightning-dual-listbox and valueFieldName;labelFieldName;useValueAsOutput from generic dualListBox lwc

 ### Attributes
Admin must specify only one of following  fullItemSetStringList;fullItemSetCSV;options. This attributes specify all options for dualListBoxFSC. Output attributes, however, can be used all together, so in case if in flows we need to get output in all possible types (csv;list,object) we can refer to corresponding output attributes (selectedItemsCSV;selectedItemsStringList;values)
#### fullItemSetStringList
array of strings (['value1','value2','value3','value4'])
#### selectedItemsStringList
Output array of strings (['value1','value4'])
#### fullItemSetCSV
comma separated string of values ('Id,Name,WebSite') 
#### selectedItemsCSV 
Output comma separated string of values ('Id,WebSite')
#### options
In this version options are limited to apex://FieldDescriptor[] type and are retrieved via invocable apex action called GetFieldInformation
#### values
output values with type apex://FieldDescriptor[]

## GetFieldInformation apex action

This action allows to get object describe data for any object type that is given on input.

### Attributes
#### Input
##### objectName (type String)
Any standard or custom object in Salesforce (Account, Case, Custom__c)
#### Output
##### fields (type List<FieldDescriptor>)
Returns List of flied descriptions for the object. 

### FieldDescriptor Supported Attributes
Currently FieldDescriptor supports only following attributes: name, label, type, required. But can be easily extended by developer if required
 
