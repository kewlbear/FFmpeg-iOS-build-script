#!/bin/sh

source common.sh
source config.sh

PrepareYasm

FFMPEG_PLATFORMS="ffmpeg_ios ffmpeg_tvos ffmpeg_macos ffmpeg_maccatalyst"

function Build() {
    local platform=$1
    local arch=$2

    echo "${ORANGE}Building for platform: $platform, arch: $arch ${NOCOLOR}"

	  local current_dir=`pwd`
    local build_dir="$platform/scratch/$arch"
    local thin="$current_dir/$platform/thin"
    local prefix="$thin/$arch"

    mkdir -p "$build_dir"
    cd "$build_dir"

    local xcrun_sdk=`echo $PLATFORM | tr '[:upper:]' '[:lower:]'`
		CC="xcrun -sdk $xcrun_sdk clang"

		# force "configure" to use "gas-preprocessor.pl" (FFmpeg 3.3)
		if [ "$arch" = "arm64" ]
		then
  			AS="gas-preprocessor.pl -arch aarch64 -- $CC"
		else
			  AS="gas-preprocessor.pl -- $CC"
		fi

		CXXFLAGS="$CFLAGS"
		LDFLAGS="$CFLAGS"

		if [ "$X264" ]
		then
			   CFLAGS="$CFLAGS -I$X264/include"
         LDFLAGS="$LDFLAGS -L$X264/lib"
		fi

		if [ "$FDK_AAC" ]
		then
        CFLAGS="$CFLAGS -I$FDK_AAC/include"
        LDFLAGS="$LDFLAGS -L$FDK_AAC/lib"
		fi

		TMPDIR=${TMPDIR/%\/} $current_dir/$SOURCE/configure \
			--target-os=darwin \
			--arch=$arch \
			--cc="$CC" \
			--as="$AS" \
			$CONFIGURE_FLAGS \
			--extra-cflags="$CFLAGS" \
			--extra-ldflags="$LDFLAGS" \
			--prefix="$prefix" \
		|| exit 1

		make -j3 install $EXPORT || exit 1
		cd $current_dir
}

function PackageToLibrary() {
    local platform=$1
    local arch=$2

    echo "${ORANGE}Packaging library for platform: $platform, arch: $arch ${NOCOLOR}"

    local current_dir=`pwd`
    local build_dir="$platform/scratch/$arch"
    local thin_dir="$current_dir/$platform/thin/$arch"

    local object_files="$(FindObjectFiles $build_dir)"

#    echo $object_files

    libtool $LIBTOOL_FLAGS \
        -static -D -arch_only $arch \
        $object_files -o "$thin_dir/$LIBRARY_FILE"
}

function BuildAll() {
    echo "${ORANGE}Building for platforms:${MAGENTA} $FFMPEG_PLATFORMS ${NOCOLOR}"

    for FFMPEG_PLATFORM in $FFMPEG_PLATFORMS
    do
        rm -rf "$FFMPEG_PLATFORM"

        local archs="$(Architectures $FFMPEG_PLATFORM)"
        echo "${ORANGE}>>> Building platform: $FFMPEG_PLATFORM Available ARCHS:${MAGENTA} $archs ${NOCOLOR}"

        for arch in $archs
        do
            Configure $FFMPEG_PLATFORM $arch
            Build $FFMPEG_PLATFORM $arch
            PackageToLibrary $FFMPEG_PLATFORM $arch
        done

    done
}

function CreateXCFramework() {
    echo "${ORANGE}Creating framework: $FFMPEG_PLATFORMS ${NOCOLOR}"

    local framework_arguments=""

    rm -rf $XCFRAMEWORK_FILE

    for FFMPEG_PLATFORM in $FFMPEG_PLATFORMS
    do
        local archs="$(Architectures $FFMPEG_PLATFORM)"

        for arch in $archs
        do
            local thin_dir="$FFMPEG_PLATFORM/thin/$arch"
            local include_dir="$thin_dir/include"

            framework_arguments="$framework_arguments -library $thin_dir/$LIBRARY_FILE"
            framework_arguments="$framework_arguments -headers $include_dir"
        done

    done

    echo $XCFRAMEWORK_FILE

    xcodebuild -create-xcframework \
        $framework_arguments \
        -output "$XCFRAMEWORK_FILE"
}

#BuildAll
CreateXCFramework
