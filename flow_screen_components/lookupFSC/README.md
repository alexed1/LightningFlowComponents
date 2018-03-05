# Lookup Combobox Control #

### A Flow Component solution  ###

This is a simple adaptation of the excellent [Lightning Lookup control](https://opfocus.com/lightning-lookup-input-field-2/) by [Opfocus](https://opfocus.com/).   

<img width="584" alt="screen shot 2018-02-11 at 8 38 20 pm" src="https://user-images.githubusercontent.com/3140883/36083801-c54a23ea-0f6b-11e8-8adf-10d2f35f131b.png">

## Install this Component Into Your Org ##

[Install this Component](/flow_screen_components/lookupFSC/mdapioutput/lookupFSC.zip).

See the full set of installation options [here](/install.md).

## How It Works ##

This component exposes the following attributes that can be set in Flow:

label="Object Name" This is the actual object that will be looked up

label="Display Which Field?" This is the field that will show up in the list box to represent a record. It's usually set to "Name"

label="Output Which Field as Value?" Here you can set which field you actually want saved into the Output Value attribute.

label="Field Label"  This is just the label that appears next to the lookup control

label="Output Value" This will hold the selection field. 



Here's an example of a configured component:
<img width="353" alt="screen shot 2018-02-11 at 8 48 18 pm" src="https://user-images.githubusercontent.com/3140883/36083917-ed8c32ca-0f6c-11e8-956d-82c674a92495.png">

## Lookup Filters ##
This control does not currently support Lookup Filters. That's on the roadmap. The design will probably allow the user to specify, in Flow, for each Lookup control,two additional strings: the name of an existing Lookup field and the name of an existing Object where that field lives. The control will then apply the LookupFilter associated with that field. 

## Resources ##

Want to suggest an improvement or report a bug? Do that [here](/issues)

[Learn more about how Flow Components work](/README.md)

Know a little javascript and want to add some improvements? {Pull requests are welcome}(/pulls) If you're thinking of adding much complexity to the user interface, though, you probably should fork the repo, because we want to keep this baseline version easy-to-use.







