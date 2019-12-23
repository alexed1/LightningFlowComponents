this is a work in progress.

Navigation logic lives in a couple of places right now. The most sophisticated logic may be in the navigationButtonFSC (https://github.com/alexed1/LightningFlowComponents/tree/master/flow_screen_components/navigationButtonFSC/force-app/main/default/aura/navigationButtonFSC)

The most recent work has been done in the Navigate to Record at https://github.com/alexed1/LightningFlowComponents/tree/master/flow_action_components/navigateToRecord

The code here took the navigateToRecord and added a mode for navigating to list views. It has not been packaged or published.

What should basically happen here is that the different options that are available via lightning:navigation, as described here (https://developer.salesforce.com/docs/atlas.en-us.lightning.meta/lightning/components_navigation_page_definitions.htm) should be added to this new NavigateEverywhere component. Once that's done, we should retire the old components at:

https://github.com/alexed1/LightningFlowComponents/tree/master/flow_action_components/Summer18/NavigateToRelatedList
https://github.com/alexed1/LightningFlowComponents/tree/master/flow_action_components/Summer18/NavigateToSObject

if possible, we should make it so that the navigationButtonFSC uses the same shared javascript file.
