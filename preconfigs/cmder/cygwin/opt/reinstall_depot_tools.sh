#!/bin/sh
cd /opt/depot_tools/
git clean -f -d -x
./update_depot_tools.bat
gyp_python $(cygpath --windows /opt/depot_tools/win_toolchain/toolchain2013.py) --express --local=$(cygdrive --windows /tmp)
