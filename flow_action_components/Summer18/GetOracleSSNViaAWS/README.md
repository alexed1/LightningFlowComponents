# GetOracleSSNViaAWS - See how to do a Direct Data Query #

### A Lightning Flow Extension  ###

This local action makes a REST call to an endpoint running on AWS. The endpoint is connected to a python script that queries a SQL Server. The purpose of this is to demonstrate a use case where a non-Salesforce system is accessed via a direct javascript query instead of through traditional Salesforce mechanisms involving corporate firewalls.

## Install this Component Into Your Org ##

[Install this Component](https://sites.google.com/view/flowunofficial/flow-local-actions/getoraclessnviaaws).



## How It Works ##

This package includes a CSP Trusted Site record that instructs Salesforce  to allow your org to connect to a specific public AWS endpoint.

See [Create CSP Trusted Sites to Access Third-Party APIs](https://developer.salesforce.com/docs/atlas.en-us.lightning.meta/lightning/csp_trusted_sites.htm)

## Resources ##

Want to suggest an improvement or report a bug? Do that [here](/issues)

[Learn more about how Flow Components work](/README.md)

Know a little javascript and want to add some improvements? {Pull requests are welcome}(/pulls) If you're thinking of adding much complexity to the user interface, though, you probably should fork the repo, because we want to keep this baseline version easy-to-use.
