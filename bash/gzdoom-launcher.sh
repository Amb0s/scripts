#!/usr/bin/env bash

set -Eeuo pipefail
trap cleanup SIGINT SIGTERM ERR EXIT

usage() {
  cat <<EOF
Usage: $(basename "${BASH_SOURCE[0]}")

Simple GZDoom launcher.

Available options:

-h, --help             Print this help and exit
-v, --verbose          Print script debug information
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
  while :; do
    case "${1-}" in
    -h | --help) usage ;;
    -v | --verbose) set -x ;;
    -?*) die "Unknown option: $1" ;;
    *) break ;;
    esac
    shift
  done

  args=("$@")

  return 0
}

parse_params "$@"

title="GZDoom launcher"
prompt="Choose a game to run:"
options=("Doom" "Doom II" "Freedoom: Phase 1" "Freedoom: Phase 2" "I Am Sakuya: Touhou FPS Game" "Snap the Sentinel" "The Adventures of Square" "Brutal Doom Platinum" "The 10x10 Project" "Nobody Told Me About id" "Metroid" "Doom: The Golden Souls" "Lycanthorn II" "Brutal Wolfenstein 3D" "Unfamiliar" "Wolfenstein 3D" "Reelism" "Reelism 2" "Doom 64" "Touhou Doom" "Doom Infinite")

while opt=$(zenity --title="$title" --text="$prompt" --list  --column="Games" "${options[@]}"); do
    case "$opt" in
    "${options[0]}") gzdoom -iwad "$HOME/.local/share/gzdoom/id/DOOM.WAD" -config "$HOME/.config/gzdoom/doom1.ini" && exit ;;
    "${options[1]}") gzdoom -iwad "$HOME/.local/share/gzdoom/id/DOOM2.WAD" -config "$HOME/.config/gzdoom/doom2.ini" && exit ;;
    "${options[2]}") gzdoom -iwad "$HOME/.local/share/gzdoom/custom/freedoom/freedoom1.wad" -config "$HOME/.config/gzdoom/freedoom1.ini" && exit ;;
    "${options[3]}") gzdoom -iwad "$HOME/.local/share/gzdoom/custom/freedoom/freedoom2.wad" -config "$HOME/.config/gzdoom/freedoom2.ini" && exit ;;
    "${options[4]}") gzdoom -iwad "$HOME/.local/share/gzdoom/custom/iamsakuya/I Am Sakuya.iwad" -config "$HOME/.config/gzdoom/iamsakuya.ini" && exit ;;
    "${options[5]}") gzdoom -iwad "$HOME/.local/share/gzdoom/custom/snap/snapgame.ipk3" -config "$HOME/.config/gzdoom/snap.ini" && exit ;;
    "${options[6]}") gzdoom -iwad "$HOME/.local/share/gzdoom/custom/square/square1.pk3" -config "$HOME/.config/gzdoom/square.ini" && exit ;;
    "${options[7]}") gzdoom -iwad "$HOME/.local/share/gzdoom/id/DOOM.WAD" -file "$HOME/.local/share/gzdoom/custom/brutal_doom_platinum/BrutalDoomPlatinumv4.0.pk3" -config "$HOME/.config/gzdoom/brutaldoomplatinum.ini" && exit ;;
    "${options[8]}") gzdoom -iwad "$HOME/.local/share/gzdoom/id/DOOM2.WAD" -file "$HOME/.local/share/gzdoom/custom/10x10/10X10.wad" -config "$HOME/.config/gzdoom/10x10.ini" && exit ;;
    "${options[9]}") gzdoom -iwad "$HOME/.local/share/gzdoom/id/DOOM2.WAD" -file "$HOME/.local/share/gzdoom/custom/NTMAi/NTMAi.pk3" -config "$HOME/.config/gzdoom/ntmai.ini" && exit ;;
    "${options[10]}") gzdoom -iwad "$HOME/.local/share/gzdoom/id/DOOM2.WAD" -file "$HOME/.local/share/gzdoom/custom/metroid/met2.pk3" -config "$HOME/.config/gzdoom/metroid.ini" && exit ;;
    "${options[11]}") gzdoom -iwad "$HOME/.local/share/gzdoom/id/DOOM2.WAD" -file "$HOME/.local/share/gzdoom/golden_souls/GoldenSouls_Remastered_V1.0_hotfix.pk3" -config "$HOME/.config/gzdoom/goldensouls.ini" && exit ;;
    "${options[12]}") gzdoom -iwad "$HOME/.local/share/gzdoom/lycanthorn2/shrine.ipk3 " -config "$HOME/.config/gzdoom/lycanthorn2.ini" && exit ;;
    "${options[13]}") gzdoom -iwad "$HOME/.local/share/gzdoom/id/DOOM2.WAD" -file "$HOME/.local/share/gzdoom/brutal_wolf3d/ZMC-BWV7.0.pk3" -config "$HOME/.config/gzdoom/brutalwolf3d.ini" && exit ;;
    "${options[14]}") gzdoom -iwad "$HOME/.local/share/gzdoom/id/DOOM2.WAD" -file "$HOME/.local/share/gzdoom/unfamiliar/UF_EP3.pk3" -config "$HOME/.config/gzdoom/unfamiliar.ini" && exit ;;
    "${options[15]}") gzdoom -iwad "$HOME/.local/share/gzdoom/custom/wolf3d/Wolf3D.ipk3" -config "$HOME/.config/gzdoom/wolf3d.ini" && exit ;;
    "${options[16]}") gzdoom -iwad "$HOME/.local/share/gzdoom/id/DOOM2.WAD" -file "$HOME/.local/share/gzdoom/custom/reelism/reelism_x3.1.pk3" -config "$HOME/.config/gzdoom/reelism.ini" && exit ;;
    "${options[17]}") gzdoom -iwad "$HOME/.local/share/gzdoom/id/DOOM2.WAD" -file "$HOME/.local/share/gzdoom/custom/reelism2/reelism2_v1.23hf.pk3" -config "$HOME/.config/gzdoom/reelism2.ini" && exit ;;
    "${options[18]}") gzdoom -iwad "$HOME/.local/share/gzdoom/custom/doom64/D64D2_v1.4" -config "$HOME/.config/gzdoom/doom64.ini" && exit ;;
    "${options[19]}") gzdoom -iwad "$HOME/.local/share/gzdoom/id/DOOM2.WAD" -file "$HOME/.local/share/gzdoom/custom/touhou/TouhouDoom_v1.24.pk3" -config "$HOME/.config/gzdoom/touhoudoom.ini" && exit ;;
    "${options[20]}") gzdoom -iwad "$HOME/.local/share/gzdoom/id/DOOM2.WAD" -file "$HOME/.local/share/gzdoom/custom/infinite/DOOM_Infinite_DEMO_0978_6.pk3" -config "$HOME/.config/gzdoom/doominfinite.ini" && exit ;;
    *) zenity --error --text="Invalid option. Try another one.";;
    esac
done > /dev/null 2>&1
