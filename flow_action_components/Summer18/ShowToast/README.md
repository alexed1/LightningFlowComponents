

# Show Toast #

### A Lightning Flow Extension  ###

This local action will pop up a toast message

## Install this Component Into Your Org ##

[Install this Component](https://sites.google.com/view/flowunofficial/flow-local-actions/show-toast).

## How It Works ##

This action uses the [force:showToast event](https://developer.salesforce.com/docs/component-library/bundle/force:showToast/specification)

It takes two attributes. "type" determines the look and behavior of the toast. Allowable values are success, warning, info, error. Default value is 'success'.

The "message" attribute will contain the text you want displayed in the pop-up.

IMPORTANT! This action will _only_ work in Flows executing in Lightning pages.
It will not work if run from Flow Setup, even if you are in Lightning Experience mode.
It will not work if run in a VF page in Classic.
This is due to a limitation of the underlying event. For more information, see this [documentation](https://developer.salesforce.com/docs/atlas.en-us.lightning.meta/lightning/ref_force_navigateToURL.htm) 


## Resources ##

Want to suggest an improvement or report a bug? Do that [here](/issues)

[Learn more about how Flow Components work](/README.md)

Know a little javascript and want to add some improvements? {Pull requests are welcome}(/pulls) If you're thinking of adding much complexity to the user interface, though, you probably should fork the repo, because we want to keep this baseline version easy-to-use.
