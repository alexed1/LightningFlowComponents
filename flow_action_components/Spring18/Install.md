

**Installation Instructions - Flow Action Components**

**Install using SFDX**

1) Make sure that you are authenticated to your target org
2) from the root of the action component project, type:
sfdx force:mdapi:deploy -d mdapioutput/ -w 10 -u [username of target org]
Example:
alexed ~/dev/flowcomponents/flow_action_components/UpdateScreen $ **sfdx force:mdapi:deploy -d mdapioutput/ -w 10  -u eware@df17-cc-keynote.brightbank **

**Install manually**

Copy the files into a new set of Lightning Component files on the target org using your preferred development environment. (A video is on the way so non-developers can do the manual installation with just copy and paste).
