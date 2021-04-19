#!/bin/sh 
#
# symup.sh [Update home directory dot files symlinks] 
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
      echo "\x1B[93mIgnoring entry $EBASE"
      continue
    fi

    # Check for existing symlink, create and/or update symlink in home directory
    if [[ -h "$ETARGET" && ($(readlink "$ETARGET") == "$EDOTFILE") ]]; then
      echo "\x1B[92m$ETARGET is linked to your dotfiles.\x1B[39m"
    elif [[ -f "$ETARGET" && $(checksum "$ETARGET" | awk '{print $2}') == $(checksum "$EDOTFILE" | awk '{print $2}') ]]; then
      echo "\x1B[93m$ETARGET exists and was identical to your dotfile. Overriding with symlink.\x1B[39m"

      symlink "$EDOTFILE" "$HOME"
    elif [[ -a "$ETARGET" ]]; then
      read -p "\x1B[91m$ETARGET exists and differs from your dotfile. Override? [yn]\x1B[39m" -n 1

      if [[ "$REPLY" =~ [yY]* ]]; then
        symlink "$EDOTFILE" "$HOME"
      fi
    else
      echo "\x1B[92m$ETARGET does not exist. Linking to it's dotfile.\x1B[39m"
      symlink "$EDOTFILE" "$HOME"
    fi
done
