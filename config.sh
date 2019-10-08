#!/bin/sh

FF_VERSION="4.1"
#FF_VERSION="snapshot-git"
if [[ $FFMPEG_VERSION != "" ]]; then
  FF_VERSION=$FFMPEG_VERSION
fi

SOURCE="../"
XCODE_PATH=$(xcode-select -p)
LIBRARY_NAME="FFMpeg"
LIBRARY_FILE="$LIBRARY_NAME.a"

XCFRAMEWORK_FILE="$LIBRARY_NAME.xcframework"

CONFIGURE_FLAGS="\
				--enable-cross-compile \
				--disable-debug --disable-programs --disable-doc \
				--disable-encoders --disable-decoders --disable-protocols --disable-filters  \
				--disable-muxers --disable-bsfs --disable-indevs --disable-outdevs --disable-demuxers \
				--enable-pic \
				--enable-decoder=h264 \
				--enable-demuxer=mpegts \
				--enable-parser=h264 \
				--enable-videotoolbox"

if [ "$X264" ]
then
		CONFIGURE_FLAGS="$CONFIGURE_FLAGS --enable-gpl --enable-libx264"
fi

if [ "$FDK_AAC" ]
then
		CONFIGURE_FLAGS="$CONFIGURE_FLAGS --enable-libfdk-aac --enable-nonfree"
fi

function ConfigureForIOS() {
		local arch=$1
		DEPLOYMENT_TARGET="9.0"
		PLATFORM="iPhoneOS"

    LIBTOOL_FLAGS="\
		 -syslibroot $XCODE_PATH/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk \
		 -L$XCODE_PATH/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk/System/iOSSupport/usr/lib"

    CFLAGS="-arch $arch"

		if [ "$arch" = "i386" -o "$arch" = "x86_64" ]
		then
				PLATFORM="iPhoneSimulator"
				CFLAGS="$CFLAGS -mios-simulator-version-min=$DEPLOYMENT_TARGET"
				CONFIGURE_FLAGS="$CONFIGURE_FLAGS --disable-asm"
		else
				CFLAGS="$CFLAGS -mios-version-min=$DEPLOYMENT_TARGET -fembed-bitcode"
				if [ "$ARCH" = "arm64" ]
				then
						EXPORT="GASPP_FIX_XCODE5=1"
				fi
		fi
}

function ConfigureForTVOS() {
		local arch=$1
		DEPLOYMENT_TARGET="12.0"
		PLATFORM="AppleTVOS"

    LIBTOOL_FLAGS="\
		 -syslibroot $XCODE_PATH/Platforms/AppleTVOS.platform/Developer/SDKs/AppleTVOS.sdk \
		 -L$XCODE_PATH/Platforms/AppleTVOS.platform/Developer/SDKs/AppleTVOS.sdk/System/usr/lib"

    CFLAGS="-arch $arch"

		if [ "$arch" = "i386" -o "$arch" = "x86_64" ]
		then
				PLATFORM="AppleTVSimulator"
				CFLAGS="$CFLAGS -mtvos-simulator-version-min=$DEPLOYMENT_TARGET"
				CONFIGURE_FLAGS="$CONFIGURE_FLAGS --disable-asm"
		else
				CFLAGS="$CFLAGS -mtvos-version-min=$DEPLOYMENT_TARGET -fembed-bitcode"
				if [ "$ARCH" = "arm64" ]
				then
						EXPORT="GASPP_FIX_XCODE5=1"
				fi
		fi
}

function ConfigureForMacOS() {
		local arch=$1
		DEPLOYMENT_TARGET="10.14"
		PLATFORM="MacOSX"

    LIBTOOL_FLAGS="\
		 -syslibroot $XCODE_PATH/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk \
		 -L$XCODE_PATH/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/usr/lib"

    CFLAGS="-arch $arch"
		CONFIGURE_FLAGS="$CONFIGURE_FLAGS --disable-asm"
		CFLAGS="$CFLAGS -mmacosx-version-min=$DEPLOYMENT_TARGET"
}

function ConfigureForMacCatalyst() {
		local arch=$1
		DEPLOYMENT_TARGET="10.15"
		PLATFORM="iPhoneOS"

    LIBTOOL_FLAGS="\
		-syslibroot $XCODE_PATH/MacOSX.platform/Developer/SDKs/MacOSX10.15.sdk \
		-L$XCODE_PATH/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.15.sdk/System/iOSSupport/usr/lib \
		-L$XCODE_PATH/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/maccatalyst"

		CFLAGS="-arch $arch"
		CONFIGURE_FLAGS="$CONFIGURE_FLAGS --disable-asm"

		CFLAGS="$CFLAGS -target x86_64-apple-ios13.0-macabi \
						-isysroot $XCODE_PATH/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk \
						-isystem $XCODE_PATH/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/iOSSupport/usr/include \
						-iframework $XCODE_PATH/Platforms/MacOSX.platform/Developer/SDKs/MacOS.sdk/System/iOSSupport/System/Library/Frameworks"

		LDFLAGS="$LDFLAGS -target x86_64-apple-ios13.0-macabi \
				-isysroot $XCODE_PATH/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk \
				-L$XCODE_PATH/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/iOSSupport/usr/lib \
				-L$XCODE_PATH/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/maccatalyst \
				-iframework $XCODE_PATH/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/iOSSupport/System/Library/Frameworks"
}

# supported platforms are: "ffmpeg_ios", "ffmpeg_tvos", "ffmpeg_macos", "ffmpeg_maccatalyst"

function Architectures() {
		local platform=$1

		case $platform in
				ffmpeg_ios)					echo "arm64 x86_64" ;;
				ffmpeg_tvos) 				echo "arm64 x86_64" ;;
				ffmpeg_macos)				echo "x86_64" ;;
				ffmpeg_maccatalyst)	echo "x86_64" ;;
		esac
}

function Configure() {
		local platform=$1
		local arch=$2

		echo "${ORANGE}Configuring for platform: $platform, arch: $arch"

		case $platform in
				ffmpeg_ios)					ConfigureForIOS $arch ;;
				ffmpeg_tvos) 				ConfigureForTVOS $arch ;;
				ffmpeg_macos)				ConfigureForMacOS $arch ;;
				ffmpeg_maccatalyst)	ConfigureForMacCatalyst $arch ;;
		esac
}
