@echo off

@CALL %~dp0%..\common_variables.bat

@chdir %CYGWIN_PATH%\bin

@bash --login -i

