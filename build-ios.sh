#!/bin/bash

mkdir build-ios

buildiOS() {
    sdk=$1
    arch=$2
    cmake -S . \
        -B ./build-ios \
        -DCMAKE_SYSTEM_NAME=iOS \
        -DCMAKE_TRY_COMPILE_TARGET_TYPE=STATIC_LIBRARY \
        -DCMAKE_OSX_ARCHITECTURES=$arch \
        -DCMAKE_OSX_SYSROOT="$(xcodebuild -version -sdk $sdk Path)" \
        -DCMAKE_OSX_DEPLOYMENT_TARGET=9.0 \
        -DCMAKE_CXX_COMPILER_WORKS=YES \
        -DCMAKE_IOS_INSTALL_COMBINED=YES \
        -DCMAKE_C_COMPILER_WORKS=YES \
        -DCMAKE_XCODE_ATTRIBUTE_GCC_GENERATE_DEBUGGING_SYMBOLS=YES \
        -DCMAKE_INSTALL_PREFIX=./build-ios/install-$sdk

    cmake --build ./build-ios --config Release
    mkdir -p ./build-ios/install-$sdk/lib/
    cp -r ./build-ios/src/libsamplerate.a ./build-ios/install-$sdk/lib/libsamplerate.a
}

buildiOS iphonesimulator x86_64
buildiOS iphoneos armv7\;arm64
mkdir ./build-ios/install
libtool -static -o ./build-ios/install/libsamplerate.a ./build-ios/install-iphoneos/lib/libsamplerate.a ./build-ios/install-iphonesimulator/lib/libsamplerate.a
echo "done. the files are in the build/ios folder"
