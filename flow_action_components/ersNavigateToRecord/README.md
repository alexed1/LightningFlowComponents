# navigateToRecord
This is a generic Lightning Flow Action Component that can be used at the end of a Flow to load a Salesforce Record page.  You can specify whether to open the record in Edit or View mode.

I wrote this component to solve the issue raised in this idea:

[NavigateToSObject improvement request (#180)](https://github.com/alexed1/LightningFlowComponents/issues/180)

## Installation

In your Developer Console, select File > New > Lightning Component > Name: navigateToRecord > Submit
- For Component, replace everything shown with the contents of **navigateToRecord.cmp**
- For Controller, replace everything shown with the contents of **navigateToRecordController.js**
- For Design, replace everything shown with the contents of **navigateToRecord.design**

Then select File > Save All

## Parameters

The component takes three parameters
- **Object** - SObject Type of the Record (Account, Case, Opportunity, Custom__c, etc)
- **Record ID** - Record Id of the record to display (This can be the Id of a new record created in the Flow)
- **View or Edit?** - Default (View), Select what mode you want to be in when switching to the record.

## Setup

Drag the Action Element onto your Flow Canvas, select navigateToRecord and provide Input Values for the 3 parameters.  If this element is the last one in your Flow, the user will be redirected to the defined record screen in the selected mode.

## Important Operations Notes

This flow action does NOT work when run from Flow Setup. It ONLY works when run on a Lightning Page. 
