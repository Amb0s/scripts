#!/usr/bin/env bash

# GPG Decrypt Nautilus script
# Source: https://unix.stackexchange.com/questions/559556/gpg-encryption-in-nautilus-right-click-menu

ext=`echo "$1" | grep [.]gpg`
if [ "$ext" != "" ]; then
    gpg --batch --yes --no-symkey-cache "$1"
else
    zenity --error --text "The selected file is not encrypted."
fi
