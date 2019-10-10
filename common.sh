#!/bin/sh

ORANGE="\033[1;93m"
RED="\033[1;91m"
MAGENTA="\033[1;35m"
NOCOLOR="\033[0m"

function PrepareYasm() {
    if [ ! `which yasm` ]
	  then
		    echo 'Yasm not found'

        if [ ! `which brew` ]
        then
            echo "${RED}Homebrew not found. Trying to install... ${NOCOLOR}"
				    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" \
		        || exit 1
        fi

        echo 'Trying to install Yasm...'
        brew install yasm || exit 1
    fi

	  if [ ! `which gas-preprocessor.pl` ]
	  then
		    echo "${RED}gas-preprocessor.pl not found. Trying to install... ${NOCOLOR}"
		    (curl -L https://github.com/libav/gas-preprocessor/raw/master/gas-preprocessor.pl \
		          -o /usr/local/bin/gas-preprocessor.pl \
			        && chmod +x /usr/local/bin/gas-preprocessor.pl) \
			  || exit 1
	  fi

    if [ ! -r $SOURCE ]
	  then
		    echo "${RED}FFmpeg source not found ${NOCOLOR}"
        exit 1
	  fi
}

function FindObjectFiles() {
    local search_dir=$1

	  local object_files=""

	  local name=$(find $search_dir -maxdepth 3 -name "*.o")
	  object_files="$object_files $name"

    echo $object_files
}
