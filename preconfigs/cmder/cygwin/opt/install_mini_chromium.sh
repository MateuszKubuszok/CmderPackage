#!/bin/sh
cd /opt
MINI_CHROMIUM_DIR=/opt/mini_chromium
if [ ! -d $MINI_CHROMIUM_DIR ]; then
  echo Fetching mini chromium
  git clone https://chromium.googlesource.com/chromium/mini_chromium
  cd $MINI_CHROMIUM_DIR
else
  cd $MINI_CHROMIUM_DIR
  if [ -d "$MINI_CHROMIUM_DIR/out" ]; then
    echo Clean old build
    rm "$MINI_CHROMIUM_DIR/out" -rf
  fi
  echo Updating mini chromium
  git fetch origin
  git reset --hard origin/master
fi

echo Running configuration
export GYP_GENERATORS=ninja
gyp.bat --depth=. mini_chromium.gyp
echo Building
ninja -C out/Release base
ninja -C out/Debug   base
