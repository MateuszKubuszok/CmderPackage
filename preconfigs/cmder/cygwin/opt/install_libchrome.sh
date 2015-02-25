#!/bin/sh
Python=/opt/depot_tools/python276_bin/python

Target=/opt/libchrome

ChromiumSVNURL=http://src.chromium.org/chrome/trunk/src/
BuildToolsGitURL=https://chromium.googlesource.com/chromium/buildtools
GYPGitURL=https://chromium.googlesource.com/external/gyp
ICUGitURL=https://chromium.googlesource.com/chromium/deps/icu52.git
PsychoGitURL=https://chromium.googlesource.com/chromium/deps/psyco_win32
TestingGitURL=https://chromium.googlesource.com/chromium/testing/gtest

if [ ! -d "$Target/.svn" ]; then
  echo Settings up repository:
  svn checkout --depth empty $ChromiumSVNURL $Target
  cd $Target
  svn update --set-depth empty chrome/
  svn update --set-depth empty third_party/
else
  echo Opening repository
  cd $Target
fi

echo 'Fetching newest Chromium (necessary part):'
svn update --set-depth infinity base/
svn update --set-depth infinity build/
svn update --set-depth empty    chrome/VERSION
svn update --set-depth infinity testing/
svn update --set-depth infinity third_party/android_crazy_linker/
svn update --set-depth infinity third_party/ashmem/
svn update --set-depth infinity third_party/libevent/
svn update --set-depth infinity third_party/libxml/
svn update --set-depth infinity third_party/modp_b64/
svn update --set-depth infinity third_party/zlib/

if [ ! -d buildtools ]; then
  echo 'Fetching buildtools:'
  git clone $BuildToolsGitURL buildtools
fi

if [ ! -d testing/gtest ]; then
  echo 'Fetching GTest:'
  git clone $TestingGitURL testing/gtest
fi

if [ ! -d third_party/icu ]; then
  echo 'Fetching ICU:'
  git clone $ICUGitURL third_party/icu
fi

if [ ! -d third_party/psycho ]; then
  echo 'Fetching Psycho:'
  git clone $PsychoGitURL third_party/psycho
fi

if [ ! -f tools/gyp/gyp ]; then
  echo 'Fetching GYP:'
  git clone $GYPGitURL tools/gyp
fi

echo Building VS solution:
cp ../utils/{all.gyp,gyp_chromium} build/
$Python build/gyp_chromium --depth=. --root-target=base
ninja -C out/Release base
ninja -C out/Debug base
