FFmpeg iOS build script
=======================

This is a shell script to build FFmpeg libraries for iOS apps.

Tested with:

* FFmpeg git commit f18ccb529fb7231f9d40814fbf843d10d9434b43
* Xcode 4.6.3

Usage
-----

* To build armv7s libraries:

        ./build-ffmpeg.sh armv7s

* To build fat libraries for armv7 and i386 (simulator):

        ./build-ffmpeg.sh armv7 i386

* To build fat libraries from separately built thin libraries:

        ./build-ffmpeg.sh lipo
