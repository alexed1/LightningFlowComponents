@echo off
if "%1" neq "" set version=%1
@echo on
sfdx force:package:version:create -v lexhost -w 20 -x -c -n %version%.0 -d force-app\