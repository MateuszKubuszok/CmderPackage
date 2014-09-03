@echo off

@SET CYGWIN=nodosfilewarning winsymlinks:native
@SET CYGWIN_PATH=%~dp0%
@SET CMDER_PATH=%CYGWIN_PATH%..
@SET JAVA_HOME=%CMDER_PATH%\jdk
@SET JAVA_PATH=%CMDER_PATH%\jvm
@SET JDK_PATH=%CMDER_PATH%\jdk
@SET JRE_PATH=%CMDER_PATH%\jre
@SET GRADLE_PATH=%CMDER_PATH%\tools\gradle
@SET DEPOT_TOOLS_PATH=/opt/depot_tools
@SET NODE_PATH=%CMDER_PATH%\node

@SET PATH=%CYGWIN_PATH%bin;%CYGWIN_PATH%usr\sbin;%JAVA_PATH%\bin;%JDK_PATH%\bin;%GRADLE_PATH%\bin;%DEPOT_TOOLS_PATH%;%NODE_PATH%;%PATH%

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

@chdir %CYGWIN_PATH%\bin

@bash --login -i

