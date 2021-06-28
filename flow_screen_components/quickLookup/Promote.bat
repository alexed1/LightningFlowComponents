@echo off
if "%1" neq "" set version=%1
@echo on
sfdx force:package:version:promote -v lexhost --package "quickLookup@%version%-0"