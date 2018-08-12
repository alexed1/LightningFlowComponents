#!/bin/bash -x
echo "Running deploy...."
rm -r mdapi
sfdx force:source:convert -d mdapi
sfdx force:mdapi:deploy -d mdapi -w 10 -u $1
