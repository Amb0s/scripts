#!/usr/bin/env bash

# Checksums Nautilus script

if [[ -d $1 ]]; then
    zenity --error --text "Selection is a directory."
    exit 1
fi

md5sum=$(md5sum "$1" | awk '{print $1}')
sha256sum=$(sha256sum "$1" | awk '{print $1}')
sha512sum=$(sha512sum "$1" | awk '{print $1}')

zenity --info --title="$1" --text="MD5: $md5sum\nSHA-256: $sha256sum\nSHA-512: $sha512sum\n"
