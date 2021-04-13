#!/bin/sh 
#
# symup.sh
#
#
# List of entries to ignore
IGNORE=". .. .DS_Store .git"
#
BASEDIR=$(dirname $0)
DOTFILES="dotfiles"

# Loop through dot entries
for ENTRY in "$BASEDIR"/.* 
do
    ENTRYBASE=$(basename $ENTRY)
    ENTRYHOME="$HOME/$ENTRYBASE"
    ENTRYIGNORE=0

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

    # Check for existing symlink
    if [[ -L "$ENTRYHOME" ]]; then
      echo "Symlink $ENTRYBASE found...skipping"

      continue
    fi

    # Check home directory
    if [[ -e "$ENTRYHOME" ]]; then
      echo "Found entry $ENTRYBASE in home directory $HOME"
      
      read -p "Rename and replace with symlink to dotfiles version? " ANS
      
      case $ANS in
	[yY]*) echo "Yes"
	       mv "$ENTRYHOME" "${ENTRYHOME}.old" 
	       ln -s "$DOTFILES/$ENTRYBASE" "$ENTRYHOME" ;;
	*) break ;;
      esac
    else
      read -p "No entry $ENTRYBASE found, add symlink to dotfiles? " ANS

      case $ANS in
        [yY]*) ln -s "$DOTFILES/$ENTRYBASE" "$ENTRYHOME" ;;
	*) break ;;
      esac   
    fi
done
