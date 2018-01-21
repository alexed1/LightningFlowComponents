
The Datatable_FlowScreenComponent is derived from the [datatable lightning base component](https://developer.salesforce.com/docs/atlas.en-us.lightning.meta/lightning/aura_compref_lightning_datatable.htm) .

The datatable is populated by passing in an SObjectCollectionVariable. The FlowScreens interface does not yet support dynamic object types, so it's necessary to define, in the cmp file, the type that you're going to be passing in:

<aura:component implements="lightning:availableForFlowScreens">
    <aura:attribute name="mydata" type="Custom_Debit_Card__c[]"/>
    
As a result, this is not currently a fully declarative screen component (meaning that you can't use it without modifying code)

The selected rows are made available to the Flow via the selectedRows attribute, which is also a collection of a specific Salesforce SObject.


