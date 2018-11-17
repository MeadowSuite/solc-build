#!/bin/bash

if [ ! "$(ls -A boost_1_67_0)" ]
then
    wget https://downloads.sourceforge.net/project/boost/boost/1.67.0/boost_1_67_0.tar.bz2 -O boost_1_67_0.tar.bz2
    tar --bzip2 -xf boost_1_67_0.tar.bz2
    cd boost_1_67_0
    ./bootstrap.sh --with-libraries=regex,filesystem,program_options,system,test
    ./b2 -j4 link=static cxxflags=-fPIC cflags=-fPIC
    cd ..
fi

if [ -z "$1" ]
then
    cd solidity
else
    cd "solidity-$1"
fi

touch prerelease.txt

sed -i -e 's/DCMAKE_POSITION_INDEPENDENT_CODE=${BUILD_SHARED_LIBS}/DCMAKE_POSITION_INDEPENDENT_CODE=ON/g' cmake/jsoncpp.cmake

sed -i -e 's/libsolc libsolc.cpp/libsolc SHARED libsolc.cpp/g' libsolc/CMakeLists.txt

rm -rf build
mkdir build
cd build

cmake .. \
    -DTESTS=Off \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
    -DBoost_USE_STATIC_LIBS=On \
    -DBoost_NO_SYSTEM_PATHS=TRUE \
    -DBOOST_ROOT=../boost_1_67_0

make libsolc -j4
