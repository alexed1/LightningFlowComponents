@echo off
if "%1" neq "" set packageName=%1
if "%2" neq "" set version=%2
@echo on
sfdx force:package:version:report -v lexhost --package "%packageName%@%version%-0"