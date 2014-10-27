@echo off

@CALL %~dp0%..\common_variables.bat
@SET CYGWIN=nodosfilewarning winsymlinks:native
@SET DEPOT_TOOLS_PATH=/opt/depot_tools
@SET PATH=%PATH_EXTENSION%;%DEPOT_TOOLS_PATH%;%PATH%

@chdir %CYGWIN_PATH%\bin

@bash --login -i

