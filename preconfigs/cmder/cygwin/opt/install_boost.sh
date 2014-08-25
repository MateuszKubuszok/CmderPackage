wget http://downloads.sourceforge.net/project/boost/boost/1.54.0/boost_1_54_0.tar.gz -O /tmp/boost_1_54_0.tar.gz
tar -xf -O /opt/boost
./bootstrap.sh
./b2 install --prefix=/ architecture=x86 address-model=64
