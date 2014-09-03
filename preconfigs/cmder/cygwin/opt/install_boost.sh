#!/bin/sh
export boost_dir=/opt/boost_1_54_0
if [ ! -d $boost_dir ]; then
  wget http://downloads.sourceforge.net/project/boost/boost/1.54.0/boost_1_54_0.tar.gz -O /tmp/boost_1_54_0.tar.gz
  mkdir $boost_dir
  tar -xf /tmp/boost_1_54_0.tar.gz --directory=/opt
fi
cd $boost_dir
./bootstrap.sh
./b2 install --prefix=/ architecture=x86 address-model=64
