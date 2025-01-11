@echo off
if "%1" neq "" set packageName=%1
@echo on
sfdx package:create -v lexhost --name "%packageName%" --path force-app --package-type Unlocked