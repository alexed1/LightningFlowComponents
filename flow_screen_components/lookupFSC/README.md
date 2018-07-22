# Lookup Combobox Control #

### A Flow Component solution  ###

This is a simple adaptation of the excellent [Lightning Lookup control](https://opfocus.com/lightning-lookup-input-field-2/) by [Opfocus](https://opfocus.com/).   

<img width="584" alt="screen shot 2018-02-11 at 8 38 20 pm" src="https://user-images.githubusercontent.com/3140883/36083801-c54a23ea-0f6b-11e8-8adf-10d2f35f131b.png">

## Install this Component Into Your Org ##

[Install this Component](https://sites.google.com/view/flowunofficial/flow-screen-components/lookup).



## How It Works ##

There are several powerful filtering mechanisms now built into this component, and you probably won't need to use all of them at the same time.

Filter Using Flow Variables
This allows you to specify the name of the specific field you want to filter on. It's easy but basic.

Filter using a SOQL 'where' clause
This allows richer filtering. See 'Where Clause Usage' below

Dependent Filtering
You can stick two of these components on a screen and have the second component filter on the selection set in the first component. See example 2 
below


This component exposes the following attributes that can be set in Flow:

Basic Attributes
- label="I1_Object Name" This is the actual object that will be looked up
- label="I2_Display Which Field?" This is the field that will show up in the list box to represent a record. It defaults to "Name"
- label="I3_Field Label"  This is just the label that appears next to the lookup control
- label="I4_Output Which Field as Value?" This is the field you actually want saved into the Output Value attribute. It defaults to Id so you can hav ean Id to use for lookups, but you may want to change it to Name or some other value.
- label="O1_Output Value" This will hold the value that is selected, for use downstream in the flow.

Advanced Attributes

- label="I5_'Parent' or 'Child' Lookup?" If Child is entered, the filter value will be replaced by the value returned by the Parent lookup on the same screen. 

- label="I6_Filter on which field?" This is the name of the field to filter the lookup on.

- label="I7_Filter Value" This is the filter value for the lookup.

- label="Where Clause" allows the input of a "where" SOQL style filter to limit which values are available for selection.

- label="Default" You can specify a default value placeholder in the lookup field

Here's an example of a configured component:
<img width="353" alt="screen shot 2018-02-11 at 8 48 18 pm" src="https://user-images.githubusercontent.com/3140883/36083917-ed8c32ca-0f6c-11e8-956d-82c674a92495.png">

## NEW PARAMETER - Default Value Usage ##

You can enter a default value for the input field (I2_Display Which Field).  When provided, it will override any WhereClause and display the default value as Placeholder text in the input field.  You will still need to select the dropdown then select the single value that is displayed. If you start to overtype the input field, the default value will be cleared and the WhereClause (if provided) will be reset and the field will act like a normal filtered lookup with search.

## Where Clause Usage ##
Input is dependent on the fields available for the object selected for "Object Name".

For example, if you wish to return only accounts of type "Vendor" or "Partner" you could enter the Object Name: "Account" and the where clause: "Type='Vendor' or Type='Partner'"


## Filtered Lookup Examples ##

Example 1: Lookup a Case filtered by an Account where the ID is passed into the flow variable vInputAcctId

<img width="389" alt="screen shot 2018-04-15 at 10 17 54 am" src="https://user-images.githubusercontent.com/3140883/38781178-5b03fd42-4096-11e8-83c0-209ff8714cc5.png">

Example 2: Lookup an Account and a Contact on the same screen and only select from Contacts from the selected Account

<img width="384" alt="screen shot 2018-04-15 at 10 18 06 am" src="https://user-images.githubusercontent.com/3140883/38781180-5c2e98b2-4096-11e8-9275-99cefdfc53c6.png">    

## Resources ##

Want to suggest an improvement or report a bug? Do that [here](/issues)

[Learn more about how Flow Components work](/README.md)

Know a little javascript and want to add some improvements? {Pull requests are welcome}(/pulls) If you're thinking of adding much complexity to the user interface, though, you probably should fork the repo, because we want to keep this baseline version easy-to-use.







