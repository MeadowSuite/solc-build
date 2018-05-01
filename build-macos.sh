#!/bin/bash

cd solidity

sed -i -e 's/DCMAKE_POSITION_INDEPENDENT_CODE=${BUILD_SHARED_LIBS}/DCMAKE_POSITION_INDEPENDENT_CODE=ON/g' cmake/jsoncpp.cmake

sed -i -e 's/libsolc libsolc.cpp/libsolc SHARED libsolc.cpp/g' libsolc/CMakeLists.txt

rm -rf build
mkdir build
cd build

cmake .. \
    -DTESTS=Off \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
    -DBoost_USE_STATIC_LIBS=Off

make libsolc -j4
