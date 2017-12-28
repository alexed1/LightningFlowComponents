
This folder contains a collection of Lightning Components that can be used to enhance Lightning Flow from Salesforce.


# Lightning Flow Screen Components
flow_screen_components contains lightning components (aura classes) that have been optimized to be inserted into Lightning Flow screens. This mainly means that they:
1) implement the "lightning:availableForFlowScreens" interface so they appear in and can be dragged into Screen Nodes that are added to Flows susing the the Salesforce Cloud Flow Designer (and upcoming Lightning Flow Builder)
2) give attention to their design files because only attributes added to the design file show up in Cloud Flow Designer as available for mapping to and from Lightning Flow variables

Flow Screen Components generally have a visual focus, although they don't absolutely have to.

Flow Screen Components are generally available as of Spring '18. 


# Lightning Flow Action Components
flow_action_components contains lightning components (aura classes) that have been optimized to be added to Lightning Flows as standalone actions. This mainly means that they:
1) implement the "flowruntime:availableForLocalInvocableActions" interface so they show up in the tools palette of Cloud Flow Designer as Local Actions that can be dragged onto the canvas and added to flows as discrete actions. 
2) provide an #invoke method that allows the Flow engine to call them at the appropriate point during flow execution, and make a callback to the engine when they're done

Flow Action Components generally do not have a visual focus, although they have to run in Screen Flows to ensure the presence of a client-side javascript runtime.

Flow Action Components are available in pilot status as of Spring '18. For information on the pilot see https://github.com/alexed1/LightningFlowComponents/blob/master/flow_action_components/README.md

# [A Note about SFDX](./sfdxintro.md)

# Submissions Encouraged!
Have you built a useful or interesting Flow Component? We encourage you to make a pull request and add it to this repo. Also feel free to enhance or fix any existing component.

