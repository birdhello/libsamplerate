#!/bin/bash

mkdir build-android

buildAndroid() {
    abi=$1
    cmake -S . \
        -B ./build-android \
        -DCMAKE_SYSTEM_NAME=Android \
        -DCMAKE_TRY_COMPILE_TARGET_TYPE=STATIC_LIBRARY \
        -DANDROID_PLATFORM=android-19 \
        -DANDROID_ABI=${abi} \
        -DBUILD_PROGRAMS=OFF \
        -DBUILD_EXAMPLES=OFF \
        -DBUILD_TESTING=OFF \
        -DCMAKE_TOOLCHAIN_FILE=${ANDROID_NDK}/build/cmake/android.toolchain.cmake \
        -DCMAKE_INSTALL_PREFIX=./build-android/install-$abi

    cmake --build ./build-android --config Release
    mkdir -p ./build-android/install-$abi/lib/
    cp -r ./build-android/src/libsamplerate.a ./build-android/install-$abi/lib/libsamplerate.a
}

buildAndroid armeabi-v7a
buildAndroid arm64-v8a
echo "done. the files are in the build/android folder"
