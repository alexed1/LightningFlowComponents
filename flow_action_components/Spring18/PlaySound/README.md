# SFDX  App

## Dev, Build and Test
1. Create scratch org:
```
sfdx force:org:create -f config/project-scratch-def.json -a PlaySoundOrgScratch
```
2. Push the source to org:
```
sfdx force:source:push -u PlaySoundOrgScratch
```
## Help
- PlaySound can play audio for both in screen and in Local Action
- If you pass an url to source, you need to add source's url to Setup > CSP Trusted Sites
- You can also upload the source as a static resources
