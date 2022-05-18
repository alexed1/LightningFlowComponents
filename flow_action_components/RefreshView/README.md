# Refresh View

## Use Case

When a flow makes changes to record fields, you want your users to see those changes without them having to reload the browser page manually.

## How to install

Deploy to an org using:

```
sfdx force:source:deploy -p flow_action_components/RefreshView/force-app/main/default/aura/refreshView
```

## How to use

Simply add this invocable action at the end of your flow to refresh the view. This is especially useful in screen flows after your last screen.

## How it works

This invocable action uses the `force:refreshView` event to reload the current view automatically. Refer to the [Salesforce Developer Documentation](https://developer.salesforce.com/docs/component-library/bundle/force:refreshView/documentation) for the techincal details
