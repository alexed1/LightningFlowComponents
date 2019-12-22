# Flow Picker

This component allows you to select from a list of flows in the current org

## Supported attributes

`Flow Selector Label` - Set the text to appear above the Flow selection box;

`Placeholder text for selection box(default="- Select a Flow -")` - Set the placeholder text to appear in the Flow selection box;

`Store the API name of the selected Flow` - On output this stores the API name of the selected Flow, and the component can be initialized with a value on input;

`Show Active Flows Only?(default=false)` - If set to True, only active Flows will be displayed;

`Only show which Flow types? (default = Flow,AutolaunchedFlow)` - Comma separated list of Flow Process Types to be included (see: https://developer.salesforce.com/docs/atlas.en-us.api_meta.meta/api_meta/meta_visual_workflow.htm);

`Required?(default=false)` - If set to True, an error message will appear when trying to advance to the next screen without a selection;

`Flow Name Filter` - Set a value to search and filter the returned list of Flows.  This adds a LIKE %filtertext% to the Flow lookup.;

`Set component width (out of 12)(default=12)` - By dividing the full display area width into 12 equal sections, you can specify the percentage of the total width to be used by this component in 12ths.  For example a value of 9 would be 75% width, 6 would be 50% width, 3 would be 25% width.;
