#!/bin/sh
Python=/opt/depot_tools/python276_bin/python

Target=/opt/libchrome
GitDir='.git'
SparseFile="$GitDir/info/sparse-checkout"

ChromiumGitURL=https://chromium.googlesource.com/chromium/src
BuildToolsGitURL=https://chromium.googlesource.com/chromium/buildtools
GYPGitURL=https://chromium.googlesource.com/external/gyp
ICUGitURL=https://chromium.googlesource.com/chromium/deps/icu52.git
PsychoGitURL=https://chromium.googlesource.com/chromium/deps/psyco_win32
TestingGitURL=https://chromium.googlesource.com/chromium/testing/gtest

if [ ! -d "$Target/$GitDir" ]; then
  echo Settings up repository:
  git init $Target
  cd $Target
  git remote add -f origin $ChromiumGitURL
  git config core.sparsecheckout true
else
  echo Opening repository
  cd $Target
fi

echo 'Fetching newest Chromium (sadly whole...):'
rm -f $SparseFile
echo '/base/*' >> $SparseFile
echo '/build/*' >> $SparseFile
echo '/buildtools/*' >> $SparseFile
echo '/chrome/VERSION' >> $SparseFile
echo '/testing/*' >> $SparseFile
echo '/third_party/android_crazy_linker/*' >> $SparseFile
echo '/third_party/ashmem/*' >> $SparseFile
echo '/third_party/icu/*' >> $SparseFile
echo '/third_party/libevent/*' >> $SparseFile
echo '/third_party/libxml/*' >> $SparseFile
echo '/third_party/modp_b64/*' >> $SparseFile
echo '/third_party/zlib/*' >> $SparseFile
echo '/tools/gyp/*' >> $SparseFile
git fetch
git reset --hard origin/master

if [ ! -d buildtools ]; then
  echo 'Fetching buildtools:'
  git clone $BuildToolsGitURL buildtools
fi

if [ ! -d testing/gtest ]; then
  echo 'Fetching GTest:'
  git clone $TestingGitURL testing/gtest
fi

if [ ! -f third_party/icu/icu.gyp ]; then
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
