@echo off
if "%1" neq "" goto skipprompt
set /p version="Set Version Number: "
goto exit
:skipprompt
set version=%1
:exit
echo Version: %version%
@echo on