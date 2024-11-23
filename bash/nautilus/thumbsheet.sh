#!/usr/bin/env bash

# Thumbsheet Nautilus script
# Inspiration: https://github.com/nemec/thumbsheet

tile_width='1920'
columns=4
rows=4

tiles=$((columns * rows))
filesize=$(du -h "$1" | awk '{print $1}')
sha256sum=$(sha256sum "$1" | awk '{print $1}')
resolution=$(ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 "$1")
duration=$(ffprobe -v error -sexagesimal -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$1")
framecount=$(ffprobe -v error -select_streams v:0 -count_packets -show_entries stream=nb_read_packets -of csv=p=0 "$1")
frameskip=$((framecount / tiles)) # Divide frames by the amount of tiles in a thumbsheet.

# Get frame at each $frameskip, scale to $tile_width and put in columns * rows sheet.
ffmpeg -y -ss 5 -i "$1" -q:v 2 -vf "select=not(mod(n\,$frameskip)),scale=$tile_width:-1,tile='$columns'x'$rows'" "$1.jpg" >/dev/null 2>&1
convert "$1.jpg" -gravity north -splice 0x85 -gravity northwest -pointsize 13 -quality 100% -annotate +20+5 "Filename: $1\nFilesize $filesize\nSHA-256 checksum: $sha256sum\nResolution: $resolution\nDuration: $duration" "$1.jpg" >/dev/null 2>&1
