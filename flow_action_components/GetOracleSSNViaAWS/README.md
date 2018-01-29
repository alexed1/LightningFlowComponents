# GetOracleSSNViaAWS #

### A Flow Component solution  ###

This Local Action makes a  GET call to an endpoint exposing an Oracle Database hosted on Amazon RDS. It demonstrates the use of REST to connect to an endpoint on AWS, and shows how data from a SQL query can be integrated into a flow. The connection to the database is direct and does not go through Salesforce cloud or require any firewall manipulation.

<img width="736" alt="screen shot 2018-01-28 at 3 03 26 pm" src="https://user-images.githubusercontent.com/3140883/35488368-7312c062-043c-11e8-97ee-c807542155f3.png">


## Description of Files and Directories

* GetOracleSSNViaAWS Flow Action
* CSP definition :
We are making a request to an external (non-Salesforce) server so we needed to add the server as a CSP Trusted Site. See [Create CSP Trusted Sites to Access Third-Party APIs](https://developer.salesforce.com/docs/atlas.en-us.lightning.meta/lightning/csp_trusted_sites.htm)


## Install this Component Into Your Org ##
To use this, you must be a participant in the local Flow Actions pilot, aka the "Local Actions" pilot. Request access from customer support. 

See the full set of installation options [here](/install.md).

## How It Works ##

This component exposes a single attribute called "value". It can be used both as an input parameter to set the starting values and as an output parameter to pass out the selected time. 


## Resources ##

Want to suggest an improvement or report a bug? Do that [here](/issues)

[Learn more about how Flow Components work](/README.md)

Know a little javascript and want to add some improvements? {Pull requests are welcome}(/pulls) If you're thinking of adding much complexity to the user interface, though, you probably should fork the repo, because we want to keep this baseline version easy-to-use.

