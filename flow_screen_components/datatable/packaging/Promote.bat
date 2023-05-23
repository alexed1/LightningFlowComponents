@echo off
if "%1" neq "" set version=%1
@echo on
REM sfdx force:package:version:promote -v lexhost --package "datatable@%version%-0"
sfdx force:package:version:promote -v lexhost --package "datatable@%version%"