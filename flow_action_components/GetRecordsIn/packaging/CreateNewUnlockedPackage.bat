@echo off
if "%1" neq "" set packageName=%1
@echo on
sfdx force:package:create -v lexhost --name "%packageName%" --path force-app --packagetype Unlocked