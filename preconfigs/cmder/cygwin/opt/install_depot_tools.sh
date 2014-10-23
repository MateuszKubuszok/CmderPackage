#!/bin/sh
cd /opt/depot_tools/
echo "Clean old installation:"
git clean -fdx
echo "Update and install dependencies (it will say it failed for some reason):"
./update_depot_tools.bat 2> /dev/null
