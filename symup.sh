#!/bin/sh 
#
# symup.sh [] 
#
#
# List of entries to ignore
IGNORE=".DS_Store .git"

#
BASEDIR=$(dirname $0)
DOTFILES="dotfiles"

# Commands
LN=$(which ln)
MV=$(which mv)

# Loop through dot entries
for ENTRY in "$BASEDIR"/.[^.]*
do
    ENTRYBASE=$(basename $ENTRY)
    ENTRYTARGET="$HOME/$ENTRYBASE"
    ENTRYIGNORE=0
    ENTRYDOTFILE="$DOTFILES/$ENTRYBASE"

    # Ignore specific file or directory names
    for IENTRY in $IGNORE
    do 
      if [ "$IENTRY" = "$ENTRYBASE" ]; then
        ENTRYIGNORE=1
      fi
    done

    # Ignore entry
    if [ $ENTRYIGNORE -eq 1 ]; then
      echo "Ignoring entry $ENTRYBASE"
      continue
    fi

    if [[ -h "$ENTRYTARGET" && ($(readlink "$ENTRYTARGET") == "$ENTRYDOTFILE") ]]; then
      echo "\x1B[90m$ENTRYTARGET is symlinked to your dotfiles.\x1B[39m"
    elif [[ -f "$ENTRYTARGET" && $(shasum "$ENTRYTARGET" | awk '{print $2}') == $(shasum "$ENTRYDOTFILE" | awk '{print $2}') ]]; then
      echo "\x1B[32m$ENTRYTARGET exists and was identical to your dotfile. Overriding with symlink.\x1B[39m"

      $LN -s $ENTRYDOTFILE $ENTRYTARGET
    elif [[ -a "$ENTRYTARGET" ]]; then
      read -p "\x1B[33m$ENTRYTARGET exists and differs from your dotfile. Override?  [yn]\x1B[39m" -n 1

      if [[ $REPLY =~ [yY]* ]]; then
        $LN -Fs "$ENTRYDOTFILE" "$ENTRYTARGET"
      fi
    else
      echo "\x1B[32m$ENTRYTARGET does not exist. Symlinking to dotfile.\x1B[39m"
      $LN -s "$ENTRYDOTFILE" "$ENTRYTARGET"
    fi
done
