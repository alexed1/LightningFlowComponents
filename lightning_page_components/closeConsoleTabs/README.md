# closeConsoleTabs
This is a generic Lightning Component that can be used in a Page Layout or on a Utility Bar.

It will close any open tabs and sub-tabs in a console application.

I wrote this component to solve the issue raised in this idea:

[Lightning Console: Close all tabs option](https://success.salesforce.com/ideaView?id=0873A000000lIMlQAM)

## Installation

In your Developer Console, select File > New > Lightning Component > Name: closeConsoleTabs > Submit
- For Component, replace everything shown with the contents of **closeConsoleTabs.cmp**
- For Controller, replace everything shown with the contents of **closeConsoleTabsController.js**
- For Design, replace everything shown with the contents of **closeConsoleTabs.design**

Then select File > Save All

## Parameters

The component takes a single parameter: Close Pinned Tabs?

The default is false, which will leave any pinned tabs open.  If set to true, then all tabs will be closed.

## Setup

When adding this component to a Utility Bar, I set: 
- **Label** to Close Tabs
- **Icon** to filter
- **Width** to 100
- **Height** to 75
- **Close Pinned Tabs?** to your choice of checked or unchecked

![Utility Bar Setup](UtilityBarSetup.jpg?raw=true)

## Usage

Select Close Tabs from the Utility Bar and press the Close Tabs button

![Utility Bar](UtilityBar.JPG?raw=true)
