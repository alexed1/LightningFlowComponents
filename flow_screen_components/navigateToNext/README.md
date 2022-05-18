# Navigate to Next

## Use Case

When users finish running a screen flow, you want to automatically close the modal without your users having to click the `Next` button.

## How to install

Deploy to an org using:

```
sfdx force:source:deploy -p flow_screen_components/navigateToNext/force-app/main/default/aura/navigateToNext
```

## How to use

Simply add this component in a blank screen at the end of your flow.

## How it works

This component uses the `component.get("v.navigateFlow")` to get the navigation controller, and sets it to `navigate("NEXT")` to advance to the next screen. Refer to the [Salesforce Developer Documentation](https://developer.salesforce.com/docs/atlas.en-us.lightning.meta/lightning/components_config_for_flow_screens_navigate_custom.htm) for the techincal details
