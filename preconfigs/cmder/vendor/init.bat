:: Init Script for cmd.exe
:: Sets some nice defaults
:: Created as part of cmder project

@CALL %~dp0%..\common_variables.bat

:: Change the prompt style
:: Mmm tasty lamb
@prompt $E[1;32;40m$P$S{git}$S$_$E[1;30;40m{lamb}$S$E[0m

:: Pick right version of clink
@if "%PROCESSOR_ARCHITECTURE%"=="x86" (
    set architecture=86
) else (
    set architecture=64
)

:: Run clink
@"%CMDER_ROOT%\vendor\clink\clink_x%architecture%.exe" inject --quiet --profile "%CMDER_ROOT%\config"

:: Prepare for msysgit

:: I do not even know, copypasted from their .bat
@set PLINK_PROTOCOL=ssh
@if not defined TERM set TERM=cygwin

:: Enhance Path
@set git_install_root=%CMDER_ROOT%\vendor\msysgit
@set PATH=%PATH%;%CMDER_ROOT%\bin;%git_install_root%\bin;%git_install_root%\mingw\bin;%git_install_root%\cmd;%git_install_root%\share\vim\vim73;

:: Add aliases
@doskey /macrofile="%CMDER_ROOT%\config\aliases"
@alias clang++=clang

:: Set home path
@set HOME=%USERPROFILE%

@if defined CMDER_START cd /d "%CMDER_START%"
