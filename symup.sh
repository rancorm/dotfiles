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

function checksums_match {
  local file1="$1"
  local file2="$2"
  [ "$(checksum "$file1" | awk '{print $1}')" = "$(checksum "$file2" | awk '{print $1}')" ]
}

function symlink_matches {
  local symlink_path="$1"
  local expected_target="$2"
  [ "$(readlink "$symlink_path")" = "$expected_target" ]
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

    # Check for directory
    if [ -d "$EBASE" ]; then
	echo -e "\x1B[91m$ETARGET is a directory. Symlinking subdirectories.\x1B[39m"
	
	# Loop through subdirectories
	for SUBENTRY in "$ENTRY"/*
	do
	    SUBBASE=$(basename "$SUBENTRY")
	    SUBTARGET="$ETARGET/$SUBBASE"
	    SUBDOTFILE="$HOME/$EDOTFILE/$SUBBASE"

	    # Make high-level directory if it doesn't exist
	    if [ ! -d $ETARGET ]; then
		mkdir $ETARGET
	    fi

	    # Check for existing symlink, create and/or update symlink in home directory
	    if [ -h "$SUBTARGET" ] && symlink_matches "$SUBTARGET" "$SUBDOTFILE"; then
		echo -e "\x1B[90m$SUBTARGET is linked to your dotfiles.\x1B[39m"
	    elif [[ -a "$SUBTARGET" ]]; then
		read -p "$SUBTARGET exists and differs from your dotfile. Override? [yN] " REPLY

		# Check answer
		if [[ "$REPLY" =~ ^([yY]*)$ ]]; then
		    echo -e "\x1B[93mRenaming $ETARGET to ${ETARGET}.orig\x1B[39m"

		    # Rename original
		    mv "$ETARGET" "${ETARGET}.orig"
		    symlink "$SUBDOTFILE" "$ETARGET"
		fi
	    else
		echo -e "\x1B[92m$SUBTARGET does not exist. Linking to its dotfile.\x1B[39m"
		
		symlink "$SUBDOTFILE" "$ETARGET"
	    fi
	done
    else
	# Check for existing symlink, create and/or update symlink in home directory
	if [ -h "$ETARGET" ] && symlink_matches "$ETARGET" "$EDOTFILE"; then
	    echo -e "\x1B[90m$ETARGET is linked to your dotfiles.\x1B[39m"
	elif [ -f "$ETARGET" ] && checksums_match "$ETARGET" "$ENTRY"; then
	    echo -e "\x1B[93m$ETARGET exists and was identical to your dotfile. Overriding with symlink.\x1B[39m"
	    
	    symlink "$EDOTFILE" "$HOME"
	elif [[ -a "$ETARGET" ]]; then
	    read -p "$ETARGET exists and differs from your dotfile. Override? [yN] " REPLY

	    # Check answer
	    if [[ "$REPLY" =~ ^([yY]*)$ ]]; then
		echo -e "\x1B[93mRenaming $ETARGET to ${ETARGET}.orig\x1B[39m"
	
		# Rename original
		mv $ETARGET ${ETARGET}.orig
		symlink "$EDOTFILE" "$HOME"
	    fi
	else
	    echo -e "\x1B[92m$ETARGET does not exist. Linking to its dotfile.\x1B[39m"
	    
	    symlink "$EDOTFILE" "$HOME"
	fi
    fi
done
