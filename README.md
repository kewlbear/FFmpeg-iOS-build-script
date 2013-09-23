FFmpeg iOS build script
=======================

This is a shell script to build FFmpeg libraries for iOS apps.

Tested with:

* FFmpeg git commit f18ccb529fb7231f9d40814fbf843d10d9434b43
* Xcode 5

Usage
-----

* To build everything:

        ./build-ffmpeg.sh

* To build arm64 libraries:

        ./build-ffmpeg.sh arm64

* To build fat libraries for armv7 and x86_64 (64-bit simulator):

        ./build-ffmpeg.sh armv7 x86_64

* To build fat libraries from separately built thin libraries:

        ./build-ffmpeg.sh lipo
