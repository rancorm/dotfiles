#!/bin/bash
#
# symup.sh [Dotfile symlink manager] 
#
#
# List of entries to ignore
IGNORE=".DS_Store .git .gitignore"

# Name of target dotfiles directory
DOTFILES="dotfiles"

# Paths of commands and script 
BASEDIR=$(dirname $0)
LN=$(which ln)
SHASUM=$(which shasum)

function symlink {
  $LN -nsf $1 $2
}

function checksum {
  $SHASUM -a 512 $1
}

# Loop through dot entries
for ENTRY in "$BASEDIR"/.[^.]*
do
    EBASE=$(basename $ENTRY)
    ETARGET="$HOME/$EBASE"
    EIGNORE=0
    EDOTFILE="$DOTFILES/$EBASE"

    # Ignore specific file or directory names
    for IENTRY in $IGNORE
    do 
      if [ "$IENTRY" = "$EBASE" ]; then
        EIGNORE=1
      fi
    done

    # Ignore entry
    if [ $EIGNORE -eq 1 ]; then
      echo -e "\x1B[93mIgnoring entry $EBASE\x1B[39m"
      continue
    fi

    # Check for ~/.config directory
    if [ "$EBASE" = ".config" ]; then
	echo -e "\x1B[92m$ETARGET is a directory. Symlinking subdirectories.\x1B[39m"
	
	# Loop through subdirectories of ~/.config
	for SUBENTRY in "$ENTRY"/*
	do
	    SUBBASE=$(basename "$SUBENTRY")
	    SUBTARGET="$HOME/.config/$SUBBASE"
	    SUBDOTFILE="../$DOTFILES/.config/$SUBBASE"

	    # Check for existing symlink, create and/or update symlink in home directory
	    if [[ -h "$SUBTARGET" && ($(readlink "$SUBTARGET") == "$SUBDOTFILE") ]]; then
		echo -e "\x1B[92m$SUBTARGET is linked to your dotfiles.\x1B[39m"
	    elif [[ -a "$SUBTARGET" ]]; then
		read -p "$SUBTARGET exists and differs from your dotfile. Override? [yN] " REPLY

		# Check answer
		if [[ "$REPLY" =~ ^([yY]*)$ ]]; then
		    symlink "$SUBDOTFILE" "$HOME/.config"
		fi
	    else
		echo -e "\x1B[92m$SUBTARGET does not exist. Linking to its dotfile.\x1B[39m"
		symlink "$SUBDOTFILE" "$HOME/.config"
	    fi
	done
    else
	# Check for existing symlink, create and/or update symlink in home directory
	if [[ -h "$ETARGET" && ($(readlink "$ETARGET") == "$EDOTFILE") ]]; then
	    echo -e "\x1B[92m$ETARGET is linked to your dotfiles.\x1B[39m"
	elif [[ -f "$ETARGET" && $(checksum "$ETARGET" | awk '{print $2}') == $(checksum "$EBASE" | awk '{print $2}') ]]; then
	    echo -e "\x1B[93m$ETARGET exists and was identical to your dotfile. Overriding with symlink.\x1B[39m"
	    symlink "$EDOTFILE" "$HOME"
	elif [[ -a "$ETARGET" ]]; then
	    read -p "$ETARGET exists and differs from your dotfile. Override? [yN] " REPLY

	    # Check answer
	    if [[ "$REPLY" =~ ^([yY]*)$ ]]; then
		symlink "$EDOTFILE" "$HOME"
	    fi
	else
	    echo -e "\x1B[92m$ETARGET does not exist. Linking to its dotfile.\x1B[39m"
	    symlink "$EDOTFILE" "$HOME"
	fi
    fi
done
