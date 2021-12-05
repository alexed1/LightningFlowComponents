# Salesforce Lightning Hierarchy (LWC Version) 

![Image description](https://github.com/Sarveshgithub/LightningFlowComponents/blob/master/flow_screen_components/hierarchy/hierarchy.PNG?raw=true)



## About

This is generic lighting hierarchy , which is build in lwc ( tree grid ).
The customization are done by design attributes. At onload of page the component shows only first level of record, next level of record in hierarchy are shown on click of expandable button action, and make the call to server via async, There is no limit of any level in hierarchy. If record has no children then expendable option not visiable. For Usage, Drag `hierarchy` component in Screen element flow and details, Check `Follow Steps` Section.

## Use Case
Suppose you want to navigate all the children cases of a particular parent case. Starting with the parent case, you can use this component to easily explore all of the children. Then you can select one of the children and click next in the flow screen and navigate to that record using Navigate Everywhere action

Features
The data table has following features.
- Show records for both custom and standard object.
- Add cols as per the fields exist in object in JSON format.
- No limit for level of hierarchy

# Follow Steps
1) Open Flow drag screen element 
    ![Image description](https://github.com/Sarveshgithub/LightningFlowComponents/blob/master/flow_screen_components/hierarchy/Flow.PNG?raw=true)

2) Select `hierarchy` component from left side components drag to Screen
    ![Image description](https://github.com/Sarveshgithub/LightningFlowComponents/blob/master/flow_screen_components/hierarchy/Flow_LWC.PNG?raw=true)
    ![Image description](https://github.com/Sarveshgithub/LightningFlowComponents/blob/master/flow_screen_components/hierarchy/Flow_LWC2.PNG?raw=true)

3) Now add values in design attribute at left side, Check below `Steps to Customization through Design Attribute`
    ![Image description](./Flow_Builder_ScreenCast.gif)


## Steps to Customization through Design Attribute
Design Attribute

| Label           | Type       | Value                        | Example             |
|-----------------|------------|------------------------------|---------------------|
| Enter Icon Name  | String     | provide slds icon name  |  `standard:hierarchy` For diffrent icons options visit [slds-icons](https://www.lightningdesignsystem.com/icons/)|
| Enter Title      | String     | provide table title |  Hierarchy ( Any heading value can be enter)           |
| Enter Object API Name | String| provide object custom or standard API name|  Case |
| Enter Columns API Name (comma seprated) | String | CaseNumber,Subject,Origin| CaseNumber,Subject,Origin
Enter Parent field API Name | String | Enter Parent field API Name | Example: ParentId field is determine parent of Case record.
Enter RecordId | String | provide record id  | Example `recordId`



