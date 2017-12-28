

# Lightning Flow Screen Components
flow_screen_components contains lightning components (aura classes) that have been optimized to be inserted into Lightning Flow screens. This mainly means that they:
1) implement the "lightning:availableForFlowScreens" interface so they appear in and can be dragged into Screen Nodes that are added to Flows susing the the Salesforce Cloud Flow Designer (and upcoming Lightning Flow Builder)
2) give attention to their design files because only attributes added to the design file show up in Cloud Flow Designer as available for mapping to and from Lightning Flow variables

Flow Screen Components generally have a visual focus, although they don't absolutely have to.

Flow Screen Components are generally available as of Spring '18. 


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
