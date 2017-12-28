# Lightning Flow Action Components

flow_action_components contains lightning components (aura classes) that have been optimized to be added to Lightning Flows as standalone actions. This mainly means that they:
1) implement the "flowruntime:availableForLocalInvocableActions" interface so they show up in the tools palette of Cloud Flow Designer as Local Actions that can be dragged onto the canvas and added to flows as discrete actions. 
2) provide an #invoke method that allows the Flow engine to call them at the appropriate point during flow execution, and make a callback to the engine when they're done

Flow Action Components generally do not have a visual focus, although they have to run in Screen Flows to ensure the presence of a client-side javascript runtime.

Flow Action Components are available in pilot status as of Spring '18. You can request that your org be enabled for them by contacting customer support. Tell customer support that you're a very responsible person and would like your org to be enabled with the "“**Flows Can Use Local (JavaScript) Elements**” permission.

# A Note about SFDX
This folder is an sfdx project. You don't have to use SFDX in order to access these components. Each component has its own folder inside force_app/default/main/aura, and you can simply copy and paste the component files to your development environment and deploy your usual way. However, we recommend you give SFDX a try. It makes deployment of components like these a matter of a few command line keystrokes, and we think it's wonderful. Also, it's free. Learn more at:

https://developer.salesforce.com/platform/dx

You may also want to check out the Lightning Flow Screen Components, which are designed to be inserted into flow screens. They're available elsewhere in this repo.

# Submissions Encouraged!
Have you built a useful or interesting Flow Component? We encourage you to make a pull request and add it to this repo. Also feel free to enhance or fix any existing component.



