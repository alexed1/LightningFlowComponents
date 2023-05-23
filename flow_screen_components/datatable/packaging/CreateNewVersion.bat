@echo off
if "%1" neq "" set version=%1
@echo on
REM sfdx force:package:beta:version:create -v lexhost -w 40 -x -c -n %version%.0 -d force-app\
sfdx package:version:create -v lexhost -w 40 -x -c -n %version%.0 -d force-app\