:: Init Script for cmd.exe
:: Sets some nice defaults
:: Created as part of cmder project

@SET CMDER_PATH=%~dp0%..
@SET CYGWIN_PATH=%CMDER_PATH%\cygwin
@SET JAVA_HOME=%CMDER_PATH%\jdk
@SET JAVA_PATH=%CMDER_PATH%\jvm
@SET JDK_PATH=%CMDER_PATH%\jdk
@SET JRE_PATH=%CMDER_PATH%\jre
@SET GRADLE_PATH=%CMDER_PATH%\tools\gradle
@SET DEPOT_TOOLS_PATH=%CYGWIN_PATH%\opt\depot_tools
@SET NODE_PATH=%CMDER_PATH%\node
@SET PYTHON_PATH=%DEPOT_TOOLS_PATH%\python276_bin
@SET PATH=%CYGWIN_PATH%\bin;%CYGWIN_PATH%\usr\sbin;%JAVA_PATH%\bin;%JDK_PATH%\bin;%GRADLE_PATH%\bin;%DEPOT_TOOLS_PATH%;%NODE_PATH%;%PYTHON_PATH%;%PATH%

@SET DEPOT_TOOLS_WIN_TOOLCHAIN=1
@SET DXSDK_DIR=C:\Program Files (x86)\Microsoft DirectX SDK (June 2010)
@SET GYP_DEFINES=windows_sdk_path="C:\Program Files (x86)\Windows Kits\8.1" component=shared_library
@SET GYP_GENERATOR_FLAGS=config=Debug
@SET GYP_GENERATORS=msvs-ninja,ninja
@SET GYP_MSVS_VERSION=2013e
@SET GYP_PARALLEL=12
@SET VS100COMNTOOLS=C:\Program Files (x86)\Microsoft Visual Studio 10.0\Common7\Tools\
@SET VS120COMNTOOLS=C:\Program Files (x86)\Microsoft Visual Studio 12.0\Common7\Tools\
@SET WDK_DIR=C:\WinDDK\7600.16385.1

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
