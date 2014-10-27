@echo off
@CALL %~dp0%..\common_variables.bat
%JAVA_PATH%\bin\java.exe -jar %CLOJURE_JAR_PATH%
