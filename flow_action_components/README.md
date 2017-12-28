# Lightning Flow Action Components

flow_action_components contains lightning components (aura classes) that have been optimized to be added to Lightning Flows as standalone actions. This mainly means that they:

1. implement the "flowruntime:availableForLocalInvocableActions" interface so they show up in the tools palette of Cloud Flow Designer as Local Actions that can be dragged onto the canvas and added to flows as discrete actions. (Note: the name of this interface will change when this feature becomes Generally Available."
2. provide an #invoke method that allows the Flow engine to call them at the appropriate point during flow execution, and make a callback to the engine when they're done

Flow Action Components generally do not have a visual focus, although they have to run in Screen Flows to ensure the presence of a client-side javascript runtime.

# Requesting Pilot Access

Flow Action Components are available in pilot status as of Spring '18. You can request that your org be enabled for them by contacting customer support. Tell customer support that you're a very responsible person and would like your org to be enabled with the "“**Flows Can Use Local (JavaScript) Elements**” permission.

## [A Note about SFDX](../sfdxintro.md)

## Installation
### Old-Style
# Drill down into the aura folder and pick a component you're interested in.
# In your dev environment of choice, create a lightning component on your target org with the same name.
# Copy the files over to your dev environment, recreating the file structure of the component.
# Deploy your component to your org (if you're working in Dev Console, of course, you don't need to do this)

### Using SFDX-Fu
   [See the SFDX deployment instructions](../sfdx_install.md)


# Submissions Encouraged!
Have you built a useful or interesting Flow Component? We encourage you to make a pull request and add it to this repo. Also feel free to enhance or fix any existing component.



