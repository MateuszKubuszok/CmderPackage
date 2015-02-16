#!/bin/sh

MINI_CHROMMIUM_DIR=/opt/mini_chromium
if [ ! -d $MINI_CHROMMIUM_DIR ]; then
  echo Fetching mini chromium
  cd /opt
  git clone https://chromium.googlesource.com/chromium/mini_chromium
fi
cd $MINI_CHROMMIUM_DIR

if [ -d "$MINI_CHROMMIUM_DIR/out" ]; then
  echo Clean old build
  rm "$MINI_CHROMMIUM_DIR/out" -rf
fi

echo Running configuration
export GYP_GENERATORS=ninja
gyp.bat --depth=. mini_chromium.gyp
echo Building
ninja -C out/Release base
ninja -C out/Debug   base
