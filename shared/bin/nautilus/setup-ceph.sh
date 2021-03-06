#!/bin/bash

set -e

WITH_PYTHON="${WITH_PYTHON:-3}"

cd /ceph
find . -name \*.pyc -delete
./install-deps.sh

ARGS="-DENABLE_GIT_VERSION=OFF -DWITH_TESTS=ON -DWITH_CCACHE=ON $ARGS"
if [ "$WITH_PYTHON" == 3 ]; then
    ARGS="-DWITH_PYTHON3=ON -DWITH_PYTHON2=OFF -DMGR_PYTHON_VERSION=3 -DWITH_RADOSGW_AMQP_ENDPOINT=OFF $ARGS"
    echo "WITH_PYTHON 3"
else
    ARGS="-DWITH_PYTHON3=OFF -DWITH_PYTHON2=ON -DMGR_PYTHON_VERSION=2 -DWITH_RADOSGW_AMQP_ENDPOINT=OFF $ARGS"
    echo "WITH_PYTHON 2"
fi

NPROC=${NPROC:-$(nproc --ignore=2)}

# SSO dependencies
zypper -n install libxmlsec1-1 libxmlsec1-nss1 libxmlsec1-openssl1 xmlsec1-devel xmlsec1-openssl-devel
pip install python3-saml
pip2 install python-saml

if [ "$CLEAN" == "true" ]; then
    echo "CLEAN INSTALL"
    rm -rf /ceph/build/
    rm -rf /ceph/src/pybind/mgr/dashboard/frontend/node_modules/
    rm -rf /ceph/src/pybind/mgr/dashboard/frontend/dist/
fi

if [ -d "build" ]; then
    git submodule update --init --recursive
    cd build
    cmake -DBOOST_J=$NPROC $ARGS ..
else
    ./do_cmake.sh $ARGS
    cd build
fi

ccache make -j$NPROC

