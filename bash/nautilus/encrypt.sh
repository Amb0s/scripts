#!/usr/bin/env bash

# GPG Encrypt Nautilus script
# Source: https://unix.stackexchange.com/questions/559556/gpg-encryption-in-nautilus-right-click-menu

gpg -c --no-symkey-cache "$1"
