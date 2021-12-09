# FFmpeg iOS build script

See the following repository for Swift package, .xcframeworks and more:

https://github.com/kewlbear/FFmpeg-iOS

[![Build Status](https://travis-ci.org/kewlbear/FFmpeg-iOS-build-script.svg?branch=master)](https://travis-ci.org/kewlbear/FFmpeg-iOS-build-script)

This is a shell script to build FFmpeg libraries for iOS and tvOS apps.

Tested with:

* FFmpeg 4.3.1
* Xcode 12.2

## Requirements

* https://github.com/libav/gas-preprocessor
* yasm 1.2.0

## Usage

Use build-ffmpeg-tvos.sh for tvOS.

* To build everything:

        ./build-ffmpeg.sh

* To build arm64 libraries:

        ./build-ffmpeg.sh arm64

* To build fat libraries for armv7 and x86_64 (64-bit simulator):

        ./build-ffmpeg.sh armv7 x86_64

* To build fat libraries from separately built thin libraries:

        ./build-ffmpeg.sh lipo

## Download

You can download a binary for FFmpeg 4.3.1 release at https://downloads.sourceforge.net/project/ffmpeg-ios/ffmpeg-ios-master.tar.bz2

## External libraries

You should link your app with

* libz.dylib
* libbz2.dylib
* libiconv.dylib

如果没有添加gas-preprocessor.pl, 或则gas-preprocessor.pl的版本不对的话,编译过程中会提示,如下错误:
GNU assembler not found, install/update gas-preprocessor

这是可以已打build-ffmpeg.sh文件gas-preprocessor.pl链接地址, 下载最新版本,或者复制其中内容,添加到本地路径/usr/local/bin即可

* libz.dylib
