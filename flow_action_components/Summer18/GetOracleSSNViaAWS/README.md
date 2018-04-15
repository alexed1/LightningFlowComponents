# SFDX  App

This Local Action makes a GET call to an endpoint exposing an Oracle Database hosted on Amazon RDS.

## Dev, Build

```
sfdx force:org:create -s -f config/project-scratch-def.json -a getOracleViaAWS-org
```

```
sfdx force:source:push -u getOracleViaAWS-org
```

## Description of Files and Directories

force-app/main :
* oracle sample component
* CSP definition :
We are making a request to an external (non-Salesforce) server so we needed to add the server as a CSP Trusted Site. See [Create CSP Trusted Sites to Access Third-Party APIs](https://developer.salesforce.com/docs/atlas.en-us.lightning.meta/lightning/csp_trusted_sites.htm)
