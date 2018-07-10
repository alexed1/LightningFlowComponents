#!/bin/bash -x
echo "Starting Makezip"
cd $1
rm -r mdapioutput
sfdx force:source:convert -d mdapioutput
cd mdapioutput
zip -r $1.zip .
cd ..
cd ..
git st
git add $1
git commit -m 'fix for $1'
git push
