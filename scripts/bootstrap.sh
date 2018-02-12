#!/bin/bash -x
echo "Starting Dev Environment"

if [[ $# -eq 0 ]] ; then
    echo 'you need to pass in a string name for your scratch org'
    exit 1
fi

echo "authenticating to devhubtrial2"
sfdx force:auth:jwt:grant -i 3MVG9mclR62wycM2eQwLGugMMMWe5zQvP33hzD_0yCIWytEEI73gZsu8wtNti51PfxuTT_p0F6BrRyAeCVQjN -u alexdevhubtrial2@edelstein.org -f ~/dev/certificates/server.key --setdefaultdevhubusername
echo "creating a new scratch org"
sfdx force:org:create -a $1 -s -f config/project-scratch-def.json -d 1
echo "install testing environment"
sfdx force:lightning:test:install -u $1
echo "pushing project to scratch org"
sfdx force:source:push -u $1
echo "get web url for manual open"
sfdx force:org:open -r -u $1