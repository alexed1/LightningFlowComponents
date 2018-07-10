# NavigateToRelatedList - Finish your Flow with a Flourish #

### A Flow Action extension  ###

This Flow element causes your web browser to load a related list page.  
[Watch an example](https://youtu.be/Yv8MD39B3n0)


## Install this Component Into Your Org ##

[Install this Component](https://sites.google.com/view/flowunofficial/flow-local-actions/navigate-to-relatedlist).

Note these [Important Setup Notes](/README.md)

Important Operations Notes:
This flow action does NOT work when run from Flow Setup. It ONLY works when run on a Lightning Page. (Even if you're using Lightning Experience, the Flow Setup page is an old "Classic" page, and has some limitations in how it executes flows. )

## How It Works ##

This component requires:
parentRecordId	String	The ID of the parent record.	Yes
relatedListName	  String	The API name of the related list to display, such as “Contacts” or “Opportunities”. Note that for custom object lookup relationships, this gets expressed as "PartsRequests__r", with plural label and a 'r' suffix.

[Watch an example](https://youtu.be/Yv8MD39B3n0)


## Resources ##

Want to suggest an improvement or report a bug? Do that [here](/issues)

[Learn more about how Flow Components work](/README.md)

Know a little javascript and want to add some improvements? {Pull requests are welcome}(/pulls) If you're thinking of adding much complexity to the user interface, though, you probably should fork the repo, because we want to keep this baseline version easy-to-use.
