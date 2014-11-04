#!/bin/sh

apt-cyg install curl git make automake \
                libreadline7 libreadline7-devel \
                zlib-devel

\curl -sSL https://get.rvm.io | bash -s stable
