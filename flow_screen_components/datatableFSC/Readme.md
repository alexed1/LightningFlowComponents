

# Datatable #

### A [Flow Screen Component](flow_screen_components/README.md)  ###

The Datatable_FlowScreenComponent is derived from the [datatable lightning base component](https://developer.salesforce.com/docs/atlas.en-us.lightning.meta/lightning/aura_compref_lightning_datatable.htm) .

The datatable is populated by passing in an SObjectCollectionVariable. 

NOTE: This is  currently NOT a fully declarative screen component (meaning that you can't use it without modifying code)The FlowScreens interface does not yet support dynamic object types, so it's necessary to define, in the cmp file, the type that you're going to be passing in. In the example below, the attribute myData is set to the exact custom object type that will be passed.

<img width="773" alt="screen shot 2018-01-21 at 10 06 34 pm" src="https://user-images.githubusercontent.com/3140883/35207368-690c34c6-fef7-11e7-96cb-eaad11cef0e5.png">

(The goal we're working towards is where the Datatable will be able to receive any object from Flow and not care what it is until runtime.)

The selected rows are made available to the Flow via the selectedRows attribute, which is also a collection of a specific Salesforce SObject.

<img width="1003" alt="screen shot 2018-01-21 at 9 55 25 pm" src="https://user-images.githubusercontent.com/3140883/35207085-dada1e44-fef5-11e7-82cf-4c4edf8a2060.png">


## Install this Component Into Your Org ##

[Installation information for this component](https://sites.google.com/view/flowunofficial/flow-screen-components/datatable).


## Instructions ##

[Video introduction](https://youtu.be/UUcBkpYhYUg)
The core datatable component is described [here](https://developer.salesforce.com/docs/atlas.en-us.lightning.meta/lightning/aura_compref_lightning_datatable.htm).

Currently Flow gives you the opportunity to define up to 5 columns. For each column that you want to use, specify the label you want to see, the API name of the field you want to see, and the type that Datatable should interpret the data as.

The basic mechanism for using a datatable is:
1) Determine the object you're going to list in the table
2) Edit your component to set the type of myData and selectedRows to be collections of that object:
<img width="773" alt="screen shot 2018-01-21 at 10 06 34 pm" src="https://user-images.githubusercontent.com/3140883/35207368-690c34c6-fef7-11e7-96cb-eaad11cef0e5.png">
3) Load in the set of list values by doing a RecordLookup or FastLookup. Make sure you extract field values corresponding to the columns you're going to be displaying.
4) After the Datatable, Loop over the selectedRows and process the rows that were selected.


## Roadmap ##

Most of the functionality of this underlying base component has not yet been exposed to Flow. We welcome assistance expanding the range of utility of Flow Components.

## Resources ##

Want to suggest an improvement or report a bug? Do that [here](https://github.com/alexed1/LightningFlowComponents/issues)

[Learn more about how Flow Components work](/README.md)

Know a little javascript and want to add some improvements? {Pull requests are welcome}(/pulls) If you're thinking of adding much complexity to the user interface, though, you probably should fork the repo, because we want to keep this baseline version easy-to-use.
