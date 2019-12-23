# Smart Choice FSC

This component allows to render "radio group"/"picklist" with predetermined groups of labels/values and store selected values for future use in flows.

## Avaliable Parameters

`masterLabel` - Component label

`displayMode` - Determines the way how component will be rendered. Supported values: 'Picklist' and 'RadioGroup'

`Choices (String Collection)` - pass in a String collection. Note that this package includes an action that extracts fields from sobject collections. Check out the demo flow.

`inputMode` - determines the source for labels and values. right now the only supported value is 'String Collection'

`required` - if true, component shows an error if values is not selected.
    
