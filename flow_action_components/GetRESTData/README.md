# SFDX  App

This Local Action sample makes a simple GET call to an endpoint.

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

## Description of Files and Directories
force-app/main :
* getRESTData component
* CSP definition :
We are making a request to an external (non-Salesforce) server so we needed to add the server as a CSP Trusted Site. See [Create CSP Trusted Sites to Access Third-Party APIs](https://developer.salesforce.com/docs/atlas.en-us.lightning.meta/lightning/csp_trusted_sites.htm)
* sample flow

force-app/test :
* test spec file (getRESTDataTests.resource) and aura test app
