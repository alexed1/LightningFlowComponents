@echo off
if "%1" neq "" set version=%1
@echo on
sfdx force:package:version:report -v lexhost --package "quickLookup@%version%-0"