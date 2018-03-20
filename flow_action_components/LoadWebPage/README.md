# SFDX  App

This Local Action open a new browser window with an url given as parameter.

## Dev, Build

```
sfdx force:org:create -s -f config/project-scratch-def.json -a loadWebPage-org
```

```
sfdx force:source:push -u loadWebPage-org
```

## Description of Files and Directories

force-app/main :
* load web page component
