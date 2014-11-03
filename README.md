# FFmpeg iOS build script

[![Build Status](https://travis-ci.org/kewlbear/FFmpeg-iOS-build-script.svg?branch=master)](https://travis-ci.org/kewlbear/FFmpeg-iOS-build-script)

This is a shell script to build FFmpeg libraries for iOS apps.

Tested with:

* FFmpeg 2.4.3
* Xcode 6

## Requirements

* https://github.com/libav/gas-preprocessor
* yasm 1.2.0

## Usage

* To build everything:

        ./build-ffmpeg.sh

* To build arm64 libraries:

        ./build-ffmpeg.sh arm64

* To build fat libraries for armv7 and x86_64 (64-bit simulator):

        ./build-ffmpeg.sh armv7 x86_64

* To build fat libraries from separately built thin libraries:

        ./build-ffmpeg.sh lipo

## Download

You can download a binary for FFmpeg 2.4.3 release at https://downloads.sourceforge.net/project/ffmpeg-ios/ffmpeg-ios-master.tar.bz2

## External libraries

You should link your app with

* libz.dylib
* libbz2.dylib
* libiconv.dylib

## Influences

* https://github.com/bbcallen/ijkplayer/blob/fc70895c64cbbd20f32f1d81d2d48609ed13f597/ios/tools/do-compile-ffmpeg.sh#L7

<a href="http://area51.stackexchange.com/proposals/68765/stack-overflow-in-korean?referrer=TlX13ZoocJzZSF-vpU0x_w2"><img src="https://area51.stackexchange.com/ads/proposal/68765.png" width="220" height="250" alt="Stack Exchange Q&A site proposal: Stack Overflow (in Korean)" /></a>
