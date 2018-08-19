
# Load Web Page - Bring up new content in a new browser tab #

### A Lightning Flow Extension  ###

This local action will load a web page into another tab in your browser.

## Install this Component Into Your Org ##

[Install this Component](https://sites.google.com/view/flowunofficial/flow-action-components/load-web-page).

See the full set of installation options [here](/install.md).

## How It Works ##

It takes a URL as an argument. You can pass a complete URL or construct one using flow variables and formulas.

IMPORTANT! This action will _only_ work in Flows executing in Lightning pages.
It will not work if run from Flow Setup, even if you are in Lightning Experience mode.
It will not work if run in a VF page in Classic.
This is due to a limitation of the underlying event. For more information, see this [documentation](https://developer.salesforce.com/docs/atlas.en-us.lightning.meta/lightning/ref_force_navigateToURL.htm) 

IMPORTANT! There are different versions for Spring '18 and Summer '18+. Make sure you install the correct version.

## Resources ##

Want to suggest an improvement or report a bug? Do that [here](/issues)

[Learn more about how Flow Components work](/README.md)

Know a little javascript and want to add some improvements? {Pull requests are welcome}(/pulls) If you're thinking of adding much complexity to the user interface, though, you probably should fork the repo, because we want to keep this baseline version easy-to-use.
