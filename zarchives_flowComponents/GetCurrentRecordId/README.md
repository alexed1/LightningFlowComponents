
# GetCurrentRecordId  #

### A Lightning Flow Extension  ###

This local action is designed to be put into flows that are run from record pages via Quick Action buttons. It enables the Flow launched from the button to get the recordId of the page it's on. 

This is a workaround that addresses the fact that the Quick Action interface lets you easily launch Flows but does not pass the recordId (or any other parameters) to the flow.

[Watch the Video](https://youtu.be/R3hSOEVES8Y).




<img width="1107" alt="screen shot 2018-07-21 at 5 12 55 pm" src="https://user-images.githubusercontent.com/3140883/43041031-80711d0c-8d09-11e8-969c-fb25f7a0e4ad.png">

If you run the Flow via the Flow component container, by dragging it into the page in App Builder, you _can_ get the recordId passed in by clicking a checkbox in the configuration panel of the Flow component. But that approach won't help you if you want to launch the Flow from a button. Hence this solution



## Install this Component Into Your Org ##

[Install this Component](https://sites.google.com/view/flowunofficial/flow-local-actions/get-current-recordid).



## How It Works ##

This component reads the URL of the current page and parses the recordId out of it. Obviously, it's only going to work if the URL is a standard Salesforce record page URL.

The recordID can be assigned to a variable and used downstream in the Flow.

## Resources ##

Want to suggest an improvement or report a bug? Do that [here](/issues)

[Learn more about how Flow Components work](/README.md)

Know a little javascript and want to add some improvements? {Pull requests are welcome}(/pulls) If you're thinking of adding much complexity to the user interface, though, you probably should fork the repo, because we want to keep this baseline version easy-to-use.
