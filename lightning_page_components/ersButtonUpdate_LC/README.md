# gwiButtonUpdate_LC

This is a generic Lightning Component to use a button to set a single field value in a record.

I created this to replace JavaScript buttons that I had primarily been using to set values in fields with the purpose of triggering a Process Builder.

## Sample JavaScript Button

This is a sample JavaScript button that sets the value of a custom field in the Opportunity record.

```javascript
{!REQUIRESCRIPT("/soap/ajax/31.0/connection.js")} 

var myquery = "SELECT Id, Name, Trigger_OSP__c FROM Opportunity WHERE Id = '{!Opportunity.Id}' limit 1"; 

sforce.connection.sessionId = "{!$Api.Session_ID}"; 
result = sforce.connection.query(myquery); 
records = result.getArray("records"); 

var myObject = records[0]; 
var updateRecord = new Array(); 

myObject.Trigger_OSP__c = true; 
updateRecord.push(myObject); 

result = sforce.connection.update(updateRecord); 

if(result[0].getBoolean("success")){ 
window.location = "/" + "{!Opportunity.Id}"; 
}else{ 
alert('Could not Trigger Process: '+result); 
}
```

## Using the Component

You can use this Lightning Component on a Page, in a Tab or as a Quick Action.  Some of the parameters are required and some are optional.

### Parameters

#### _(Required)_

- **Button Label** - Text to appear on the button

- **Name of Field to Update** - API name of the field to be updated

#### _(Optional)_

- **New Field Value** - Value to update the field with (Default = true)

- **Field Type** - Data type of the field to be updated (Default = Boolean)

- **Success Message** - When provided, a pop-up toast message will display after the record is updated.

#### Valid **Field Type** Values and Formats

Boolean - true or false

String - any characters

Date - yyyy-mm-dd

Datetime - yyyy-mm-dd hh:mm:ss

Time - hh:mm:ss

Integer - digits without any decimal places (32 bits)

Long - digits without any decimal places (64 bits)

Decimal - digits with decimal places (use for currency)

Double - digits with decimal places

## Sample Usage

This example is inserting the component in a tab on a record page.

![Setup Page](Page%20Setup.PNG?raw=true)

This is what the button looks like when the tab is selected.

![Button](Button.PNG?raw=true)

When the button is pressed, the record is updated, the button changes from 'brand' to 'neutral' style, and if a success message is provided a toast message will pop-up.

![Selected](Selected.PNG?raw=true)






