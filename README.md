
A collection of installable extensions for Salesforce Flow. Note that you do not need to write code, read code, or use developer console to install these into your Flow Builder! You can install many of these components as packages over at [UnofficialSF](http://unofficialsf.com). 


# Flow Screen Components
/flow_screen_components contains lightning components (a mix of aura and lwc) that have been optimized to be insertable into Lightning Flow screens. This mainly means that they:
1) implement the Flow Screen interface. This causes them to appear in the palette of the Screen Builder in Flow Builder, where they  can be dragged into Screen Nodes.
2) explicitly specify which component attributes will be visible as inputs or outputs in Flow.  

Flow Screen Components generally have a visual focus, although they don't absolutely have to.


#  Flow Actions
/flow_action_components contains Apex classes and Lightning Components  that have been optimized to be added to Lightning Flows as standalone actions. 

### Apex Actions
The Apex Classes are [Invocable Actions](https://unofficialsf.com/developing-flow-actions/). They are non-visual and execute entirely in the Salesforce cloud.

### Local Actions (Lightning Component (Javascript))
Lightning Components that are designed to act as actions are referred to as [Local Actions](https://unofficialsf.com/understanding-flow-local-actions/). 

This mainly means that they:
1) implement the "flowruntime:availableForLocalInvocableActions" interface so they show up in the tools palette of Flow Buider as Local Actions that can be dragged onto the canvas and added to flows as discrete nodes. 
2) provide an #invoke method that allows the Flow engine to call them at the appropriate point during flow execution, and make a callback to the Flow engine when they're done.

Local Actions generally do not have a visual focus, although they have to run inside of Screen Flows to ensure the presence of a client-side javascript runtime.

# Flow Apps
This directory contains utilities and tools that don't fall neatly into one of the above two main categories of extensions.

# Setup Notes
Before adding any lightning component to your flow, your org must be enabled for lightning components. This means:
1) you must have My Domain enabled and deployed
2) you must have the "Enable Lightning Runtime for Flows" checkbox enabled in Setup - Process Automation Settings

You do not need to be using the lightning experience to use these flow extensions.

# Submissions Encouraged!
Have you built a useful or interesting Flow Component? We encourage you to make a pull request and add it to this repo. Also feel free to enhance or fix any existing component. General conversations about these components are carried out in the Issues section above and at these communities:
[UnofficialSF Trailblazer Community](https://trailhead.salesforce.com/trailblazer-community/groups/0F93A000000DPr6SAG?tab=discussion)
[Salesforce Automation Trailblazer Community](https://success.salesforce.com/_ui/core/chatter/groups/GroupProfilePage?g=0F9300000001rzcCAA).


