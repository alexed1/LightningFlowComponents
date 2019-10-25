# Flow Picker LWC

This component allows to select flows which exist in current org

## Supported attributes

`label` - field label;

`selectedFlowApiName` - if flow is selected, its api name is recorded in this variable, also component can be initialized if value is passed from parent component;

`showActiveFlowsOnly(default=false)` - if true, shows only active flow components;

`required(default=false)` - if true, field becomes requoired and component will throw an error on attempt to navigate to next flow screen;

`showWhichFlowTypes(default='Flow,AutolaunchedFlow')` - specifies flow types;
