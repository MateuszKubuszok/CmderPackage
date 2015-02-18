#!/bin/sh
BoostVersion=boost_1_56_0
BoostDir=/opt/$BoostVersion
if [ ! -d $BoostDir ]; then
  BoostTmp=/tmp/$BoostVersion.tar.gz
  if [ ! -f $BoostTmp ]; then
    wget http://skylink.dl.sourceforge.net/project/boost/boost/1.56.0/$BoostVersion.tar.gz \
      -O $BoostTmp
  fi
  cd /opt
  echo Extracting
  tar -xzvf $BoostTmp
fi
cd $BoostDir
echo Bootstraping
./bootstrap.sh
echo Installing
./b2 install --prefix=/ architecture=x86 address-model=64
