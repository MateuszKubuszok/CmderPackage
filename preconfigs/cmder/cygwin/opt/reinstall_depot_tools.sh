#!/bin/sh
cd /opt/depot_tools/
git clean -fdx
./update_depot_tools.bat 2> /dev/null
./python276_bin/python $(cygpath --windows /opt/depot_tools/win_toolchain/toolchain2013.py) --express
