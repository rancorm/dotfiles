#!/bin/bash
#
# zzzap.sh [Zap all dotfiles and set git origin]
#

# Exit on error
set -e

# Check if running from dotfiles directory
if [ "${PWD##*/}" != "dotfiles" ]; then
  echo "Run script from the 'dotfiles' directory."
  exit 1
fi

# Origin URL
if [ -z "$1" ]; then
  echo "Usage: $0 <new-origin-url>"
  exit 1
fi

read -n 1 -p "Reset dotfiles and set origin to ${NEW_ORIGIN}?" YN
echo

FIND=$(which find)
GIT=$(which git)

if [[ "$YN" == [Yy] ]]; then
  NEW_ORIGIN="$1"

  # Delete all files and directories except .git, scripts,
  # and files ending with .zap.
  $FIND . -mindepth 1 \
    -not -path "./.git*" \
    -not -name "symup.sh" \
    -not -name "zzzap.sh" \
    -not -name "*.zap" \
    -exec rm -rf {} +

  # Change git origin to new location
  $GIT remote set-url origin "$NEW_ORIGIN"

  # Create blank README.md
  echo "# Dotfiles" >> README.md
  echo "dotfiles" >> README.md

  echo "repository reset!"
  echo "origin set to: $NEW_ORIGIN"
else
  echo "Zorp!"
fi
