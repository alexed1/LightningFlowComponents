# Salesforce Lightning Data table (LWC Version) 

![Image description](./hierarchy.png)

## About

This is generic lighting hierarchy , which is build in lwc.
The customization are done by design attributes. At onload of page the component shows only first level of record, next level of record in hierarchy are shown on click of expandable button action, and make the call to server via async, There is no limit of any level in hierarchy. If record has no children then expendable option not visiable.

Features
The data table has following features.
- Show records for both custom and standard object.
- Add cols as per the fields exist in object in JSON format.

## Steps to Customization through Design Attribute
Design Attribute

| Label           | Type       | Value                        | Example             |
|-----------------|------------|------------------------------|---------------------|
| Enter Icon Name  | String     | provide slds icon name  |  `standard:hierarchy` |
| Enter Title      | String     | provide table title |  Hierarchy               |
| Enter Object API Name | String| provide object custom or standard API name|  Case |
| Enter Columns JSON | String | { `fieldName`:api name,`label`:col label,`type`:text,number,date }| See below **Column JSON Example**
Enter Parent field API Name | String | Enter Parent field API Name | Example: ParentId field is determine parent of Case record.
Enter Top most Parent Id ( Only for Screen Flow ) | String | provide record id for screen flow i.e for home page | Example `recordId`

## Columns JSON Example
``` yaml 
    [{
        "type": "text",
        "fieldName": "CaseNumber",
        "label": "Case Number"
    }, {
        "type": "text",
        "fieldName": "Subject",
        "label": "Subject"
    }, {
        "type": "text",
        "fieldName": "Origin",
        "label": "Origin"
    }
]

