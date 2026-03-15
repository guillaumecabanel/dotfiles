#!/bin/bash

pactl $1
VALUE=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+(?=%)' | head -1)
MUTED=$(pactl get-sink-mute @DEFAULT_SINK@ | grep -c "yes")

if [ "$MUTED" -eq 1 ]; then
    notify-send "Volume" "Muted" -t 1500 -r 9992
else
    notify-send "Volume" "" -h int:value:"$VALUE" -t 1500 -r 9992
fi

pkill -SIGRTMIN+3 i3blocks
