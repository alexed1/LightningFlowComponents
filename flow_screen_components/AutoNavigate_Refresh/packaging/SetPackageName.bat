@echo off
if "%1" neq "" goto skipprompt
set /p packageName="Set Package Name: "
goto exit
:skipprompt
set packageName=%1
:exit
echo Package Name: %packageName%
@echo on