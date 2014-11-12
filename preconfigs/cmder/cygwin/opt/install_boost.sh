#!/bin/sh
BOOST_VERSION=boost_1_56_0
BOOST_DIR=/opt/$BOOST_VERSION
if [ ! -d $BOOST_DIR ]; then
  BOOST_TMP=/tmp/$BOOST_VERSION.tar.gz
  if [ ! -f $BOOST_TMP ]; then
    wget http://skylink.dl.sourceforge.net/project/boost/boost/1.56.0/$BOOST_VERSION.tar.gz -O $BOOST_TMP
  fi
  cd /opt
  echo Extracting
  tar -xzvf $BOOST_TMP
fi
cd $BOOST_DIR
echo Bootstraping
./bootstrap.sh
echo Installing
./b2 install --prefix=/ architecture=x86 address-model=64
