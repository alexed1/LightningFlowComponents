# Work Guide Component

## New Org Set Up

Work guide component works with the following custom objects:
AppProcessDefinition__c - holds step to flow and stage to step mappings 
AppProcessInstance__c - represents an instance of the process

In order to setup the data it is mandatory to manually create AppProcessDefinition__c record and set the proper mappings

StepFlowMappings example:
In this example we are mapping step Approval to flow with api name "ApprovalStep", Finalization step to "finalFlow" flow, etc...
```json
{
    "Approval" : "ApprovalStep", 
    "Finalization" :"finalFlow",
    "Review" : "HelloWorld"
}
```

StageStepMappings example:
One Stage can contain multiple steps, in the above example we are mapping "Prepare to Publish" stage to the "Approval" and "Review" steps and "Published" stage is only mapped to "Finalization" step

```json
{
	"Prepare to Publish": [
		"Approval",
		"Review"
	],
	"Published": [
		"Finalization"
	]
}
```

In order to run the Work Guide on some record you need to create an instance of the process (AppProcessInstance__c) and link it to existing AppProcessDefinition__c
Field descriptions:
UserId - holds user Id for the current instance, if there are multiple instances related to one object, user will only see it if his/her id is specified in this field
RecordId - holds the instance record Id, for example (Account, Contact Id)
Current Stage - must have stage that was previously described in the definition object, in our case "Prepare to Publish" would be a correct value
Current Step - must have Step that was previously described in the definition object, in our case "Approval" would be a correct value
App Process Definition - Id of related Process Definition

With the following values:

Current Stage = Prepare to Publish
Current Step = Approval

The component will render a flow with name "ApprovalStep"

## Object Page setup 

Since this is just a regular LWC you would need to drag it on the objects flexipage in order to see it in action. The component itself has only one parameter, which sets the height of the component in pixels.

##Flow Prerequisites 

All flows that are specified in mappings must have the following public variables defined:

appProcessInstanceId
appProcessStepName
recordId

These attributes will be automatically populated with the data from the current Process Instance

##Events

Whenever the flow changes its status the component fires a platform event (AppProcessEvent__e), this can be then catched by some other salesforce automations and perform additional actions if necessary.
