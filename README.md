# FFmpeg iOS build script

[![Build Status](https://travis-ci.org/kewlbear/FFmpeg-iOS-build-script.svg?branch=master)](https://travis-ci.org/kewlbear/FFmpeg-iOS-build-script)

This is a shell script to build FFmpeg as XCFramework

Tested with:

* FFmpeg 4.2
* Xcode 11

## Requirements

* https://github.com/libav/gas-preprocessor
* yasm 1.2.0

## Supported platforms

* iOS: arm64 for device and X86_64 for simulator
* tvOS: arm64 for device and X86_64 for simulator
* macOS: X86_64
* macOS-catalyst: X86_64

## Usage

* To build XCFramework with all platforms included, run

        ./build.sh

## Issues

* x86_64 binaries are built without ASM support, since ASM for x86_64 is actually x86 and that confuses `xcodebuild -create-xcframework`

## Download

You can download a binary for FFmpeg 4.2 release at https://downloads.sourceforge.net/project/ffmpeg-ios/ffmpeg-ios-master.tar.bz2

## External libraries

You should link your app with

* libz.dylib
* libbz2.dylib
* libiconv.dylib
