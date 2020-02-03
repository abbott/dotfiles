#!/bin/bash

PROMPT='[bootstrap]'
source .export

# Initialize a few things
init () {
	# echo "$PROMPT Making a Code/Scripts folder in $PATH_TO_CODE if it doesn't already exist"
	# mkdir -p "$PATH_TO_CODE"
	echo "$PROMPT Making a Playground folder in $PATH_TO_PLAYGROUND if it doesn't already exist"
	mkdir -p "$PATH_TO_PLAYGROUND"
	echo "$PROMPT Creating "$ETERNAL_HISTORY_FILE" if it doesn't already exist"
	touch "$HOME/$ETERNAL_HISTORY_FILE"
	echo "$PROMPT Initialization complete."
}

# TODO : Delete symlinks to deleted files
# Is this where rsync shines?
# TODO - add support for -f and --force
# abbott: added ln -sf for force
link () {
	echo "$PROMPT This utility will symlink the files in this repo to the home directory"
	echo "$PROMPT Proceed? (y/n)"
	read resp
	# TODO - regex here?
	if [ "$resp" = 'y' -o "$resp" = 'Y' ] ; then
		for file in $( ls -A -sf | grep -vE '\.exclude*|\.git$|\.gitignore|.*.md' ) ; do
			ln -sv "$PWD/$file" "$HOME"
		done
		# TODO: source files here?
		echo "$PROMPT Symlinking complete"
	else
		echo "$PROMPT Symlinking cancelled by user"
		return 1
	fi
}

# abbott: DISABLED (see last line of file) until I have time to customize platform installs
install_tools () {
	if [ $( echo "$OSTYPE" | grep 'darwin' ) ] ; then
		echo "$PROMPT Detected macOS"
		echo "$PROMPT This utility will install useful utilities using Homebrew"
		echo "$PROMPT Proceed? (y/n)"
		read resp
		# TODO - regex here?
		if [ "$resp" = 'y' -o "$resp" = 'Y' ] ; then
			echo "$PROMPT Installing useful stuff using brew. This may take a while..."
			sh brew.exclude.sh
		else
			echo "$PROMPT Brew installation cancelled by user"
		fi
	else
		echo "$PROMPT Skipping installations using Homebrew because MacOS was not detected..."
	fi

	if [ $( echo "$OSTYPE" | grep 'linux-gnu' ) ] ; then
		echo "$PROMPT Detected Linux"
		echo "$PROMPT This utility will install useful utilities using apt (this has been tested on Debian buster)"
		echo "$PROMPT Proceed? (y/n)"
		read resp
		# TODO - regex here?
		if [ "$resp" = 'y' -o "$resp" = 'Y' ] ; then
			echo "$PROMPT Installing useful stuff using apt. This may take a while..."
			sh apt.exclude.sh
		else
			echo "$PROMPT Apt installation cancelled by user"
		fi
	else
		echo "$PROMPT Skipping installations using apt because Debian/Linux was not detected..."
	fi
}

init
link
# install_tools
