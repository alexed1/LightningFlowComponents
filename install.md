# Installing Flow Components #

Hopefully the components you want to install will have a simple "click here to go to AppExchange and install with a click". However, newer components may not yet be approved for AppExchange. If you want to install them, you'll need to follow one of these 3 approaches::

Download the Component zip file from here, and then upload it to your Salesforce org using Workbench
OR
Use SFDX command line tools.
OR
Carefully copy and paste one file at a time into your own developer console

## Installing with Workbench
Each component has a download link in its Readme page that will download the entire component as a single zip file. Workbench is a website operated by Salesforce that allows you to upload zipped metadata files to your org. For several video introductions to Workbench, look [here](https://www.youtube.com/results?search_query=salesforce+workbench). Workbench is quite ugly but it's really straightforward to use, so if you haven't used it before, this might be a great time to learn. 

The key things to remember are:
1) The org you're installing to needs to be Spring '18 or later.
2) Check the "Single Package" checkbox in Workbench
3) Keep in mind that some Flow Components consist of more than 1 Lightning Component, and the package may include additional metadata useful or necessary to use the Component (for example, the GetOracleViaAWS Action Component includes a CSP metadata that instructs your org to let Salesforce contact a public AWS endpoint). To see everything that's involved, check inside the mdapioutput folder

## Installing as a zip file using SFDX

We are huge fans of the new SFDX deployment tools. If you're comfortable using the command line, you can easily deploy a component with standard SFDX commands. Each component in this repository lives in its own SFDX project. Starting in the root of the component:
 
- if you want to push to a scratch org, run sfdx force:source:push
- if you want to deploy to a regular org:
  1. use sfdx force:metadata:deploy and point to the mdapioutput folder
        (sfdx force:mdapi:deploy -d mdapioutput/ -u MyOrgAlias -w 100)
  
Note: for great tutorials on all of this, see (https://trailhead.salesforce.com/trails/sfdx_get_started)

Easier install tools are on the roadmap...
