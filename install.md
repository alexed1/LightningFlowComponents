Different installation approaches can be used to install a Flow Component into your org:

1) Deploy a component or set of components by using a traditional zip file of metadata and a deployment tool like Workbench
2) Use SFDX to do a deploy from the command line
3) Carefully copy and paste one file at a time into your own developer console

## Installing as a zip file using Workbench
Each component has a mdapioutput folder which includes both the metadata and zipfile ready for deployment.

If you're not familiar with Workbench, it's time you learned this valuable tool! See {these resources}(https://www.youtube.com/results?search_query=salesforce+workbench)

The key things to remember are:
1) The org you're installing to needs to either be Spring '18 or have the Lightning Components in Flow Screens pilot enabled
2) Check the "Single Package" checkbox in Workbench
3) Keep in mind that some Flow Components consist of more than 1 Lightning Component, and the package may include additional metadata useful or necessary to use the Component (for example, the GetOracleViaAWS Action Component includes a CSP metadata that instructs your org to let Salesforce contact a public AWS endpoint). To see everything that's involved, check inside the mdapioutput folder

## Installing as a zip file using SFDX

Each component is added to this repository with its own SFDX project. Starting in the root of the component:
 
- if you want to push to a scratch org, run sfdx force:source:push
- if you want to deploy to a regular org:
  1. use sfdx force:metadata:deploy and point to the mdapioutput folder
        (sfdx force:mdapi:deploy -d mdapioutput/ -u MyOrgAlias -w 100)
  
Note: for great tutorials on all of this, see (https://trailhead.salesforce.com/trails/sfdx_get_started)


## Copy/Paste Install for Non-Developers
A video showing how to install a component with nothing more than copy and paste is [available here](https://drive.google.com/file/d/1f1ibaWk1ooeIbMLZXddJ2TRsSC0MSHB9/view?usp=sharing). However, it's safer to invest in learning how to use Workbench or SFDX.

Easier install tools are on the roadmap...
