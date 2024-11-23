#!/bin/bash

action=$1
process_name=$2
width=$(xrandr --current | grep '*' | uniq | awk '{print $1}' | cut -d 'x' -f1)
height=$(xrandr --current | grep '*' | uniq | awk '{print $1}' | cut -d 'x' -f2)

# find the ID of the main window
window_id=$(xdotool search --class "$process_name" | tail -1)

# set the selected process to fullscreen mode
if [ "$action" == "apply" ]; then
  xdotool set_window --overrideredirect 1 "$window_id"
  xdotool windowunmap "$window_id"
  xdotool windowmap "$window_id"
  xdotool windowmove "$window_id" 0 0
  xdotool windowsize "$window_id" "$width" "$height"
  xdotool windowfocus "$window_id" 
  xdotool click 1
fi

# reset
if [ "$action" == "reset" ]; then                          
  xdotool set_window --overrideredirect 0 "$window_id"
  xdotool windowunmap "$window_id"
  xdotool windowmap "$window_id"
fi
