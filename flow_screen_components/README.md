

# Lightning Flow Screen Components
flow_screen_components contains lightning components (aura classes) that have been optimized to be inserted into Lightning Flow screens. This mainly means that they:
1) implement the "lightning:availableForFlowScreens" interface so they appear in and can be dragged into Screen Nodes that are added to Flows susing the the Salesforce Cloud Flow Designer (and upcoming Lightning Flow Builder)
2) give attention to their design files because only attributes added to the design file show up in Cloud Flow Designer as available for mapping to and from Lightning Flow variables

Flow Screen Components generally have a visual focus, although they don't absolutely have to.

Flow Screen Components are generally available as of Spring '18. 


# A Note about SFDX
This folder is an sfdx project. However, you don't have to use SFDX in order to access these components. Each component has its own folder inside force_app/default/main/aura, and you can simply copy and paste the component files to your development environment and deploy your usual way. However, we recommend you give SFDX a try. It makes deployment of components like these a matter of a few command line keystrokes, and we think it's wonderful. Also, it's free. Learn more at:

https://developer.salesforce.com/platform/dx

https://trailhead.salesforce.com/en/trails/sfdx_get_started


You may also want to check out the Lightning Flow Action Components, which are designed to be inserted into flows as standalone actions. They're available elsewhere in this repo.

# Submissions Encouraged!
Have you built a useful or interesting Flow Component? We encourage you to make a pull request and add it to this repo. Also feel free to enhance or fix any existing component.
