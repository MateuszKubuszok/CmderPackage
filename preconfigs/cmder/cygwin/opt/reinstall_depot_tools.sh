cd /opt/depot_tools
git clean -f -d -x
python update_depot_tools.py
python win_toolchain/toolchain2013.py --express
