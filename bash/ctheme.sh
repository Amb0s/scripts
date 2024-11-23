#!/usr/bin/env bash

set -Eeuo pipefail
trap cleanup SIGINT SIGTERM ERR EXIT

usage() {
  cat <<EOF
Usage: $(basename "${BASH_SOURCE[0]}") -p path

Simple theme changer.

Available options:

-h, --help             Print this help and exit
-v, --verbose          Print script debug information
-p, --background-path  Change default background path
EOF
  exit
}

cleanup() {
  trap - SIGINT SIGTERM ERR EXIT
}

msg() {
  echo >&2 -e "${1-}"
}

die() {
  local msg=$1
  local code=${2-1} # Default exit status 1.
  msg "$msg"
  exit "$code"
}

parse_params() {
  background_path="$HOME/.local/share/backgrounds/"

  while :; do
    case "${1-}" in
    -h | --help) usage ;;
    -v | --verbose) set -x ;;
    -p | --background-path)
      background_path="${2-}"
      shift
      ;;
    -?*) die "Unknown option: $1" ;;
    *) break ;;
    esac
    shift
  done

  args=("$@")

  return 0
}

change_color_scheme() {
  gsettings set org.gnome.desktop.background picture-uri $1
  gsettings set org.gnome.desktop.background picture-uri-dark $1
  wal -f ~/.config/wal/colorschemes/dark/$2.json -b $3
  papirus-folders -C $4
}

parse_params "$@"

title="ctheme"
prompt="Choose a theme:"
options=("Ange Ushiromiya" "Youmu Konpaku" "Aya Shameimaru" "Yukino Yukinoshita" "Wasp")

while opt=$(zenity --title="$title" --text="$prompt" --list  --column="Themes" "${options[@]}"); do
    case "$opt" in
    "${options[0]}") change_color_scheme "$background_path/ange.png" "ange" "242424" "red"  && exit ;;
    "${options[1]}") change_color_scheme "$background_path/youmu.png" "youmu" "242424" "magenta"  && exit ;;
    "${options[2]}") change_color_scheme "$background_path/aya.png" "aya" "242424" "deeporange"  && exit ;;
    "${options[3]}") change_color_scheme "$background_path/yukino.png" "yukino" "242424" "bluegrey"  && exit ;;
    "${options[4]}") change_color_scheme "$background_path/wasp.png" "wasp" "242424" "yellow"  && exit ;;
    *) zenity --error --text="Invalid option. Try another one.";;
    esac
done > /dev/null 2>&1
