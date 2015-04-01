@echo off

@SET CMDER_PATH=%~dp0%
@SET CLOJURE_JAR_PATH=%CMDER_PATH%\clojure\clojure-1.6.0.jar
@SET CYGWIN=nodosfilewarning winsymlinks:native
@SET CYGWIN_PATH=%CMDER_PATH%cygwin
@SET JAVA_HOME=%CMDER_PATH%jdk
@SET JAVA_PATH=%CMDER_PATH%jvm
@SET JDK_PATH=%CMDER_PATH%jdk
@SET JRE_PATH=%CMDER_PATH%jre
@SET GYP_PATH=%CMDER_PATH%cygwin\opt\gyp
@SET GRADLE_HOME=%CMDER_PATH%tools\gradle
@SET SBT_HOME=%CMDER_PATH%tools\sbt
@SET NODE_PATH=%CMDER_PATH%node

REM Visual Studio 2013 Express toolchain
goto VS2013EXPRESS_END
@SET DEPOT_TOOLS_WIN_TOOLCHAIN=1
@SET DXSDK_DIR=%ProgramFiles(x86)%\Microsoft DirectX SDK (June 2010)
@SET GYP_DEFINES=windows_sdk_path="%ProgramFiles(x86)%\Windows Kits\8.0" component=shared_library
@SET GYP_GENERATOR_FLAGS=config=Debug
@SET GYP_GENERATORS=msvs-ninja,ninja
@SET GYP_MSVS_VERSION=2013e
@SET GYP_PARALLEL=12
@SET VS100COMNTOOLS=%ProgramFiles(x86)%\Microsoft Visual Studio 10.0\Common7\Tools\
@SET VS120COMNTOOLS=%ProgramFiles(x86)%\Microsoft Visual Studio 12.0\Common7\Tools\
@SET WDK_DIR=C:\WinDDK\7600.16385.1
:VS2013EXPRESS_END

REM Visual Studio 2013 Professional toolchain
goto VS2013PROFESSIONAL_END
@SET DEPOT_TOOLS_WIN_TOOLCHAIN=0
@SET GYP_DEFINES=component=shared_library
:VS2013PROFESSIONAL_END

REM Disabled by default as apparently this creates VS build error C1902
REM @SET PATH=%PATH%;%CYGWIN_PATH%\bin;%CYGWIN_PATH%\usr\sbin
@SET PATH=%PATH%;%JAVA_PATH%\bin;%JDK_PATH%\bin;%GYP_PATH%;%GRADLE_HOME%\bin;%SBT_HOME%\bin;%NODE_PATH%
