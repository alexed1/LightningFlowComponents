@echo off
if "%1" neq "" goto skipprompt
set /p version="Set Version Number: "
goto exit
:skipprompt
set version=%1
:exit
packaging\ShowVersion
@echo on