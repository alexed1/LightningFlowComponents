# SFDX  App

## Dev, Build and Test
- Create scratch org: sfdx force:org:create -f config/project-scratch-def.json -a PlaySoundOrgScratch
- Push the source to org: sfdx force:source:push -u PlaySoundOrgScratch

## Help
- PlaySound can play audio for both in screen and in Local Action
- If you pass an url to source, you need to add source's url to Setup > CSP Trusted Sites
- You can also to upload the source as a statis resources
