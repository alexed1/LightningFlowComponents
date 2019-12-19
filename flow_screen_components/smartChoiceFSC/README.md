# Express Choice FSC

This component allows to render "radio group"/"picklist" with predetermined groups of labels/values and store selected values for future use in flows.

## Avaliable Parameters

`masterLabel` - Component label
`choiceLabels` - Semicolon separated string of Labels (f.e. 'Label 1;Label 2;Label 3')
`choiceValues` - Semicolon separated string of Values (f.e. 'value1;value2;value3')
`displayMode` - Determines the way how component will be rendered. Supported values: 'Picklist' and 'RadioGroup'
`approvalProcessStepDefinitions` - Represents on object, which fields will be rendered as options;
`approvalProcessDefinitions` - Represents on object, which fields will be rendered as options;
`useWhichFieldForValue` - Semicolon separated string of Fields from corresponding object used as Values (f.e. 'Field1__c;Field2__c;Field3__c')
`useWhichFieldForLabel`- Semicolon separated string of Fields from corresponding object used as Labels (f.e. 'Field4__c;Field5__c;Field6__c')
`inputMode` - determines the source for labels and values;
`required` - if true, component shows an error if values is not selected.
    