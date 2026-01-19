#!/bin/bash

mkdir build-android

buildAndroid() {
    abi=$1
    cmake -S . \
        -B ./build-android/${abi} \
        -DCMAKE_SYSTEM_NAME=Android \
        -DCMAKE_TRY_COMPILE_TARGET_TYPE=STATIC_LIBRARY \
        -DANDROID_PLATFORM=android-21 \
        -DANDROID_ABI=${abi} \
        -DBUILD_TESTING=OFF \
        -DLIBSAMPLERATE_ENABLE_SINC_BEST_CONVERTER=OFF \
        -DLIBSAMPLERATE_ENABLE_SINC_MEDIUM_CONVERTER=OFF \
        -DCMAKE_TOOLCHAIN_FILE=${ANDROID_NDK}/build/cmake/android.toolchain.cmake \
        -DCMAKE_INSTALL_PREFIX=./build-android/install-${abi} \
        -DCMAKE_POLICY_VERSION_MINIMUM=3.5

    cmake --build ./build-android/${abi} --config Release
    mkdir -p ./build-android/install-$abi/android/${abi}/include/samplerate/
    cp -r ./build-android/${abi}/src/libsamplerate.a ./build-android/install-$abi/android/$abi/libsamplerate.a
    cp -r ./include/. ./build-android/install-$abi/android/$abi/include/samplerate/
}

buildAndroid armeabi-v7a
buildAndroid arm64-v8a
buildAndroid x86_64
buildAndroid x86
echo "done. the files are in the build/android folder"
