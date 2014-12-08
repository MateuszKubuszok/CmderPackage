#!/bin/sh
cd /opt/depot_tools/
echo "Clean old installation:"
git clean -fdx
echo "Update and install dependencies (it will say it failed for some reason):"
git pull
./bootstrap/win/win_tools.bat
