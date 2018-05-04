
# GetRESTData - Makes a simple GET call to an endpoint #

### A Lightning Flow Extension  ###

Make a simple GET call to an endpoint.

## Install this Component Into Your Org ##

[Install this Component](https://sites.google.com/view/flowunofficial/flow-action-components/get-rest-data).

See the full set of installation options [here](/install.md).

## How It Works ##

force-app/main :
* getRESTData component
* CSP definition :
This makes a request to an external (non-Salesforce) server so you need to add the server as a CSP Trusted Site. See [Create CSP Trusted Sites to Access Third-Party APIs](https://developer.salesforce.com/docs/atlas.en-us.lightning.meta/lightning/csp_trusted_sites.htm)
* sample flow

force-app/test :
* test spec file (getRESTDataTests.resource) and aura test app


## Resources ##

Want to suggest an improvement or report a bug? Do that [here](/issues)

[Learn more about how Flow Components work](/README.md)

Know a little javascript and want to add some improvements? {Pull requests are welcome}(/pulls) If you're thinking of adding much complexity to the user interface, though, you probably should fork the repo, because we want to keep this baseline version easy-to-use.

## Dev, Build and Test

```
sfdx force:org:create -s -f config/project-scratch-def.json -a GetRESTDataLocalActionOrg
sfdx force:source:push -u GetRESTDataLocalActionOrg
```

To run the tests using the [Lightning Testing Service](https://github.com/forcedotcom/LightningTestingService) :
```
sfdx force:lightning:test:install
sfdx force:lightning:test:run -a jasmineTests.app
```

